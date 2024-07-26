//
//  ListVC.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class ListVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageFullscreen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.clear
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
       return 1
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 9
     }
    
    func getRandomText(from items: [String]!) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(items.count)))
        return items[randomIndex]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: ContentViewCell.identifier, for: indexPath) as! ContentViewCell
         cell.listVC = self
         cell.tableView = tableView
         cell.indexPath = indexPath
         cell.selectionStyle = .none;
         let items = [
            "制作艺术作品集",
            "将孩子们的艺术作品扫描或拍照，然后制作一本精美的艺术作品集",
            "可以使用在线打印服务，将这些作品集打印成书，这样不仅保存了孩子们的创作，还能方便展示给亲友。",
            "DIY家居装饰",
            "用孩子们的艺术作品制作家居装饰品",
            "可以将作品装裱成画框，挂在墙上；或者制作成装饰垫、枕头套等。这些独特的装饰品既美观又充满回忆",
            "定制礼品",
            "将孩子们的艺术作品制作成定制礼品，如马克杯、T恤、手机壳等",
            "这样不仅保留了孩子们的创作，还可以作为特别的礼物送给亲友"]
         let text = items[indexPath.row] //getRandomText(from: items)
         cell.imgAvatar.setImageByUrl( "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC28lvhB3X_P4cDQ17N2RQvttJRUYagluoPw&s")
         cell.lblName.text = "akari"
         cell.lblContent.text = text
         
         let arr = [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC28lvhB3X_P4cDQ17N2RQvttJRUYagluoPw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzoXP3RVn2l6NnIp7K0oz6xkb7zUgTkBQNEQ&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnMbAtJt52Ig2grCEmbgi9XcimIhr2rEnd4w&s",
            
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOEMAt9KsMF8-MGkdcO6UTutU9zsOHw2wrpg&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPJtydZePQWuOVtLT7i6w_b9UpG26ZVX6JsQ&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTX84mZ_p43hAgJyFSgLEu73F-sWyfs7EMjA&s",
            
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzi5PITp7_vJRtjKq2cj0PUZlZnmT6uVE-qw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzOmEYv1m-j7feJbP3PftNv35llsuKmH4q5Q&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxVzazWGB_Eg8cul9kNh13kfEGIS4YG21ufw&s"
         ];
         cell.setupImagesGrid(arr)
         return cell
    }
}
