//
//  ImagesCell.swift
//  moments-ios
//
//  Created by akari on 2024/7/22.
//

import UIKit

public class ImagesCell:UICollectionViewCell{
    static let identifier = "ImagesCell"
    static func nib() -> UINib {
      return UINib(nibName: "ImagesCell", bundle: nil)
    }
}
