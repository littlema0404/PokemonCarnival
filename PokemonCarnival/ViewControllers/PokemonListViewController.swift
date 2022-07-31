//
//  PokemonListViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import Combine
import UIKit

class PokemonListViewController: UIViewController {
    private let cellHeight: CGFloat = 76
    private let connectionService: ConnectionService
    
    private var cancellables: Set<AnyCancellable> = []
    private var pokemons: [Pokemon] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    
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
        setupRequests()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
    }
    
    private func customizeSubviews() {
        navigationItem.title = "Pokemon Carnival"
        
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: String(describing: PokemonTableViewCell.self))
        tableView.dataSource = self
        tableView.rowHeight = cellHeight
    }
    
    private func setupRequests() {
        connectionService.fetchPokemons().sink(receiveCompletion: { result in
            switch result {
            case .finished:
                print("finished")
            case .failure(let error):
                print("failure \(error)")
            }
        }, receiveValue: { [weak self] value in
            self?.pokemons = value
        }).store(in: &cancellables)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: String(describing: PokemonTableViewCell.self), for: indexPath)
    }
}
