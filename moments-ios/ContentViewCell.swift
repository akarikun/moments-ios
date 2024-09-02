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
    var listVC:ListVC!
    var tableView:UITableView!
    var indexPath: IndexPath!
    var pimgTap: UITapGestureRecognizer!
    var imageGapValue:CGFloat = 12
    
    func setupImagesGrid(_ images: [String]) {
        pimgTap = UITapGestureRecognizer(target: self, action: #selector(pimg_handleTap))
        
        let width = UIScreen.main.bounds.size.width - imageGapValue
        let widthConstraint = vbtmContainer.constraints.first(where: { $0.firstAttribute == .width })!
        let heightConstraint = vbtmContainer.constraints.first(where: { $0.firstAttribute == .height })!
        if UIDevice.current.userInterfaceIdiom == .pad {
            widthConstraint.constant = width / 2
        }
        else{
            widthConstraint.constant = width
        }
        let val:CGFloat = images.count > 6 ? 0 :images.count > 3 ? CGFloat(imageGapValue / 3) : imageGapValue
        heightConstraint.constant = (width - val) * ceil(Double(images.count) / 3.0) * (1 / 3)
        heightConstraint.priority = UILayoutPriority(1000)
        widthConstraint.priority = UILayoutPriority(1000)
        let gridContainer = UIView()
        vbtmContainer.addSubview(gridContainer)
        gridContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        let w = (width - imageGapValue) / 3
        for (index,url) in images.enumerated() {
            let r:Int = index / 3
            let c:Int = index % 3
            let row:CGFloat = CGFloat(r) * w + CGFloat(Int(imageGapValue) / 2 * r)
            let col:CGFloat = CGFloat(c) * w + CGFloat(Int(imageGapValue) / 2 * c)
            
            let img = UIImageView()
            img.setImageByUrl(url)
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            img.isUserInteractionEnabled = true
            img.frame = CGRect(x: col, y: row, width: w, height: w)
            gridContainer.addSubview(img)
            img.isUserInteractionEnabled = true
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(img_handleTap)))
        }
    }
    @objc func img_handleTap(gesture: UITapGestureRecognizer) {
        let img = gesture.view as? UIImageView
//        let cell = tableView.cellForRow(at: indexPath)
//        let rect = tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview) //获取当前cell在屏幕显示的位置,如果要写出在当前位置缩放的效果需要该值

        let pimg = listVC.imageFullscreen!
        pimg.image = img?.image
        listVC.view.bringSubviewToFront(listVC.imageContainerView)
        tableView.alpha = 0
        pimg.alpha = 0;
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            pimg.alpha = 1;
        }, completion: { _ in
            pimg.isUserInteractionEnabled = true
            pimg.addGestureRecognizer(self.pimgTap)
        })
    }
    @objc func pimg_handleTap(gesture: UITapGestureRecognizer) {
        let pimg = listVC.imageFullscreen!
        pimg.alpha = 0;
        tableView.alpha = 0
        listVC.view.sendSubviewToBack(listVC.imageContainerView)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.tableView.alpha = 1
        },completion: { _ in
            pimg.removeGestureRecognizer(self.pimgTap)
        })
    }
}
