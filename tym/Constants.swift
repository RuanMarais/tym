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

    struct UIConstants {
        static let MainColour = UIColor(colorLiteralRed: 0.620, green: 0.004, blue: 0.949, alpha: 1.0)
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
    }
}
