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
        kf.setImage(with: url, placeholder: placeHolder)
    }
}
