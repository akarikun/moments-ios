//
//  LoginVC.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        

//        if UIDevice.current.userInterfaceIdiom == .pad {
//            if let widthConstraint = contentView.constraints.first(where: { $0.firstAttribute == .width }) {
//                widthConstraint.constant = UIScreen.main.bounds.width - 20
//                widthConstraint.priority = UILayoutPriority(750)
//            }
//        }
    }

    @IBAction func btnLogin_touch(_ sender: Any) {
        let listVC = (storyboard?.instantiateViewController(withIdentifier: "ListVC"))!
        navigationController?.pushViewController(listVC, animated: true)
    }
    
}


