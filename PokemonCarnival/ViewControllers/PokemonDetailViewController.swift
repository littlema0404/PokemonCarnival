//
//  PokemonDetailViewController.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import UIKit
import Combine

class PokemonDetailViewController: UIViewController {
    private let connectionService: ConnectionService

    private var cancellables: Set<AnyCancellable> = []
    private var pokemon: Pokemon {
        didSet {
            idLabel.text = String(format: "編號： %03d", pokemon.id)
            nameLabel.text = "\(pokemon.name ?? "-")"
            heightLabel.text = pokemon.height.flatMap { "身高： \($0 * 10.0) cm" }
            weightLabel.text = pokemon.weight.flatMap { "體重： \($0 / 10.0) kg" }
            let types = pokemon.types?.compactMap { $0.name }.joined(separator: ", ") ?? "-"
            typeLabel.text = "屬性： \(types)"
            
            coverImageView.setImage(url: pokemon.coverImage.flatMap { URL(string: $0) })
            thumbnailImageView.setImage(url: pokemon.frontDefaultImage.flatMap { URL(string: $0) })
        }
    }

    private lazy var scrollView = UIScrollView(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var coverImageView = UIImageView(frame: .zero)
    private lazy var thumbnailImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    private lazy var idLabel = UILabel(frame: .zero)
    private lazy var nameLabel = UILabel(frame: .zero)
    private lazy var heightLabel = UILabel(frame: .zero)
    private lazy var weightLabel = UILabel(frame: .zero)
    private lazy var typeLabel = UILabel(frame: .zero)
    private lazy var likeButton = UIButton(type: .custom)
    
    init(pokemon: Pokemon, connectionService: ConnectionService) {
        self.pokemon = pokemon
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
        
        stackView.addArrangedSubview(coverImageView)
        coverImageView.activate(anchors: [.relative(attribute: .height, relatedTo: .width, constant: 0)], relativeTo: coverImageView)
        
        let containerView = UIView(frame: .zero)
        containerView.addSubview(thumbnailImageView, anchors: [.width(32), .height(32), .centerY(0)])
        thumbnailImageView.activate(anchors: [.relative(attribute: .left, relatedTo: .left, constant: 0)], relativeTo: containerView)

        containerView.addSubview(nameLabel, anchors: [.top(0), .bottom(0)])
        nameLabel.activate(anchors: [.relative(attribute: .left, relatedTo: .right, constant: 5)], relativeTo: thumbnailImageView)

        containerView.addSubview(likeButton, anchors: [.trailing(0), .width(36), .height(36)])
        likeButton.activate(anchors: [.centerY(0)], relativeTo: containerView)
        likeButton.activate(anchors: [.relative(attribute: .leading, relatedTo: .trailing, constant: 5)], relativeTo: nameLabel)
        
        let stackViewSubviews = [containerView, idLabel, heightLabel, weightLabel, typeLabel]
        stackViewSubviews.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func customizeSubviews() {
        if let managedPokenmon = ManagedPokenmon.query(id: pokemon.id) {
            pokemon = Pokemon(managedPokenmon: managedPokenmon)
            likeButton.isSelected = managedPokenmon.isLiked
        }
        
        view.backgroundColor = .white
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        
        coverImageView.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        coverImageView.contentMode = .scaleAspectFill
        stackView.setCustomSpacing(10, after: coverImageView)
        
        thumbnailImageView.contentMode = .scaleAspectFill
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        idLabel.textColor = .black
        idLabel.font = .systemFont(ofSize: 16)
        
        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: 32)
        nameLabel.numberOfLines = 0
        stackView.setCustomSpacing(10, after: nameLabel)

        heightLabel.textColor = .black
        heightLabel.font = .systemFont(ofSize: 16)

        weightLabel.textColor = .black
        weightLabel.font = .systemFont(ofSize: 16)

        typeLabel.textColor = .black
        typeLabel.font = .systemFont(ofSize: 16)
    }
    
    private func setupRequests() {
        connectionService.fetchPokemon(id: pokemon.id)
            .saveToCoreData()
            .sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] pokemon in
            self?.pokemon = pokemon
        }).store(in: &cancellables)
    }
    
    @objc func likeButtonTapped() {
        likeButton.isSelected.toggle()
        pokemon.isLiked = likeButton.isSelected
    }
}
