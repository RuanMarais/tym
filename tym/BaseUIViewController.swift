//
//  BaseUIViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    var keyboardOnScreen: Bool = false 
    var keyboardRequiredShift: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToAllNotifications()
    }
}

extension BaseUIViewController {
    
    //Method to apply a color gradient effect to the toolbar

    func configureTopToolBarColorGradient(topToolBar: UIToolbar, mainView: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [Constants.UIConstants.MainColour.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: mainView.frame.size.width, height: 64.0)
        topToolBar.setBackgroundImage(createImage(layer: gradient), forToolbarPosition: .any, barMetrics: .default)
    }
    
    //Method to convert gradient into image for use as toolbar background
    
    private func createImage(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let createdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return createdImage!
    }
}

extension BaseUIViewController: UITextFieldDelegate {
    
    //Textfield UI elements for new post creation
    
    func configureNewPostTextField(firstSection: Bool, textField: UITextField) {
        
        let textFieldPaddingViewFrame = CGRect(x: 0.0, y: 0.0, width: Constants.TextFieldConstants.TextFieldPadding, height: 0.0)
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        textField.leftView = textFieldPaddingView
        textField.leftViewMode = .always
        
        if firstSection {
            textField.placeholder = Constants.TextFieldConstants.NewPostTextFieldPlaceholderTextSection1
        } else {
            textField.placeholder = Constants.TextFieldConstants.NewPostTextFieldPlaceholderTextSection2
        }
        
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        textField.autocorrectionType = UITextAutocorrectionType.no
        
        textField.delegate = self
    }
    
    //New post textfield delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    func resignFirstResponderWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapView(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //Implement by subclass to resign firstResponders
    
    @objc func userDidTapView(sender: AnyObject) {
        
    }
}

extension BaseUIViewController {
    
    //keyboard notifications observer addition, the subclass implements the specific handling
    
    func subscribeToNotification(notification: String, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: notification), object: nil)
    }
    
    func unsubscribeToAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribeKeyboardNotifications() {
        
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardWillShow.rawValue, selector: #selector(keyboardWillShow(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardDidShow.rawValue, selector: #selector(keyboardDidShow(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardWillHide.rawValue, selector: #selector(keyboardWillHide(notification:)) )
        subscribeToNotification(notification: NSNotification.Name.UIKeyboardDidHide.rawValue, selector: #selector(keyboardDidHide(notification:)) )
    }
    
    //keyboard handling methods - override by subclass
    
    func keyboardDidShow(notification: NSNotification) {
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
    
    func keyboardDidHide(notification: NSNotification) {
        
    }
    
    func keyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }


}
