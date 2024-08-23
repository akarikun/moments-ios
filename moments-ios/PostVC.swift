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
    var startPoint: CGPoint?
    var originPoint: CGPoint?
    var imageGapValue:CGFloat = 12
    var imageList = [UIImage]()
    
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
    func renderImageView(_ image:UIImage?){
        if image != nil {
            imageList.append(image!)
        }
        for i in imageContainerView.subviews {
            if i.tag != -1 {
                i.removeFromSuperview()
            }
        }
        for i in imageList{
            appendImageView(imageContainerView, i)
        }
    }
    
    func setImageContainerLayout(_ imageContainer:UIView){
        let width = UIScreen.main.bounds.size.width - imageGapValue
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
        let count = imageList.count + 1
        let val:CGFloat = count > 6 ? 0 : count > 3 ? CGFloat(imageGapValue / 3) : imageGapValue
        heightConstraint.constant = (width - val) * ceil(Double(count) / 3.0) * (1 / 3)
        heightConstraint.priority = UILayoutPriority(1000)
    }

    func appendImageView(_ imageContainer:UIView,_ image:UIImage?){
        setImageContainerLayout(imageContainer)
        let width = imageContainer.constraints.first(where: { $0.firstAttribute == .width })!.constant
        let count = imageContainer.subviews.count
        let w = (width - imageGapValue) / 3
        let r:Int = count / 3
        let c:Int = count % 3
        let row:CGFloat = CGFloat(r) * w + CGFloat(Int(imageGapValue) / 2 * r)
        let col:CGFloat = CGFloat(c) * w + CGFloat(Int(imageGapValue) / 2 * c)
        
        let pView = UIView(frame: CGRect(x: col, y: row, width: w, height: w))
        let imageView = UIImageView(image: image == nil ? UIImage(named: "CarbonAddLarge") : image)
        pView.addSubview(imageView)
        imageContainerView.addSubview(pView)
        imageView.frame = CGRect(x: 0, y: 0, width: w, height: w)
        pView.tag = image == nil ? -1 : count
        pView.isUserInteractionEnabled = true
        if pView.tag == -1 {
            pView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImage_handleTap)))
        }
        else {
            let close = UIImageView(image: UIImage(named: "CarbonCloseFilled"))
            pView.addSubview(close)
            close.frame = CGRect(x: w-30, y: 0, width: 30, height: 30)
            close.isUserInteractionEnabled = true
            close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeImage_handleTap)))
            pView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addImage_handleLongPress)))
        }
    }
    @objc func closeImage_handleTap(gesture: UITapGestureRecognizer){
        let tag = gesture.view?.superview?.tag as! Int
        imageList.remove(at: tag-1)
        renderImageView(nil)
        setImageContainerLayout(imageContainerView)
        resetTag(imageContainerView)
    }
    @objc func addImage_handleLongPress(gesture: UILongPressGestureRecognizer){
        let pView = gesture.view!
        if pView.tag == -1 {
            return
        }
        if gesture.state == .began {
            startPoint = gesture.location(in: gesture.view)
            originPoint = pView.center
            UIView.animate(withDuration: 0.2) {
                pView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
                pView.alpha = 0.8
            }
        } else if gesture.state == .changed {
            let newPoint = gesture.location(in: gesture.view)
            let deltaX = newPoint.x - startPoint!.x
            let deltaY = newPoint.y - startPoint!.y
            pView.center = CGPoint(x: pView.center.x+deltaX, y: pView.center.y+deltaY)
            for subview in pView.superview!.subviews {
               if let otherView = subview as? UIView, otherView != pView, otherView.tag != -1 {
                   if otherView.frame.contains(pView.center) {
                       UIView.animate(withDuration: 0.2) {
                           let tempCenter = otherView.center
                           otherView.center = self.originPoint!
                           pView.center = tempCenter
                       }
                       originPoint = pView.center
                       break
                   }
               }
            }
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.2) {
                pView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                pView.alpha = 1
                pView.center = self.originPoint!
            }
            resetTag(pView.superview)
        }
    }
    func resetTag(_ imageContainerView:UIView?){
        for (index,subview) in imageContainerView!.subviews.enumerated() {
            if subview.tag > -1 {
                subview.tag = index
            }
        }
    }
    
    @objc func addImage_handleTap(gesture: UITapGestureRecognizer){
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
        
        if self.imageList.count > 9{
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
                        self?.renderImageView(UIImage(data: data!)!)
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
