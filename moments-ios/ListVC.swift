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
        
        tableview.estimatedRowHeight = 44.0
        tableview.rowHeight = UITableView.automaticDimension
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
       return 5
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableview.dequeueReusableCell(withIdentifier: ContentViewCell.identifier)!;
         return cell
     }

}
