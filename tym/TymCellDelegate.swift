//
//  TymCellDelegate.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import Foundation

protocol TymCellDelegate {
    func tymStart(indexPath: IndexPath)
    func tymEnd(indexPath: IndexPath)
    func tymAllocate(indexPath: IndexPath)
}
