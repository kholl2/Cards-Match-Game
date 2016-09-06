//
//  ViewController.swift
//  Proj2
//
//  Created by Kruthika Holla on 10/11/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, cellDataDelegate {

    let data = DataModel()
    var gameOptions = Options()
    private var twoCardsChosen = false
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data.delegate = self
    }
    
    //MARK: Keep track of Landscape or potrait mode
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionViewOutlet.collectionViewLayout.invalidateLayout()
    }
    

    func updateCell(cellCards: [String]) {
        data.displayCards = cellCards
    }
    
    
    //MARK: Number of sections in collection view
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Return number of cells in collection view
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //If challenge mode on, set different timers
        if (gameOptions.challengeModeOn){
            timerLabel.hidden = false
            if (gameOptions.fourCardsSelected){
                data.setTime(4)
                data.fireTimer(collectionViewOutlet)
            }
            else if gameOptions.sixteenCardsSelected{
                data.setTime(16)
                data.fireTimer(collectionViewOutlet)
            }
            else{
                data.setTime(36)
                data.fireTimer(collectionViewOutlet)
            }
        }
        else{
            timerLabel.hidden = true
        }
        if (gameOptions.fourCardsSelected){
            data.chooseCards(4)
            gameOptions.setNumberOfCardsInGrid()
            return 4
        }
        else if (gameOptions.sixteenCardsSelected){
            data.chooseCards(16)
            gameOptions.setNumberOfCardsInGrid()
            return 16
        }
        else {
            data.chooseCards(36)
            gameOptions.setNumberOfCardsInGrid()
            return 36
        }
    }
    
    
    //MARK: Cell data for collection view
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CardGameCollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        cell.itemLabel.textAlignment = .Center
        cell.itemLabel.text = data.backOfCards
        cell.itemLabel.adjustsFontSizeToFitWidth = true
        return cell
        
    }
    
    //MARK: Keep track of orientation and invalidate layout
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewOutlet.collectionViewLayout.invalidateLayout()
        coordinator.animateAlongsideTransition(nil) { (context) -> Void in
        }
    }
    
    
    //MARK: Flip cards on touch, keep open if matched or flip again if doesn't match
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionViewOutlet.cellForItemAtIndexPath(indexPath) as! CardGameCollectionViewCell
        //If card back is showing
        if(cell.itemLabel.text == self.data.backOfCards){
            data.saveChosenCards(data.displayCards[indexPath.row], index: indexPath.row, indexP: indexPath)
            if (!twoCardsChosen){
                data.showCards(self.collectionViewOutlet.cellForItemAtIndexPath(indexPath) as! CardGameCollectionViewCell, index: indexPath.row)
            }
            twoCardsChosen =  data.checkForMatch(data.chosenCardsArray)
            if (twoCardsChosen){
                //If cards don't match
                if (!(data.cardMatch(data.chosenCardsArray))){
                    data.runNoMatchFlip(self.collectionViewOutlet.cellForItemAtIndexPath(data.chosenIndexPath[0]) as! CardGameCollectionViewCell, cell2: self.collectionViewOutlet.cellForItemAtIndexPath(data.chosenIndexPath[1]) as! CardGameCollectionViewCell)
                    twoCardsChosen = false
                }
                twoCardsChosen = false
                if(data.allCardsMatched(gameOptions.numberOfCardsInGrid)){
                    data.stopTimer()
                    data.alertShowTimer(collectionViewOutlet)
                }
            }
        }
    }
    
    
    //MARK: Size of the collection view cells
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (UIApplication.sharedApplication().statusBarOrientation.isLandscape){
                if (gameOptions.fourCardsSelected){
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad){
                        let picDimensionWidth = (self.view.frame.size.width - 40)/2
                        let picDimensionHeight = (self.view.frame.size.height - 140) / 2
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
                    else{
                        let picDimensionWidth = (self.view.frame.size.width - 40)/2
                        let picDimensionHeight = (self.view.frame.size.height - 100)/2
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
                }
            
            else if (gameOptions.sixteenCardsSelected){
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad){
                        let picDimensionWidth = (self.view.frame.size.width - 80)/4
                        let picDimensionHeight = (self.view.frame.size.height - 160) / 4
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
                    else{
                        let picDimensionWidth = (self.view.frame.size.width - 80 )/4
                        let picDimensionHeight = (self.view.frame.size.height - 100)/4
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
            }
            
            else{
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad){
                        let picDimensionWidth = (self.view.frame.size.width - 60)/6
                        let picDimensionHeight = (self.view.frame.size.height - 170) / 6
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
                    else{
                        let picDimensionWidth = (self.view.frame.size.width - 60)/6
                        let picDimensionHeight = (self.view.frame.size.height - 110) / 6
                        return CGSizeMake(picDimensionWidth, picDimensionHeight)
                    }
            }
        }
        
            if (gameOptions.fourCardsSelected){
                let picDimensionWidth = (self.view.frame.size.width-40 )/2
                let picDimensionHeight = (self.view.frame.size.height - 175)/2
                return CGSizeMake(picDimensionWidth, picDimensionHeight)
            }
            else if (gameOptions.sixteenCardsSelected){
                let picDimensionWidth = (self.view.frame.size.width - 80)/4
                let picDimensionHeight = (self.view.frame.size.height - 180)/4
                return CGSizeMake(picDimensionWidth, picDimensionHeight)
            }
                
            else{
                let picDimensionWidth = (self.view.frame.size.width - 80 )/6
                let picDimensionHeight = (self.view.frame.size.height - 190 ) / 6
                return CGSizeMake(picDimensionWidth, picDimensionHeight)
            }
    
    }
    
    
    //MARK: Collection view layout insets
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        if (UIApplication.sharedApplication().statusBarOrientation.isLandscape){
            if (gameOptions.fourCardsSelected){
                return UIEdgeInsetsMake(10, 10, 0, 10)
            }
            
            else if (gameOptions.sixteenCardsSelected){
                return UIEdgeInsetsMake(10, 10, 0, 10)
            }
            
           else{
                return UIEdgeInsetsMake(10, 5, 0, 5)
            }

        }

        if (gameOptions.fourCardsSelected){
            return UIEdgeInsetsMake(10, 10, 0, 10)
        }
        
        else if (gameOptions.sixteenCardsSelected){
            return UIEdgeInsetsMake(10, 10, 20, 10)
        }
        
        else{
            return UIEdgeInsetsMake(10, 10, 0, 10)
        }
        

    }
    
    //MARK: If user chose cancel in the alert
    func userChoseCancel() {
        performSegueWithIdentifier("playToStart", sender: self)
        
    }
    
    //MARK: Timer data
    func timerDataUpdate(timerData: [String : Int]) {
        if let timerMinutes: Int = timerData["timerMinutes"]{
            let minutesDisplay = String (format: "%02d", timerMinutes)
            let timerSeconds: Int = timerData["timerSeconds"]!
            let secondsDisplay = String (format: "%02d",timerSeconds)
            self.timerLabel.text =  "\(minutesDisplay):\(secondsDisplay)"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "playToStart"){
            let to: StartViewController = segue.destinationViewController as! StartViewController
            to.myGameOptions = gameOptions
            to.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        data.stopTimer()
    }


}

