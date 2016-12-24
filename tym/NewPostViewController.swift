//
//  NewPostViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class NewPostViewController: BaseUIViewController {
    
    //MARK: Properties - Toolbar
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var clearButtonTopToolbar: UIBarButtonItem!
    @IBOutlet weak var previewButtonTopToolbar: UIBarButtonItem!
    @IBOutlet weak var postButtonTopToolbar: UIBarButtonItem!
    
    //MARK: Properties - Section 1
    
    @IBOutlet weak var imagePreviewSection1: UIImageView!
    @IBOutlet weak var textPreviewSection1: UITextView!
    @IBOutlet weak var labelTextFieldSection1: UILabel!
    @IBOutlet weak var labelImageButtonSection1: UILabel!
    @IBOutlet weak var imageButtonSection1: UIButton!
    @IBOutlet weak var textFieldSection1: UITextField!
    
    //MARK: Properties - Section 2
    
    @IBOutlet weak var textPreviewSection2: UITextView!
    @IBOutlet weak var imagePreviewSection2: UIImageView!
    @IBOutlet weak var labelTextFieldSection2: UILabel!
    @IBOutlet weak var labelImageButtonSection2: UILabel!
    @IBOutlet weak var imageButtonSection2: UIButton!
    @IBOutlet weak var labelDurationInputSection2: UILabel!
    @IBOutlet weak var durationInputSliderSection2: UISlider!
    @IBOutlet weak var textFieldSection2: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
    
    @IBAction func clearPostFields(_ sender: Any) {
    }
    
    @IBAction func previewCreatedPost(_ sender: Any) {
    }
    
    @IBAction func postToDatabase(_ sender: Any) {
        
        if DatabaseHandling.sharedInstance.isSignedIn {
            DatabaseHandling.sharedInstance.createPost(textSectionOne: textPreviewSection1.text, imageSectionOne: nil, textSectionTwo: textPreviewSection2.text, imageSectionTwo: nil, timeGateSectionTwo: nil)
            
        } else {
            //sign in alert controller
        }
        
    }
    
    
}

// Configure UI elements

extension NewPostViewController {
    
    func configure() {
        configureNewPostTextField(firstSection: true, textField: textFieldSection1)
        configureNewPostTextField(firstSection: false, textField: textFieldSection2)
        keyboardOnScreen = false
        keyboardRequiredShift = false
        subscribeKeyboardNotifications()
        
        DatabaseHandling.sharedInstance.configureAuth(viewController: self)
        
        if DatabaseHandling.sharedInstance.isSignedIn {
            DatabaseHandling.sharedInstance.configureDatabase()
        }
    }
    
    func clearPostInputFields() {
        textPreviewSection1.text = ""
        textPreviewSection2.text = ""
        
    }
}

// Textfied - limit characters and set textview

extension NewPostViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text! as NSString
        let newText = currentText.replacingCharacters(in: range, with: string) as NSString
        
        if textFieldSection1.isFirstResponder {
            if newText.length <= Constants.TextFieldConstants.MaxTextPostCharacterLength {
                textPreviewSection1.text = newText as String
                textPreviewSection1.isHidden = false
                imagePreviewSection1.isHidden = true
                return true
            } else {
                return false
            }
        } else {
            if newText.length <= Constants.TextFieldConstants.MaxTextPostCharacterLength {
                textPreviewSection2.text = newText as String
                textPreviewSection2.isHidden = false
                imagePreviewSection2.isHidden = true
                return true
            } else {
                return false
            }
        }
    }
}

// keyboard handling 

extension NewPostViewController {
    
    override func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(textField: textFieldSection1)
        resignIfFirstResponder(textField: textFieldSection2)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        let keyBoardHeight = keyboardHeight(notification: notification)
        if !textFieldSection1.isFirstResponder {
            if !keyboardOnScreen {
                view.frame.origin.y -= keyBoardHeight
                keyboardRequiredShift = true
            }
        }
    }
    
    override func keyboardDidShow(notification: NSNotification) {
        keyboardOnScreen = keyboardRequiredShift
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification: notification)
            keyboardRequiredShift = false
        }
    }

    override func keyboardDidHide(notification: NSNotification) {
        keyboardOnScreen = false
    }

}
