//
//  UIImageView+Extension.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/7/31.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: URL?, placeHolder: UIImage? = nil) {
        kf.indicatorType = .activity
        isFailure = false
        kf.setImage(with: url, placeholder: nil, completionHandler: { [weak self] result in
            switch result {
            case .success:
                break
            case .failure:
                self?.isFailure = true
            }
            self?.kf.indicatorType = .none
        })
    }
}

extension UIImageView {
    private struct AssociatedKeys {
        static var isFailureKey = "isAvailableKey"
        static var failureImageViewKey = "availableImageViewKey"
    }
    
    fileprivate var isFailure: Bool {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.isFailureKey) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isFailureKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                if let associatedImageView = objc_getAssociatedObject(self, &AssociatedKeys.failureImageViewKey) as? UIImageView {
                    associatedImageView.isHidden = false
                } else {
                    let imageView = UIImageView(image: UIImage(systemName: "questionmark.circle"))
                    imageView.tintColor = .lightGray
                    addSubview(imageView, anchors: [.centerX(0), .centerY(0)])
                    imageView.activate(anchors: [.relative(attribute: .width, relatedTo: .width, multiplier: 0.4, constant: 0)], relativeTo: self)
                    imageView.activate(anchors: [.relative(attribute: .height, relatedTo: .width, multiplier: 1, constant: 0)], relativeTo: imageView)

                    objc_setAssociatedObject(self, &AssociatedKeys.failureImageViewKey, imageView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            } else {
                (objc_getAssociatedObject(self, &AssociatedKeys.failureImageViewKey) as? UIImageView)?.isHidden = true
            }
        }
    }
}
