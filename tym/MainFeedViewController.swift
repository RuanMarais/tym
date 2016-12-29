//
//  MainFeedViewController.swift
//  tym
//
//  Created by Dr GJK Marais on 2016/12/20.
//  Copyright © 2016 RuanMarais. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI

class MainFeedViewController: BaseUIViewController {
    
    //MARK: Properties - UI elements
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var mainFeedTableView: UITableView!
    
    @IBOutlet weak var newPostsButton: UIBarButtonItem!
    @IBOutlet weak var feauturedPostsButton: UIBarButtonItem!
    @IBOutlet weak var topPostsButton: UIBarButtonItem!
    
    //MARK: Properties - Database
    
    var postsTop: [FIRDataSnapshot]! {
       return DatabaseHandling.sharedInstance.postsTop
    }
    var postsFeatured: [FIRDataSnapshot]! {
        return DatabaseHandling.sharedInstance.postsFeatured
    }
    var postsNew: [FIRDataSnapshot]! {
        return DatabaseHandling.sharedInstance.postsNew
    }
    
    //MARK: Properties - tym allocation 
    
    var timer: Timer!
    var tymAllocationTemporaryStorage: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: TableView Delegate methods

extension MainFeedViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = mainArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "initial", for: indexPath) as! InitialTableViewCell
        cell.indexPath = indexPath
        cell.contentImage.image = UIImage(named: object["imageName"] as! String)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
}

//MARK: TymCell Delegate methods for saving added tym to user created object

extension MainFeedViewController: TymCellDelegate {
    
    func tymStart(indexPath: IndexPath) {
        tymAllocationTemporaryStorage = Constants.TymAllocationConstants.TymBaseValuePerPress
        timer = Timer.scheduledTimer(withTimeInterval: Constants.TymAllocationConstants.TymInterval, repeats: true, block: { (timer) in
            self.tymAllocationTemporaryStorage! += Constants.TymAllocationConstants.TymValueAllocationPerLoop
        })
    }
    
    func tymEnd(indexPath: IndexPath) {
        timer.invalidate()
        tymAllocate(indexPath: indexPath)
    }
    
    func tymAllocate(indexPath: IndexPath) {
        let oldTymValue = mainArray[indexPath.row]["tym"] as! Int
        let newTymValue = oldTymValue + tymAllocationTemporaryStorage
        mainArray[indexPath.row]["tym"] = newTymValue
    }
    
}

extension MainFeedViewController {
    
    // configuration methods
    
    func configure() {
        configureUI()
        
    }
    
    func configureUI() {
        configureTopToolBarColorGradient(topToolBar: topToolBar, mainView: self.view)
    }
}

extension MainFeedViewController {
    
    //Get data from database to display in tableview 
    
    func retrieveData() {
        
    }
    
}
