//
//  Options.swift
//  Proj2
//
//  Created by Kruthika Holla on 10/11/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//


import UIKit

class Options: NSObject {
    
    //Game options
    var fourCardsSelected :Bool = false
    var sixteenCardsSelected: Bool = true
    var thirtySixCardsSelected: Bool = false
    var numberOfCardsInGrid: Int = 0
    var challengeModeOn: Bool = false
   
    
    func setNumberOfCardsInGrid (){
        if (fourCardsSelected){
            numberOfCardsInGrid = 2
        }
        else if (sixteenCardsSelected){
            numberOfCardsInGrid = 8
        }
        else{
            numberOfCardsInGrid = 18
        }
    }
    
    //MARK: Save User options to NSUserDefaults
    func saveData(){
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(fourCardsSelected, forKey: "fourCards")
        prefs.setValue(sixteenCardsSelected, forKey: "sixteenCards")
        prefs.setValue(thirtySixCardsSelected, forKey: "thirtySixCards")
        prefs.synchronize()
    }
    
    //MARK: Load options
    func loadData(){
        let prefs = NSUserDefaults.standardUserDefaults()
        if let _ = prefs.boolForKey("fourCards") as Bool?{
            fourCardsSelected = prefs.boolForKey("fourCards")
        }
        if let _ = prefs.boolForKey("sixteenCards") as Bool?{
            sixteenCardsSelected = prefs.boolForKey("sixteenCards")
        }
        if let _ = prefs.boolForKey("thirtSixCards") as Bool?{
            thirtySixCardsSelected = prefs.boolForKey("thirtySixCards") 
        }
        
    }
}
