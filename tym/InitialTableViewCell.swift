//
//  InitialTableViewCell.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var tymButton: RoundButton!
    
    var delegate: TymCellDelegate!
    var indexPath: IndexPath!
    var timer: Timer!
    var expansionFactor: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    //MARK: Delegate methods - allow allocation of tym for duration pressed 
    //MARK: tymButton animation methods
    
    @IBAction func startRecordingTym(_ sender: RoundButton) {
        self.delegate.tymStart(indexPath: indexPath)
        expansionFactor = Constants.TymButtonAnimationKeys.ButtonBaseSizeFactor
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.TymButtonAnimationKeys.TimeLoopRepeat), target: self, selector: #selector(expandButtton), userInfo: nil, repeats: true)
    }
   
    @IBAction func endRecordingTym(_ sender: RoundButton) {
        self.delegate.tymEnd(indexPath: indexPath)
        self.delegate.tymAllocate(indexPath: indexPath)
        
        resetButton()
    }
    
    @IBAction func endRecordingTymOutside(_ sender: RoundButton) {
        self.delegate.tymEnd(indexPath: indexPath)
        self.delegate.tymAllocate(indexPath: indexPath)
        
        resetButton()
    }
    
    func expandButtton() {
        
        if expansionFactor! < Constants.TymButtonAnimationKeys.MaximumSizeTymButton {
            expansionFactor = (expansionFactor + ((Constants.TymButtonAnimationKeys.TymButtonExpansionRateInverse / 3) * (Constants.TymButtonAnimationKeys.TimeLoopRepeat)))
        }
        
        UIView.animate(withDuration: (Double(Constants.TymButtonAnimationKeys.TymButtonExpansionRateInverse) * TimeInterval(Constants.TymButtonAnimationKeys.TimeLoopRepeat))) {
            self.tymButton.transform = CGAffineTransform(scaleX: self.expansionFactor, y: self.expansionFactor)
        }
    }
    
    // tymButton reset after button press event
    
    func resetButton() {
        timer.invalidate()
        tymButton.isEnabled = false
        
        UIView.animate(withDuration: Constants.TymButtonAnimationKeys.TymButtonJumpBackTime, animations: {
            self.tymButton.transform = CGAffineTransform(scaleX: Constants.TymButtonAnimationKeys.ButtonBaseSizeFactor, y: Constants.TymButtonAnimationKeys.ButtonBaseSizeFactor)
        }) { (true) in
            self.tymButton.isEnabled = true
        }
    }

    
    // UI set up
    
    func configureUI() {
        contentImage.layer.cornerRadius = 4.0
        contentImage.clipsToBounds = true
        
        tymButton.frame.size.height = 0.5 * buttonContainerView.frame.height
    }
    
    
}
