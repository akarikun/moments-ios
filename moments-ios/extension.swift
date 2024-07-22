//
//  extension.swift
//  moments-ios
//
//  Created by akari on 2024/7/22.
//

import UIKit

extension UIImageView {
    func setImageByUrl(url:String) {
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
