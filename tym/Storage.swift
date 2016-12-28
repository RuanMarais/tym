//
//  Storage.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/28.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

class Storage {
    
    static let sharedInstance = Storage()
    
    //Variables for camera capture image storage
    
    var cameraViewTemporaryImageSection1: UIImage?
    var cameraViewTemporaryImageSection2: UIImage?
    var cameraViewTemporaryImageSection1Data: Data? {
        if let imageData = UIImageJPEGRepresentation(cameraViewTemporaryImageSection1!, 0.8) {
            return imageData
        } else {
            return nil
        }
    }
    var cameraViewTemporaryImageSection2Data: Data? {
        if let imageData = UIImageJPEGRepresentation(cameraViewTemporaryImageSection2!, 0.8) {
            return imageData
        } else {
            return nil
        }
    }
    
    
}
