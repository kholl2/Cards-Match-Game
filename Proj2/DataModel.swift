//
//  DataModel.swift
//  Proj2
//
//  Created by Kruthika Holla on 10/11/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

protocol cellDataDelegate: class{
    func updateCell (cellCards:[String])
    func userChoseCancel()
    func timerDataUpdate(timerData: [String: Int])
}

class DataModel: NSObject {
    weak var delegate: cellDataDelegate?
    private let frontOfCards : [String] = ["🌵", "🌴",  "🙈", "🍀", "🐷", "🐣", "🍉", "🐶", "🐘", "🐮", "🍕", "🍭","👻", "💩", "🐙", "🐝", "🐩", "🙊" ]
    let backOfCards: String = "🎭"
    
    var displayCards: [String] = [] //cards to be displayed
    var chosenCardsArray: [String] = [] //cards chosen by user
    var chosenCardsIndex: [Int] = []
    var chosenIndexPath: [NSIndexPath] = []
    var allMatchedCardsArrray: [String] = [] //matched cards are saved
    var timer: NSTimer = NSTimer()//timer to animate card flip
    var timerMode: NSTimer = NSTimer()//timer for the challenge mode
    var timerStartTime: NSTimeInterval = NSTimeInterval()
    var gameTime:Double = 0
    
    //MARK: Choose cards to shuffle based on user settings
    func chooseCards (howManyCards : Int){
        var rand_cards: [String] = []
        rand_cards = frontOfCards
        var temp:String
        var returnCards:[String] = []
        
        for (var i = 0; i < rand_cards.count; i++) {
            let randn = Int(arc4random_uniform(18))
            temp = rand_cards[i]
            rand_cards[i] = rand_cards[randn]
            rand_cards[randn] = temp
        }
        
        for(var i = 0; i < howManyCards/2; i++){
            returnCards.insert(rand_cards[i], atIndex: i)
        }
        returnCards.appendContentsOf(returnCards)
        returnCards = shuffleDisplayCards(returnCards)
        self.delegate?.updateCell(returnCards)
    }
    
    //MARK: Shuffle the cards
    private func shuffleDisplayCards (var cards : [String]) -> [String]{
        let count = cards.count
        var temp:String
        for i in 0..<cards.count{
            let rand_index = Int(arc4random_uniform(UInt32(count)))
            temp = cards[i]
            cards[i] = cards[rand_index]
            cards[rand_index] = temp
        }
        return cards
    }
    
    //MARK: Save the cards selected by user to flip
    func saveChosenCards(card: String, index: Int, indexP: NSIndexPath){
        chosenCardsArray.insert(card, atIndex: 0)
        chosenCardsIndex.insert(index, atIndex: 0)
        chosenIndexPath.insert(indexP, atIndex: 0)
    }
    
    //MARK: Check for card match
    func checkForMatch (cardArray: [String]) -> Bool{
        if (cardArray.count % 2 == 0){
            return true
        }
                
        else{
            return false
        }
    }
    
    
    //MARK: Save the matched card in an array
    func cardMatch (cardArray: [String]) -> Bool{
        if (cardArray[0] == cardArray[1]){
            allMatchedCardsArrray.insert(cardArray[0], atIndex: 0)
            return true
        }
        else{
            return false
            
        }
    }
    
    //MARK: Check if game over
    func allCardsMatched (gameSetting: Int) -> Bool{
        if(gameSetting == 2 && allMatchedCardsArrray.count == 2){
            return true
        }
        if(gameSetting == 8 && allMatchedCardsArrray.count == 8){
            return true
        }
        if(gameSetting == 18 && allMatchedCardsArrray.count == 18){
            return true
        }
        return false
    }
    
    //MARK: Show chosen cards animation
    func showCards (cell: CardGameCollectionViewCell, index: Int){
        UIView.transitionWithView(cell, duration: 0.7,
            options:  UIViewAnimationOptions.TransitionFlipFromRight,
            animations: { () -> Void in
                cell.backgroundColor = UIColor.lightGrayColor()
                cell.itemLabel.text = self.displayCards[index]
                
            }, completion: nil)
    }
    
    //MARK: flip cards if no match
    func noMatchFlip (timer: NSTimer){
        let dict = timer.userInfo as! NSDictionary
        flipCardsNoMatch(dict["cell1"] as! CardGameCollectionViewCell, cell2: dict["cell2"] as! CardGameCollectionViewCell)
    }
    
    func flipCardsNoMatch(cell1: CardGameCollectionViewCell, cell2: CardGameCollectionViewCell){
         cell2.backgroundColor = UIColor.blackColor()
        cell1.backgroundColor = UIColor.blackColor()
        UIView.transitionWithView(cell1, duration: 0.7,
            options:  UIViewAnimationOptions.TransitionFlipFromLeft,
            animations: { () -> Void in
                cell1.itemLabel.text = self.backOfCards
               
            }, completion: nil)
        
        UIView.transitionWithView(cell2, duration: 0.7,
            options:  UIViewAnimationOptions.TransitionFlipFromLeft,
            animations: { () -> Void in
                cell2.itemLabel.text = self.backOfCards
               
                
            }, completion: nil)

    }
    
    func runNoMatchFlip (cell1: CardGameCollectionViewCell, cell2: CardGameCollectionViewCell){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "noMatchFlip:", userInfo: ["cell1": cell1, "cell2": cell2], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    //MARK: Show alert on game over
    func alertShowTimer(collectionView: UICollectionView){
         timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "passToShowAlert:", userInfo: ["colView": collectionView], repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func passToShowAlert(timer: NSTimer){
        let dict = timer.userInfo as! NSDictionary
        showAlert(dict["colView"] as! UICollectionView)
    }
    
    func showAlert(collectionView: UICollectionView){
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
        let continueGameAlert = UIAlertController(title: "You win!!", message: "Start new game", preferredStyle: UIAlertControllerStyle.Alert)
        continueGameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) -> Void in
            self.chosenCardsArray.removeAll()
            self.chosenIndexPath.removeAll()
            self.chosenCardsIndex.removeAll()
            self.allMatchedCardsArrray.removeAll()
            collectionView.reloadData()
           /* collectionView.performBatchUpdates({ () -> Void in
                collectionView.reloadSections(NSIndexSet.index.sectionIndex)
                }, completion: nil)*/
        }))
        continueGameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.stopTimer()
            self.delegate?.userChoseCancel()
        }))
        rootViewController.presentViewController(continueGameAlert, animated: true, completion: nil)
        
    }
    
    //MARK: Challenge mode
    func fireTimer(collectionView: UICollectionView){
        timerMode = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"timerSetterInitial:", userInfo:["colView": collectionView], repeats:true)
        NSRunLoop.mainRunLoop().addTimer(timerMode, forMode: NSRunLoopCommonModes)
        timerStartTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func timerSetterInitial (timer: NSTimer){
        let dict = timer.userInfo as! NSDictionary
        timerSetter(dict["colView"] as! UICollectionView)
    }
    
    func timerSetter(collectionView: UICollectionView){
        var timerData = [String: Int]()
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        let timePassed: NSTimeInterval = currentTime - timerStartTime
        let secs = gameTime - timePassed
        let minutesPassed = Int(secs/60)
        if (secs > 0){
            timerData["timerMinutes"] = minutesPassed
            if (secs > 60){
                timerData["timerSeconds"] = Int(secs % 60)
            }
            else{
                timerData["timerSeconds"] = Int(secs)
            }
        }
        
        if (secs <= 0){
            stopTimer()
            showTimerAlert(collectionView)
        }
        
        self.delegate?.timerDataUpdate(timerData)
        
    }
    
    func stopTimer(){
        timerMode.invalidate()
    }
    
    func setTime(pick: Int){
        if (pick == 4){
            gameTime = 31
        }
        if (pick == 16){
            gameTime = 61
        }
        if (pick == 36){
            gameTime = 121
        }
    }
    
    //MARK: ALert if time run out
    func showTimerAlert(collectionView: UICollectionView){
        let rootViewController: UIViewController = UIApplication.sharedApplication().windows[0].rootViewController!
        let continueGameAlert = UIAlertController(title: "You Lose!!", message: "Start new game", preferredStyle: UIAlertControllerStyle.Alert)
        continueGameAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) -> Void in
            self.chosenCardsArray.removeAll()
            self.chosenIndexPath.removeAll()
            self.chosenCardsIndex.removeAll()
            self.allMatchedCardsArrray.removeAll()
            collectionView.reloadData()
        }))
        continueGameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.stopTimer()
            self.delegate?.userChoseCancel()
        }))
        rootViewController.presentViewController(continueGameAlert, animated: true, completion: nil)
        
    }
    
        
}




