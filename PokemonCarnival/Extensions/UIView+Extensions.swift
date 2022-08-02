//
//  UIView+Extensions.swift
//  PokemonCarnival
//
//  Created by littlema on 2022/8/2.
//

import UIKit

extension UIView {
    func startLoading() {
        guard let superview = superview else { return }

        stopLoading()

        superview.layoutIfNeeded()
        alpha = 0

        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        superview.addSubview(loadingIndicator, anchors: [.centerX(0), .centerY(0)])
        loadingIndicator.startAnimating()
    }

    func stopLoading() {
        alpha = 1

        superview?.subviews.compactMap { $0 as? UIActivityIndicatorView }.forEach { indicatorView in
            indicatorView.stopAnimating()
            indicatorView.removeFromSuperview()
        }
    }
    
    func setCornerRadius(_ value: CGFloat) {
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        guard layer.cornerRadius != value else { return }
        layer.masksToBounds = value != 0
        layer.cornerRadius = value
    }
}
