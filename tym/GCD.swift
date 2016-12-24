//
//  GCD.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/24.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

class Dispatch {
    
    static let sharedInstance = Dispatch()
    
    //Main Queue
    
    func performUIUpdatesOnMain(updates: @escaping () -> Void) {
        DispatchQueue.main.async(execute: updates)
    }
    
    //Background tasks 
    
    func performDataUpdatesOnBackground(updates: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async(execute: updates)
    }
}
