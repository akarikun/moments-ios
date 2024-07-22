//
//  ContentView.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class ContentViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    static let identifier = "ContentViewCell"
    static func nib() -> UINib {
      return UINib(nibName: "ContentViewCell", bundle: nil)
    }
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    //@IBOutlet weak var imgColView: UICollectionView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var colView: UICollectionView!
    public var imgs:[String]!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
//        cell.layer.borderColor = UIColor.red.cgColor
//        cell.layer.borderWidth = 1
        let v  = cell.subviews.first?.subviews
        for (index,src) in imgs.enumerated() {
            if let imgView = v?[index].subviews.first as? UIImageView{
                imgView.setImageByUrl(url: src)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("\(collectionView.bounds.width) | \(collectionView.bounds.height)")
        return CGSize(width: collectionView.bounds.width, height: 500)
    }
    
    public func setLayoutAndData(){
        colView.register(ImagesCell.nib(), forCellWithReuseIdentifier: ImagesCell.identifier)
        colView.isScrollEnabled = false
        colView.dataSource = self
        colView.delegate = self
    }
    
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
        self.lineView.backgroundColor = UIColor.gray;
        self.imgs = imgs;
    }
}
