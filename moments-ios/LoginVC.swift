//
//  LoginVC.swift
//  moments-ios
//
//  Created by akari on 2024/7/21.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var hostInput: UITextField!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var passInput: UITextField!
    var sns:SNSProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
        
//        goNextVC(true)
    }
    
    func goNextVC(_ isSetRoot:Bool){
        let listVC = (storyboard?.instantiateViewController(withIdentifier: "ListVC")) as! ListVC
        listVC.sns = sns
        if isSetRoot {
            navigationController?.viewControllers = [listVC]
        }
        else{
            present(listVC, animated: true, completion: nil)
        }
    }

    @IBAction func btnLogin_touch(_ sender: Any) {
     
        let host = hostInput.text ?? ""
        let user = userInput.text ?? ""
        let pass = passInput.text ?? ""
        
        if !host.isEmpty && !user.isEmpty && !pass.isEmpty {
            sns = MomentsApi(base_url:host)
            sns.login(data: ["username": user, "password":pass], action: { r in
                if r {
                    let listVC = (storyboard?.instantiateViewController(withIdentifier: "ListVC"))!
                    listVC.modalPresentationStyle = .fullScreen
                    self.goNextVC(false)
                }
                else{
                    showAlert(message: "填入的信息异常", title: nil)
                }
            })
        }
        else {
            showAlert(message: "请填入完整信息后操作", title: nil)
        }
    }
}


