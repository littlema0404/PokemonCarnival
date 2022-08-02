//
//  PokemonDetailViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    private let imageURLTemplate = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/%i.png"
    private let connectionService: ConnectionService

    private var cancellables: Set<AnyCancellable> = []
    private var pokemonId: Int
    private var pokemonId: String
    private var pokemon: Pokemon?

    private lazy var scrollView = UIScrollView(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var imageView = UIImageView(frame: .zero)

    init(pokemonId: String, connectionService: ConnectionService) {
        self.pokemonId = pokemonId
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
        view.addSubview(scrollView, anchors: [.top(0), .leading(0), .trailing(0), .bottom(0)])
        
        scrollView.addSubview(stackView, anchors: [.top(0), .bottom(0), .centerX(0)])
        stackView.activate(anchors: [.relative(attribute: .width, relatedTo: .width, constant: -40)], relativeTo: scrollView)
        
        stackView.addArrangedSubview(imageView)
        imageView.activate(anchors: [.relative(attribute: .height, relatedTo: .width, constant: 0)], relativeTo: imageView)
    }
    
    private func customizeSubviews() {        
        view.backgroundColor = .white
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        imageView.contentMode = .scaleAspectFill
        let image = String(format: imageURLTemplate, pokemonId)
        imageView.setImage(url: URL(string: image))
    }
    
    private func setupRequests() {
        connectionService.fetchPokemon(id: pokemonId)
            .saveToCoreData()
            .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] pokemon in
            self?.pokemon = pokemon
        }).store(in: &cancellables)
    }
}
