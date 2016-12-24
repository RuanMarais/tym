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

class DatabaseHandling {
    
    //MARK: Properties
    
    static let sharedInstance = DatabaseHandling()
    
    fileprivate var ref: FIRDatabaseReference!
    fileprivate var authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    
    var userID = "Anonymous"
    var isSignedIn: Bool = false
    var displayName = "Anonymous"
    
    // Establish database connection 
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    // Post to database method
    
    func createPost(textSectionOne: String?, imageSectionOne: Data?, textSectionTwo: String?, imageSectionTwo: Data?, timeGateSectionTwo: Int?) {
        var postData = [String:String]()
        
        if let text1 = textSectionOne {
            postData[Constants.DatabaseKeys.textOne] = text1
        }
        if let text2 = textSectionTwo {
            postData[Constants.DatabaseKeys.textTwo] = text2
        }
        postData[Constants.DatabaseKeys.user] = displayName
        
        ref.child(Constants.DatabaseKeys.posts + "/" + Constants.DatabaseKeys.user + "/" + userID).childByAutoId().setValue(postData)
        
    }
    
    // Auth configuration
    
    func configureAuth(viewController: UIViewController) {
        FUIAuth.defaultAuthUI()?.providers = [FUIGoogleAuth()]
        
        authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    self.isSignedIn = true
                    let name = user?.email?.components(separatedBy: "@")[0]
                    self.displayName = name!
                    self.userID = (user?.uid)!
                }
                
            } else {
                self.isSignedIn = false
                self.loginSession(viewController: viewController)
            }
        })
       
    }
    
    func loginSession(viewController: UIViewController) {
        let authVC = FUIAuth.defaultAuthUI()?.authViewController()
        viewController.present(authVC!, animated: true, completion: nil)
    }
}
