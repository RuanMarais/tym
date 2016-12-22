//
//  BaseUIViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/22.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTopToolBar(topToolBar: UIToolbar, mainView: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [Constants.UIConstants.MainColour.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: mainView.frame.size.width, height: 64.0)
        topToolBar.setBackgroundImage(createImage(layer: gradient), forToolbarPosition: .any, barMetrics: .default)
    }
    
    private func createImage(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let createdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return createdImage!
    }


}
