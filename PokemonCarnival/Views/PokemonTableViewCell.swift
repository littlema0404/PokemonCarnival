//
//  PokemonTableViewCell.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import UIKit

protocol PokemonTableViewCellDelegate: AnyObject {
    func pokemonTableViewCellLikeButtonDidTapped(cell: PokemonTableViewCell)
}

class PokemonTableViewCell: UITableViewCell {
    private lazy var itemImageView = UIImageView(frame: .zero)
    private lazy var nameLabel = UILabel(frame: .zero)
    private lazy var likeButton = UIButton(type: .custom)

    
    weak var delegate: PokemonTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        customizeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(itemImageView, anchors: [.top(10), .leading(10), .bottom(-10)])
        itemImageView.activate(anchors: [.relative(attribute: .height, relatedTo: .width, constant: 0)], relativeTo: itemImageView)
        
        contentView.addSubview(nameLabel, anchors: [.centerY(0)])
        nameLabel.activate(anchors: [.relative(attribute: .leading, relatedTo: .trailing, constant: 10)], relativeTo: itemImageView)
        
        contentView.addSubview(likeButton, anchors: [.height(36), .width(36), .trailing(-10), .centerY(0)])
        likeButton.activate(anchors: [.relative(attribute: .leading, relatedTo: .trailing, constant: 10)], relativeTo: nameLabel)
    }
    
    private func customizeSubviews() {
        itemImageView.contentMode = .scaleAspectFill
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        if let id = pokemon.id, let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png") {
            itemImageView.setImage(url: url)
        }
    }
    
    @objc func likeButtonTapped() {
        likeButton.isSelected.toggle()
        delegate?.pokemonTableViewCellLikeButtonDidTapped(cell: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        itemImageView.image = nil
        likeButton.isSelected = false
    }
}
