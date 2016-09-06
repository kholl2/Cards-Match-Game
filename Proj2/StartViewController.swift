//
//  StartViewController.swift
//  Proj2
//
//  Created by Kruthika Holla on 10/11/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    var myGameOptions = Options()
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Load data from NSUserDefaults
        myGameOptions.loadData()
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playID" ){
            let to: ViewController = segue.destinationViewController as! ViewController
            myGameOptions.challengeModeOn = false
            to.gameOptions = myGameOptions
        }
        if (segue.identifier == "optionsID"){
            let to: OptionsViewController = segue.destinationViewController as! OptionsViewController
            to.gameOptions = myGameOptions
        }
        if (segue.identifier == "timerOnPlay"){
            let to: ViewController = segue.destinationViewController as! ViewController
            myGameOptions.challengeModeOn = true
            to.gameOptions = myGameOptions
        }
    }
    
}
