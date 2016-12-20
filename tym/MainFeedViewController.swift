//
//  MainFeedViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/20.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController {
    
    var mainArray = [["name": "Anonymous", "imageName": "Image", "tym": 100]]
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainFeedViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
}

extension MainFeedViewController: TymCellDelegate {
    
    func tymStart(indexPath: IndexPath) {
        
    }
    
    func tymEnd(indexPath: IndexPath) {
        
    }
    
    func tymAllocate(indexPath: IndexPath) {
        
    }
    
    func tymViewScreen(indexPath: IndexPath) {
        
    }
}

