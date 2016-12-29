//
//  Constants.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    // Constants for UI elements 

    struct UIConstants {
        static let MainColour = UIColor(colorLiteralRed: 0.620, green: 0.004, blue: 0.949, alpha: 1.0)
    }
    
    // ActionSheet and Alert messages
    
    struct AlertMessages {
        static let AddImageTitle = "Add an Image"
        static let AddImageMessage = "Choose the source"
        static let Camera = "Camera"
        static let Library = "Library"
        static let Cancel = "Cancel"
    }
    
    // tymButton animation keys, expansion rate increases as tymExpansionRateInverse decreases
    
    struct TymButtonAnimationKeys {
        static let TimeLoopRepeat: CGFloat = 0.1
        static let ButtonBaseSizeFactor: CGFloat = 1.0
        static let TymButtonExpansionRateInverse: CGFloat = 6.0
        static let TymButtonJumpBackTime: TimeInterval = 0.6
        static let MaximumSizeTymButton: CGFloat = 3.0
    }
    
    // adjust TymValueAllocationPerLoop to increase or decrease the value added to object per timer loop
    
    struct TymAllocationConstants {
        static let TymInterval: TimeInterval = 1.0
        static let TymValueAllocationPerLoop: Int = 1
        static let TymBaseValuePerPress: Int = 1
    }
    
    // new Post textField constants 
    
    struct TextFieldConstants {
        static let TextFieldPadding = 13.0
        static let NewPostTextFieldPlaceholderTextSection1 = "Thoughts?"
        static let NewPostTextFieldPlaceholderTextSection2 = "They took the time, so anything else?"
        static let MaxTextPostCharacterLength = 100
    }
    
    // Firebase database keys
    
    struct DatabaseKeys {
        static let userList = "users"
        static let posts = "posts"
        static let user = "userName"
        static let textOne = "textOne"
        static let textTwo = "textTwo"
        static let imageUrlOne = "imageUrlOne"
        static let imageUrlTwo = "imageUrlTwo"
        static let tym = "tym"
        static let timeGateSection2 = "timeGate"
        static let timestamp = "timestamp"
        static let serverTime = [".sv": "timestamp"]
        static let queryLimit: UInt = 50
    }
    
    // Firebase storage keys
    
    struct StorageKeys {
        static let PostPhotosFolder = "posts_photos/"
        static let contentTypeJPEG = "image/jpeg"
    }
    
    // Enum for database and storage handling error strings
    
    enum ErrorMessages: String {
        case NotSignedIn = "User Not Signed In"
        case NoDatabaseReference = "No Database Reference"
        case NoStorageReference = "No Storage Reference Found"
    }
}
