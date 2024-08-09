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
        
        sendView.layer.cornerRadius = 3
        sendView.clipsToBounds = true
        sendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(send_handleTap)))
        
        pmsSwitch.addAction(UIAction(handler: switch_handleChanged), for: UIControl.Event.valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),name:UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        pstText.delegate = self
        
        setImageContainerLayout(imageContainerView)
        appendImageView(imageContainerView,nil)
    }
    
    func setImageContainerLayout(_ imageContainer:UIView){
        let width = UIScreen.main.bounds.size.width - 20
        let widthConstraint = imageContainer.constraints.first(where: { $0.firstAttribute == .width })!
        let heightConstraint = imageContainer.constraints.first(where: { $0.firstAttribute == .height })!
        if UIDevice.current.userInterfaceIdiom == .pad {
            widthConstraint.constant = width / 2
            //居左
            imageContainer.superview!.constraints.first(where: { $0.firstAttribute == .leading && $0.firstItem as? UIView == imageContainer && $0.secondItem as? UIView == imageContainer.superview })!.priority = UILayoutPriority(1000)
        }
        else{
            widthConstraint.constant = width
            //居中
            imageContainer.superview!.constraints.first(where: { $0.firstAttribute == .centerX && $0.firstItem as? UIView == imageContainer })!.priority = UILayoutPriority(1000)
        }
        var count = imageContainer.subviews.count + 1
        let val:CGFloat = count > 6 ? 0 : count > 3 ? CGFloat(20 / 3) : 20
        heightConstraint.constant = (width - val) * ceil(Double(count) / 3.0) * (1 / 3)
        heightConstraint.priority = UILayoutPriority(1000)
    }

    func appendImageView(_ imageContainer:UIView,_ image:UIImage?){
        setImageContainerLayout(imageContainer)
        let width = imageContainer.constraints.first(where: { $0.firstAttribute == .width })!.constant
        let count = imageContainer.subviews.count
        let w = (width - 20) / 3
        let r:Int = count / 3
        let c:Int = count % 3
        let row:CGFloat = CGFloat(r) * w + CGFloat(10 * r)
        let col:CGFloat = CGFloat(c) * w + CGFloat(10 * c)
        
        let imageView = UIImageView(image: image == nil ? UIImage(named: "CarbonAddLarge") : image)
        imageContainerView.addSubview(imageView)
        imageView.frame = CGRect(x: col, y: row, width: w, height: w)
        imageView.tag = image == nil ? -1 : 0
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage_handleTap)))
        changeImageView(imageContainer)
    }
    func changeImageView(_ imageContainer:UIView){
        let count = imageContainer.subviews.count
        if count <= 1{
            return
        }
        let addImage = imageContainer.subviews.first { $0.tag == -1 } as! UIImageView
        let last = imageContainer.subviews.last as! UIImageView
        let t1 = last.frame
        let t2 = addImage.frame
        last.frame = CGRect(x: t2.minX, y: t2.minY, width: t2.width, height: t2.height)
        addImage.frame = CGRect(x: t1.minX, y: t1.minY, width: t1.width, height: t1.height)
    }
    
    @objc func addImage_handleTap(gesture: UITapGestureRecognizer){
        print("addImage_handleTap")
        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
        configuration.selectionLimit = 9
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        
        if self.imageContainerView!.subviews.count + results.count > 9{
            print("不能超过9张")
            return
        }
        
        itemProviders.forEach {
            guard let typeIdentifier = $0.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier) else { return }
            
            var secondTypeIdentifier: String?
            if $0.registeredTypeIdentifiers.count > 1 {
                secondTypeIdentifier = $0.registeredTypeIdentifiers[1]
            }
            
            if utType.conforms(to: .image) {
                $0.loadDataRepresentation(forTypeIdentifier: secondTypeIdentifier ?? typeIdentifier) { [weak self] data, error in
                    DispatchQueue.main.async {
                        self?.appendImageView((self?.imageContainerView)!,UIImage(data: data!)!)
                    }
                }
            }
        }
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
