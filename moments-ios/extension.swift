//
//  extension.swift
//  moments-ios
//
//  Created by akari on 2024/7/22.
//

import UIKit

extension UIImageView {
    func setImageByUrl(_ url:String) {
        let _this = self
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        _this.image = image
                    }
                }
            }
        }
    }
}

extension UIView {
    func setBorder(_ color: UIColor){
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
}
