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
    private var pokemon: Pokemon? {
        didSet {
            idLabel.text = pokemon?.id.flatMap { String(format: "編號： %03d", $0) }
            nameLabel.text = pokemon?.name.flatMap { "\($0)" }
            heightLabel.text = pokemon?.height.flatMap { "身高： \(Double($0) * 10.0) cm" }
            weightLabel.text = pokemon?.weight.flatMap { "體重： \(Double($0) / 10.0) kg" }
            let types = pokemon?.types?.compactMap { $0.type?.name }.joined(separator: ", ") ?? ""
            typeLabel.text = "屬性： \(types)"
        }
    }

    private lazy var scrollView = UIScrollView(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var imageView = UIImageView(frame: .zero)
    private lazy var idLabel = UILabel(frame: .zero)
    private lazy var nameLabel = UILabel(frame: .zero)
    private lazy var heightLabel = UILabel(frame: .zero)
    private lazy var weightLabel = UILabel(frame: .zero)
    private lazy var typeLabel = UILabel(frame: .zero)
    
    init(pokemonId: Int, connectionService: ConnectionService) {
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
        
        let stackViewSubviews = [nameLabel, idLabel, heightLabel, weightLabel, typeLabel]
        stackViewSubviews.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func customizeSubviews() {
        view.backgroundColor = .white
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        
        imageView.contentMode = .scaleAspectFill
        let image = String(format: imageURLTemplate, pokemonId)
        imageView.setImage(url: URL(string: image))
        stackView.setCustomSpacing(10, after: imageView)
        
        idLabel.textColor = .black
        idLabel.font = .systemFont(ofSize: 16)
        
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 32)
        
        stackView.setCustomSpacing(10, after: nameLabel)

        heightLabel.textColor = .black
        heightLabel.font = .systemFont(ofSize: 16)

        weightLabel.textColor = .black
        weightLabel.font = .systemFont(ofSize: 16)

        typeLabel.textColor = .black
        typeLabel.font = .systemFont(ofSize: 16)
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