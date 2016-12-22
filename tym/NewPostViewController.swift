//
//  NewPostViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class NewPostViewController: BaseUIViewController {
    
    //MARK: Properties - Toolbar
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var clearButtonTopToolbar: UIBarButtonItem!
    @IBOutlet weak var previewButtonTopToolbar: UIBarButtonItem!
    @IBOutlet weak var postButtonTopToolbar: UIBarButtonItem!
    
    //MARK: Properties - Section 1
    
    @IBOutlet weak var imagePreviewSection1: UIImageView!
    @IBOutlet weak var textPreviewSection1: UITextView!
    @IBOutlet weak var labelTextFieldSection1: UILabel!
    @IBOutlet weak var labelImageButtonSection1: UILabel!
    @IBOutlet weak var imageButtonSection1: UIButton!
    
    //MARK: Properties - Section 2
    
    @IBOutlet weak var textPreviewSection2: UITextView!
    @IBOutlet weak var imagePreviewSection2: UIImageView!
    @IBOutlet weak var labelTextFieldSection2: UILabel!
    @IBOutlet weak var labelImageButtonSection2: UILabel!
    @IBOutlet weak var imageButtonSection2: UIButton!
    @IBOutlet weak var labelDurationInputSection2: UILabel!
    @IBOutlet weak var durationInputSliderSection2: UISlider!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
