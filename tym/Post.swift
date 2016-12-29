//
//  Post.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/24.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    
    //Dictionary containing elements of each post 
    
    var postData: [String: AnyObject]
    
    init (postDictionary: [String: AnyObject]) {
        postData = postDictionary
    }
    
}
