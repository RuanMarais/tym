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
    var imageForUploadSection1Data: Data?
    
    // To distinguish to which section an imge is allocated on imagepicker/camera call
    var imageAllocationSection1 = false
    
    //MARK: Properties - Section 2
    
    var section2Present = false
    @IBOutlet weak var textPreviewSection2: UITextView!
    @IBOutlet weak var imagePreviewSection2: UIImageView!
    @IBOutlet weak var labelTextFieldSection2: UILabel!
    @IBOutlet weak var labelImageButtonSection2: UILabel!
    @IBOutlet weak var imageButtonSection2: UIButton!
    @IBOutlet weak var labelDurationInputSection2: UILabel!
    @IBOutlet weak var durationInputSliderSection2: UISlider!
    @IBOutlet weak var textFieldSection2: UITextField!
    var imageForUploadSection2Data: Data?
    
    //MARK: Properties - controllers 
    
    var imageActionSheet: UIAlertController!

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
    
    override func viewWillAppear(_ animated: Bool) {
        clearPostInputFields()
    }
    
    // Add image to post button press events
    
    @IBAction func addImageToPostSection1(_ sender: Any) {
        imageAllocationSection1 = true
        self.present(imageActionSheet!, animated: true, completion: nil)
    }
    
    @IBAction func addImageToPostSection2(_ sender: Any) {
        self.present(imageActionSheet!, animated: true, completion: nil)
    }
       
    
    @IBAction func clearPostFields(_ sender: Any) {
    }
    
    @IBAction func previewCreatedPost(_ sender: Any) {
    }
    
    @IBAction func postToDatabase(_ sender: Any) {
        
        // Create post struct
        var post = Post(postDictionary: [:])
        
        //Add text if available for section 1
        if (textPreviewSection1.text != nil) && (textPreviewSection1.text != "") {
            let text1 = textPreviewSection1.text
            post.postData[Constants.DatabaseKeys.textOne] = text1
        }
        
        //Add text and timegate if available for section 2
        if section2Present {
            if (textPreviewSection2.text != nil) && (textPreviewSection2.text != "") {
                let text2 = textPreviewSection2.text
                post.postData[Constants.DatabaseKeys.textTwo] = text2
            }
            let timeGate = Int(durationInputSliderSection2.value)
                post.postData[Constants.DatabaseKeys.timeGateSection2] = "\(timeGate)"
            
        }
        
        //Call database and storage methods 
        DatabaseHandling.sharedInstance.createPost(postTextOnly: post, dataImageSection1: imageForUploadSection1Data, dataImageSection2: imageForUploadSection2Data) { (success, error) in
            Dispatch.sharedInstance.performUpdatesOnMain(updates: { 
                if success {
                    //alert success
                } else {
                    print(error?.userInfo[NSLocalizedDescriptionKey] as! String)
                    switch error?.userInfo[NSLocalizedDescriptionKey] as! String {
                    case Constants.ErrorMessages.NoDatabaseReference.rawValue, Constants.ErrorMessages.NoStorageReference.rawValue:
                    //alert database
                    break
                    case Constants.ErrorMessages.NotSignedIn.rawValue:
                        DatabaseHandling.sharedInstance.loginSession(viewController: self)
                    default:
                        //alert storage
                        break
                    }
                }
            })
        }
    }
    
}

// Configure class inistialisation

extension NewPostViewController {
    
    func configure() {
        
        // UI elements for configuration 
        
        configureNewPostTextField(firstSection: true, textField: textFieldSection1)
        configureNewPostTextField(firstSection: false, textField: textFieldSection2)
        keyboardOnScreen = false
        keyboardRequiredShift = false
        subscribeKeyboardNotifications()
        
        //Alerts and actions 
        
        imageActionSheet = UIAlertController(title: Constants.AlertMessages.AddImageTitle, message: Constants.AlertMessages.AddImageMessage, preferredStyle: .actionSheet)
        
        let imageChoiceLibrary = UIAlertAction(title: Constants.AlertMessages.Library, style: .default) { (action) in
                self.presentPhotoLibraryImagePicker(viewController: self, delegate: self)
        }
        
        let imageChoiceCamera = UIAlertAction(title: Constants.AlertMessages.Camera, style: .default) { (action) in
            //Add segue to camera view here
        }
        
        let imageChoiceCancel = UIAlertAction(title: Constants.AlertMessages.Cancel, style: .cancel) { (action) in
                self.imageActionSheet.dismiss(animated: true, completion: nil)
        }
        
        imageActionSheet.addAction(imageChoiceCamera)
        imageActionSheet.addAction(imageChoiceLibrary)
        imageActionSheet.addAction(imageChoiceCancel)
       
        // Authorisation 
        
        DatabaseHandling.sharedInstance.configureAuth(viewController: self)
        
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

// Photolibrary delegate

extension NewPostViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let imageData = UIImageJPEGRepresentation(image, 0.8) {
            
            if imageAllocationSection1 {
                imagePreviewSection1.image = image
                imageForUploadSection1Data = imageData
                imageAllocationSection1 = false
            } else {
                imagePreviewSection2.image = image
                imageForUploadSection2Data = imageData
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageAllocationSection1 = false
        picker.dismiss(animated: true, completion: nil)
    }
}
