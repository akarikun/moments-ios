//
//  ContentView.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class ContentViewCell: UITableViewCell {
    static let identifier = "ContentViewCell"
    static func nib() -> UINib {
      return UINib(nibName: "ContentViewCell", bundle: nil)
    }
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    //@IBOutlet weak var imgColView: UICollectionView!
    public func setAvatar(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imgAvatar.image = image
                    }
                }
            }
        }
    }
    
    public func setData(name:String,content:String,imgs:[String]){
        self.lblName.text = name;
        self.lblContent.text = content;
        //
    }
}
