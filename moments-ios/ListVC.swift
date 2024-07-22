//
//  ListVC.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class ListVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableview.register(ContentViewCell.nib(), forCellReuseIdentifier: ContentViewCell.identifier)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.separatorStyle = .singleLine
        tableview.separatorColor = UIColor.clear
        tableview.separatorInset = .zero
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableView.automaticDimension
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
       return 1
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
     }
    
    func getRandomText(from items: [String]!) -> String {
        let randomIndex = Int(arc4random_uniform(UInt32(items.count)))
        return items[randomIndex]
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: ContentViewCell.identifier, for: indexPath) as! ContentViewCell;
         let items = [
            "使用View Hierarchy Debugger检查",
            "确保在Storyboard中为UICollectionViewCell添加了足够的约束",
        "检查约束的优先级是否正确设置。高优先级的约束会优先生效，低优先级的约束可能会被忽略。",
        "如果UICollectionViewCell内部有使用Intrinsic Content Size的控件（如UILabel），确保它们的约束设置正确，不会导致UICollectionViewCell尺寸超出预期",
        "在运行时，通过在控制台打印UICollectionViewCell的frame或者bounds来检查其实际尺寸，确认是否符合预期。",
        "有时候模拟器可能会出现显示问题，尝试重置模拟器状态或者使用不同的模拟器进行测试。",
        "在Xcode中选择菜单中的\"Product\" -> \"Clean Build Folder\"来清理项目，然后重新编译和运行，以确保加载最新的布局设置和代码"]
         let text = items[indexPath.row] //getRandomText(from: items)
         cell.setLayoutAndData()
         cell.setAvatar(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC28lvhB3X_P4cDQ17N2RQvttJRUYagluoPw&s")!)
         cell.setData(name: "akari", content: text, imgs: [
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC28lvhB3X_P4cDQ17N2RQvttJRUYagluoPw&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzoXP3RVn2l6NnIp7K0oz6xkb7zUgTkBQNEQ&s",
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnMbAtJt52Ig2grCEmbgi9XcimIhr2rEnd4w&s"
         ])
         
         return cell
     }

}
