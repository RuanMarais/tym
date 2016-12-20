//
//  RoundButton.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        roundButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundButton()
    }
    
    private func roundButton() {
        self.clipsToBounds = true
        layer.cornerRadius = 0.5 * self.frame.height
        backgroundColor = Constants.UIConstants.MainColour
        self.frame.size.width = self.frame.height
    }
    
}
