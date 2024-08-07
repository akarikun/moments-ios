//
//  PostVC.swift
//  moments-ios
//
//  Created by akari on 2024/8/7.
//

import UIKit
import PhotosUI
import SnapKit

class PostVC: UIViewController,UITextFieldDelegate, PHPickerViewControllerDelegate {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var pmsSwitch: UISwitch!
    @IBOutlet weak var pmsLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var pstText: UITextField!
    var ActiveText:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back_handleTap)))
        
        sendView.layer.cornerRadius = 3 // 设置圆角半径为 10
        sendView.clipsToBounds = true // 确保子视图不会超出父视图的圆角边界
        sendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(send_handleTap)))
        
        pmsSwitch.addAction(UIAction(handler: switch_handleChanged), for: UIControl.Event.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        pstText.delegate = self
        
        
        imageContainerView.subviews.first?.setBorder(UIColor.red)
        imageContainerView.subviews.first?.isUserInteractionEnabled = true
        imageContainerView.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagelist_handleTap)))
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        
        itemProviders.forEach {
            guard let typeIdentifier = $0.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier) else { return }
            
            var secondTypeIdentifier: String?
            if $0.registeredTypeIdentifiers.count > 1 {
                secondTypeIdentifier = $0.registeredTypeIdentifiers[1]
            }
            
            if utType.conforms(to: .image) {
                $0.loadDataRepresentation(forTypeIdentifier: secondTypeIdentifier ?? typeIdentifier) { [weak self] data, error in
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        let imageView = self?.imageContainerView.subviews.first as! UIImageView
                        imageView.image = image
                        self!.appendImageView()
                    }
                }
            }
        }
    }
    
    func appendImageView(){
        let lastView = imageContainerView.subviews.last as! UIImageView
        let imageView = UIImageView(image: UIImage(named: "CarbonAddLarge"))
        imageContainerView.addSubview(imageView)
        imageView.setBorder(UIColor.orange)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(lastView)
            make.height.equalTo(lastView)
            make.top.equalTo(0)
            make.leading.equalTo(lastView.frame.width)
        }
    }

    @objc func imagelist_handleTap(imageView: UIImageView){
        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
        configuration.selectionLimit = 9
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
        ActiveText = nil
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ActiveText = textField
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if ActiveText == nil {
            return
        }
        guard let userInfo = sender.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        topConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        topConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func back_handleTap(gesture: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    @objc func send_handleTap(gesture: UITapGestureRecognizer) {
        print("send")
    }
    @objc func switch_handleChanged(sender: Any){
        if pmsSwitch.isOn {
            pmsLabel.text = "公开"
            pmsLabel.textColor = UIColor.black
        }
        else {
            pmsLabel.text = "私有"
            pmsLabel.textColor = UIColor.gray
        }
    }
}
