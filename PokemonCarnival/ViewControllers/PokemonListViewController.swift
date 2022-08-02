//
//  PokemonListViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Combine
import UIKit

class PokemonListViewController: UIViewController {
    private let imageURLTemplate = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/%i.png"
    private let cellHeight: CGFloat = 76
    private let connectionService: ConnectionService
    private let paginator: Paginator<GenericItem>

    private var cancellables: Set<AnyCancellable> = []
    private var pokemons: [Pokemon] = []
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var refreshControl = UIRefreshControl(frame: .zero)
    private var stateView: StateView?

    private lazy var fetchedResultsManager: FetchedResultsManager<ManagedPokenmon, PokemonListViewController> = {
        let sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedPokenmon.itemId), ascending: true)]
        return FetchedResultsManager(fetcher: ManagedObjectsFetcher(fetchRequest: ManagedPokenmon.fetchRequest(), sortDescriptors: sortDescriptors))
    }()
    
    init(connectionService: ConnectionService) {
        self.connectionService = connectionService
        self.paginator = connectionService.pokemonsPaginator()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        customizeSubviews()
        setupBinding()
        setupRequests()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
    }
    
    private func customizeSubviews() {
        view.backgroundColor = .white
        
        navigationItem.title = "Pokemon Carnival"
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.text.square"), style: .plain, target: self, action: #selector(likeBarButtonItemTapped))
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: String(describing: PokemonTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: String(describing: PokemonTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
    }
    
    private func setupBinding() {
        paginator.$items
            .dropFirst(1)
            .map({ items -> Published<[Pokemon]>.Publisher.Output in
                items.compactMap { item in
                    if let url = item.url.flatMap({ URL(string: $0) }) {
                        let parser = URLParser(url: url, domain: self.connectionService.networkProvider.apiEntryPoint)
                        switch parser.targetType {
                        case .pokemon(var pokemon):
                            pokemon.name = item.name
                            return pokemon
                        case .undefined:
                            break
                        }
                    }
                    return nil
                }
            })
            .saveToCoreData()
            .sink(receiveValue: { [weak self] value in
                if let refreshControl = self?.refreshControl, refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
                self?.tableView.stopLoading()
                self?.updateContent(pokemons: value, isFailure: false)
            }).store(in: &cancellables)
        
        paginator.$isFailure
            .dropFirst(1)
            .sink(receiveValue: { [weak self] isFailure in
            self?.updateContent(pokemons: self?.pokemons ?? [], isFailure: isFailure)
        }).store(in: &cancellables)
    }
    
    private func setupRequests() {
        fetchedResultsManager.delegate = self
        
        tableView.startLoading()
        paginator.loadNext()
    }
    
    private func updateContent(pokemons: [Pokemon], isFailure: Bool) {
        if isFailure || pokemons.isEmpty {
            if stateView == nil {
                let stateView = StateView(frame: .zero)
                view.addSubview(stateView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
                self.stateView = stateView
            }
            stateView?.delegate = self
            stateView?.state = isFailure ? .failure : .empty
        } else if let stateView = stateView {
            stateView.removeFromSuperview()
            self.stateView = nil
        }
        
        self.pokemons = pokemons
        tableView.isHidden = pokemons.isEmpty
        tableView.reloadData()
    }
    
    @objc private func refresh() {
        if let stateView = stateView {
            stateView.removeFromSuperview()
            self.stateView = nil
        }
        
        paginator.reset()
        pokemons = []
        tableView.reloadData()
        
        paginator.loadNext()
    }
    
    @objc private func likeBarButtonItemTapped() {
        let viewController = LikedPokemonsViewController(connectionService: connectionService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PokemonTableViewCell.self), for: indexPath)
        
        if let pokemonCell = cell as? PokemonTableViewCell {
            let pokemon = pokemons[indexPath.row]
            let image = String(format: imageURLTemplate, pokemon.id)
            let isLiked = ManagedPokenmon.query(id: pokemon.id)?.isLiked
            pokemonCell.configure(name: pokemon.name, image: image, isLiked: isLiked)
            pokemonCell.delegate = self
        }
        
        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if pokemons.count - indexPath.row < 3 {
            paginator.loadNext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = pokemons[indexPath.row]
        let viewController = PokemonDetailViewController(pokemon: pokemon, connectionService: connectionService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PokemonListViewController: PokemonTableViewCellDelegate {
    func pokemonTableViewCellLikeButtonDidTapped(cell: PokemonTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        pokemons[index.row].isLiked = cell.isLiked
    }
}

extension PokemonListViewController: StateViewDelegate {
    func stateViewConfirmButtonDidTap(_ stateView: StateView) {
        tableView.startLoading()
        refresh()
    }
}

extension PokemonListViewController: FetchedResultsManagerDelegate {
    typealias Object = ManagedPokenmon
    
    func managerDidUpdateObject(_ object: ManagedPokenmon) {
        let pokemon = Pokemon(managedPokenmon: object)
        
        guard let index = pokemons.firstIndex(where: { $0.id == pokemon.id }),
              pokemons[index].isLiked != pokemon.isLiked else { return }
        pokemons[index] = pokemon
        tableView.reloadData()
    }
}
