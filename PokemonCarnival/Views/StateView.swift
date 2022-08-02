//
//  StateView.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import UIKit

protocol StateViewDelegate: AnyObject {
    func stateViewConfirmButtonDidTap(_ stateView: StateView)
}

class StateView: UIView {
    enum State {
        case empty
        case failure
        case none
        
        fileprivate var icon: UIImage? {
            switch self {
            case .none:
                return nil
            case .empty:
                return UIImage(systemName: "exclamationmark.circle")
            case .failure:
                return UIImage(systemName: "arrow.counterclockwise")
            }
        }
        
        fileprivate var title: String? {
            switch self {
            case .none:
                return nil
            case .empty:
                return "什麼都沒有 ( ˘･з･)"
            case .failure:
                return "目前無法使用 ( ´ﾟДﾟ`)"
            }
        }
        
        fileprivate var buttonTitle: String? {
            switch self {
            case .none, .empty:
                return nil
            case .failure:
                return "重試"
            }
        }
    }
    
    private lazy var imageView = UIImageView(frame: .zero)
    private lazy var stackView = UIStackView(frame: .zero)
    private lazy var titleLabel = UILabel(frame: .zero)
    private lazy var confirmButton = UIButton(type: .custom)
    
    var state: State = .none {
        didSet {
            imageView.image = state.icon
            titleLabel.text = state.title
            confirmButton.setTitle(state.buttonTitle, for: .normal)
            confirmButton.isHidden = state.buttonTitle == nil
        }
    }
    
    weak var delegate: StateViewDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        customizeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView, anchors: [.height(100), .width(100), .centerY(-50), .centerX(0)])
        
        addSubview(stackView, anchors: [.leading(20), .trailing(-20)])
        stackView.activate(anchors: [.relative(attribute: .top, relatedTo: .bottom, constant: 30)], relativeTo: imageView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(confirmButton)
        confirmButton.activate(anchors: [.constant(attribute: .width, constant: 80)])
    }
    
    private func customizeSubviews() {
        backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
                
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        confirmButton.setCornerRadius(6)
        confirmButton.setTitleColor(.black, for: .normal)
        confirmButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        confirmButton.backgroundColor = UIColor(white: 0.9, alpha: 1)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func confirmButtonTapped() {
        delegate?.stateViewConfirmButtonDidTap(self)
    }
}
