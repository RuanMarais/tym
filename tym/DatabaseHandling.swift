//
//  DatabaseHandling.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/24.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import FirebaseAuthUI
import Firebase
import FirebaseGoogleAuthUI
import FirebaseStorageUI
import FirebaseDatabaseUI

class DatabaseHandling {
    
    //MARK: Properties
    
    static let sharedInstance = DatabaseHandling()
    
    fileprivate var ref: FIRDatabaseReference!
    fileprivate var authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    var storageRef: FIRStorageReference!
    var userID: String? {
        return FIRAuth.auth()?.currentUser?.uid
    }
    var isSignedIn: Bool = false
    var displayName: String? = "Anonymous"
    
    //database elements observed
    
    var postsTop: [FIRDataSnapshot]! = []
    var postsFeatured: [FIRDataSnapshot]! = []
    var postsNew: [FIRDataSnapshot]! = []
    var postsOwn: [FIRDataSnapshot]! = []
    var tymOwn: [FIRDataSnapshot]! = []
    
    // Deconfigure listeners 
    
    deinit {
        FIRAuth.auth()?.removeStateDidChangeListener(authHandle)
    }
    
    // Establish database connection and check if user has been added to the database 
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        updateUserList()
    }
    
    // Post to database method
    
    func createPost(postTextOnly: Post, dataImageSection1: Data?, dataImageSection2: Data?, completionHandlerForCreatePost: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        
        //set up the dictionary that will be posted to database
        var postData = postTextOnly.postData
        
        // Add display name and initialise allocated tym
        postData[Constants.DatabaseKeys.user] = displayName as AnyObject
        postData[Constants.DatabaseKeys.tym] = 0 as AnyObject
        postData[Constants.DatabaseKeys.timestamp] = Constants.DatabaseKeys.serverTime as AnyObject
        
        // Error handling
        func sendError(error: String) {
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForCreatePost(false, NSError(domain: "createPost", code: 1, userInfo: userInfo))
        }
        
        //Reference to database available
        guard (ref != nil) else {
            sendError(error: Constants.ErrorMessages.NoDatabaseReference.rawValue)
            return
        }
        
        //Reference to storage available
        guard (storageRef != nil) else  {
            sendError(error: Constants.ErrorMessages.NoStorageReference.rawValue)
            return
        }
        
        //user signed in
        guard (isSignedIn) else {
            sendError(error: Constants.ErrorMessages.NotSignedIn.rawValue)
            return
        }
        
        //get userID
        guard let userID = userID else {
            sendError(error: Constants.ErrorMessages.NotSignedIn.rawValue)
            return
        }
        
        //check if post contains an image in section 1
        if let data1 = dataImageSection1 {
            //if image present in section one - save image to storage
            sendToStorage(imageData: data1, completionHandlerForSendToStorage: { (success, url, error) in
                if success {
                    //if image successfully saved to storage, get url from completionhandler and add to postData
                    postData[Constants.DatabaseKeys.imageUrlOne] = url! as AnyObject?
                    //check if post contains an image in section 2
                    if let data2 = dataImageSection2 {
                        //if image present - save image to storage
                        self.sendToStorage(imageData: data2, completionHandlerForSendToStorage: { (success, url, error) in
                            if success {
                                //if image successfully saved to storage, get url from completionhandler and add to postData
                                postData[Constants.DatabaseKeys.imageUrlTwo] = url! as AnyObject?
                                //send completed postData to database and pass success to completionhandler
                                self.ref.child(Constants.DatabaseKeys.posts).child(Constants.DatabaseKeys.user).child(userID).childByAutoId().setValue(postData)
                                completionHandlerForCreatePost(true, nil)
                            } else {
                                completionHandlerForCreatePost(false, error)
                            }
                        })
                    } else {
                        self.ref.child(Constants.DatabaseKeys.posts).child(Constants.DatabaseKeys.user).child(userID).childByAutoId().setValue(postData)
                        completionHandlerForCreatePost(true, nil)
                    }
                } else {
                    completionHandlerForCreatePost(false, error)
                }
            })
        } else {
            //if no images were present in post, pass postData to database
            ref.child(Constants.DatabaseKeys.posts).child(Constants.DatabaseKeys.user).child(userID).childByAutoId().setValue(postData)
            completionHandlerForCreatePost(true, nil)
        }
    }
    
    // Auth configuration
    
    func configureAuth(viewController: UIViewController) {
        FUIAuth.defaultAuthUI()?.providers = [FUIGoogleAuth()]
        
        authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.isSignedIn = true
                    if let name = user?.displayName {
                        self.displayName = name
                    } else {
                        self.displayName = user?.email?.components(separatedBy: "@")[0]
                    }
                    self.signedInConfigure(isSignedIn: true)
                }
                
            } else {
                self.signedInConfigure(isSignedIn: false)
                self.loginSession(viewController: viewController)
            }
        })
       
    }
    
    // Presents the authentication viewcontroller if not logged in
    
    func loginSession(viewController: UIViewController) {
        let authVC = FUIAuth.defaultAuthUI()?.authViewController()
        viewController.present(authVC!, animated: true, completion: nil)
    }
    
    // Gets storage reference
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }
    
    // Saves image to storage 
    
    func sendToStorage(imageData: Data, completionHandlerForSendToStorage: @escaping (_ success: Bool, _ imageUrl: String?, _ error: NSError?) -> Void) {
        
        //set the image location on storage 
        
        let imagePath = Constants.StorageKeys.PostPhotosFolder + userID! + "\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metaData = FIRStorageMetadata()
        metaData.contentType = Constants.StorageKeys.contentTypeJPEG
        
        //Method for saving image data in storage
        storageRef.child(imagePath).put(imageData, metadata: metaData) { (meta, error) in
            
            //handle errors in saving data to storage
            guard (error == nil) else {
                completionHandlerForSendToStorage(false, nil, error as NSError?)
                return
            }
            
            guard let meta = meta else {
                completionHandlerForSendToStorage(false, nil, error as NSError?)
                return
            }
            
            //get url for saved image for storage in database - passed to completion handler
            let url = self.storageRef.child(meta.path!).description
            completionHandlerForSendToStorage(true, url, nil)
        }
    }
    
    //establish connection to database and storage if signed in
    
    func signedInConfigure(isSignedIn: Bool) {
        if (isSignedIn) {
            configureStorage()
            configureDatabase()
            self.isSignedIn = isSignedIn
        }
    }
    
    //checks if current user has been created on database and adds a user with initialised tym if not
    
    func updateUserList() {
        let username = displayName!
        let userSetUpData = [Constants.DatabaseKeys.user: username as AnyObject, Constants.DatabaseKeys.tym: 0 as AnyObject, Constants.DatabaseKeys.timestamp: Constants.DatabaseKeys.serverTime as AnyObject] as [String : AnyObject]
        ref.child(Constants.DatabaseKeys.userList).observeSingleEvent(of: .value, with: { (userSnapshot) in
            if !(userSnapshot.hasChild(self.userID!)) {
                self.ref.child(Constants.DatabaseKeys.userList).child(self.userID!).setValue(userSetUpData)
            }
        })
    }
    
    func retrievePostsForUser(userID: String) {
        ref.child(Constants.DatabaseKeys.posts).child(Constants.DatabaseKeys.user).child(userID).queryLimited(toFirst: Constants.DatabaseKeys.queryLimit).observe(.childAdded, with: { (snapshot) in
            self.postsNew.append(snapshot)
        })
        ref.child(<#T##pathString: String##String#>)
    }
    
}
