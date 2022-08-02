//
//  LikedPokemonsViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import UIKit
import CoreData

class LikedPokemonsViewController: UIViewController {
    private let imageURLTemplate = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/%i.png"
    private let cellHeight: CGFloat = 76
    private let connectionService: ConnectionService

    private var pokemons: [Pokemon] = [] {
        didSet {
            tableView.reloadData()
            
            if pokemons.isEmpty {
                let stateView = StateView(frame: .zero)
                view.addSubview(stateView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
                stateView.state = .empty
                self.stateView = stateView
            }
        }
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var stateView: StateView?

    private lazy var managedObjectsFetcher: ManagedObjectsFetcher<ManagedPokenmon> = {
        let sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedPokenmon.itemId), ascending: true)]
        let predicate = NSPredicate(format: "%K = %d",  #keyPath(ManagedPokenmon.isLiked), true)
        return ManagedObjectsFetcher(fetchRequest: ManagedPokenmon.fetchRequest(), sortDescriptors: sortDescriptors, predicate: predicate)
    }()
    
    init(connectionService: ConnectionService) {
        self.connectionService = connectionService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        customizeSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
    }
    
    private func customizeSubviews() {
        pokemons = managedObjectsFetcher.fetchedObjects().map { Pokemon(managedPokenmon: $0) }
        navigationItem.title = "Liked Pokemons"

        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: String(describing: PokemonTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
    }
}

extension LikedPokemonsViewController: UITableViewDataSource {
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

extension LikedPokemonsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let pokemon = pokemons[indexPath.row]
        let viewController = PokemonDetailViewController(pokemon: pokemon, connectionService: connectionService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LikedPokemonsViewController: PokemonTableViewCellDelegate {
    func pokemonTableViewCellLikeButtonDidTapped(cell: PokemonTableViewCell) {
        guard let index = tableView.indexPath(for: cell) else { return }
        
        pokemons[index.row].isLiked = cell.isLiked
    }
}
