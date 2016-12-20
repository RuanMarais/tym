//
//  InitialTableViewCell.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/21.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class InitialTableViewCell: UITableViewCell {
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var tymButton: RoundButton!
    
    var delegate: TymCellDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageButton.layer.cornerRadius = 8.0
        self.contentView.layer.cornerRadius = 4.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func startRecordingTym(_ sender: RoundButton) {
        self.delegate.tymStart(indexPath: indexPath)
    }
   
    @IBAction func endRecordingTym(_ sender: RoundButton) {
        self.delegate.tymEnd(indexPath: indexPath)
        self.delegate.tymAllocate(indexPath: indexPath)
    }
    
    @IBAction func endRecordingTymOutside(_ sender: RoundButton) {
        self.delegate.tymEnd(indexPath: indexPath)
        self.delegate.tymAllocate(indexPath: indexPath)
    }
    
    @IBAction func showImageMainView(_ sender: Any) {
    }
    
}
