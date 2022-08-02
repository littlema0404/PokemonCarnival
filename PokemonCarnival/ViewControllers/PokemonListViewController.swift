//
//  PokemonListViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Combine
import UIKit

class PokemonListViewController: UIViewController {
    private let imageURLTemplate = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/%@.png"
    private let cellHeight: CGFloat = 76
    private let connectionService: ConnectionService
    private let paginator: Paginator<Pokemon>

    private var cancellables: Set<AnyCancellable> = []
    private var pokemons: [Pokemon] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
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
        navigationItem.title = "Pokemon Carnival"
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: String(describing: PokemonTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
    }
    
    private func setupBinding() {
        paginator.$items
            .saveToCoreData()
            .sink(receiveValue: { [weak self] value in
            self?.pokemons = value
        }).store(in: &cancellables)
    }
    
    private func setupRequests() {
        paginator.loadNext()
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
            let image = pokemon.id.flatMap { String(format: imageURLTemplate, $0) }
            let isLiked = pokemon.id.flatMap {  ManagedPokenmon.query(id: $0)?.isLiked }
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
}

extension PokemonListViewController: PokemonTableViewCellDelegate {
    func pokemonTableViewCellLikeButtonDidTapped(cell: PokemonTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        pokemons[index.row].isLiked = cell.isLiked
    }
}
