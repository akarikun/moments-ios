//
//  ContentViewCell.swift
//  moments-ios
//
//  Created by akari on 2024/7/24.
//


import UIKit
import SnapKit

class ContentViewCell: UITableViewCell {
    static let identifier = "ContentViewCell"
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var vbtmContainer: UIView!
    
    func setupImagesGrid(_ images: [String]) {
        let width = UIScreen.main.bounds.size.width - 20
        let widthConstraint = vbtmContainer.constraints.first(where: { $0.firstAttribute == .width })!
        let heightConstraint = vbtmContainer.constraints.first(where: { $0.firstAttribute == .height })!
        if UIDevice.current.userInterfaceIdiom == .pad {
            widthConstraint.constant = width / 2
        }
        else{
            widthConstraint.constant = width
        }
        
        let _c = ceil(Double(images.count) / 3.0);
        heightConstraint.constant = (width + 20) * _c * (1 / 3)
        heightConstraint.priority = UILayoutPriority(1000)
        widthConstraint.priority = UILayoutPriority(1000)
        
        let gridContainer = UIView()
        vbtmContainer.addSubview(gridContainer)
        gridContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        let w = (width - 20) / 3
        for (index,url) in images.enumerated() {
            let r = (index) / 3
            let c = (index % 3)
            var row = CGFloat(r) * w
            var col = CGFloat(c) * w
            row = row + CGFloat(10 * r)
            col = col + CGFloat(10 * c)
            let v = UIView()
            gridContainer.addSubview(v)
            v.snp.makeConstraints { make in
                make.width.height.equalTo(w)
                make.leading.equalTo(gridContainer).offset(col)
                make.top.equalTo(gridContainer).offset(row)
            }
            let imgView = UIImageView()
            v.addSubview(imgView)
            imgView.setImageByUrl(url: url)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
