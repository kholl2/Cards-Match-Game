//
//  OptionsViewController.swift
//  Proj2
//
//  Created by Kruthika Holla on 10/11/15.
//  Copyright © 2015 Kruthika Holla. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var optionPicker: UIPickerView!
    
    var gameOptions = Options()
    let optModel = OptionModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Set the option picker to the user choice always
        if(gameOptions.fourCardsSelected){
            optionPicker.selectRow(0, inComponent: 0, animated: false)
        }
        
        if(gameOptions.sixteenCardsSelected){
            optionPicker.selectRow(1, inComponent: 0, animated: false)
        }
        
        if(gameOptions.thirtySixCardsSelected){
            optionPicker.selectRow(2, inComponent: 0, animated: false)
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return optModel.optionArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optModel.optionArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = optModel.optionArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        return pickerLabel
    }

    
    //MARK: Select button pressed
    @IBAction func playButton(sender: AnyObject) {
        let selectedRow =  optionPicker.selectedRowInComponent(0)
        if (selectedRow == 0){
            gameOptions.fourCardsSelected = true
            gameOptions.sixteenCardsSelected = false
            gameOptions.thirtySixCardsSelected = false
        }
        if (selectedRow == 1){
            gameOptions.sixteenCardsSelected = true
            gameOptions.thirtySixCardsSelected = false
            gameOptions.fourCardsSelected = false
        }
        if (selectedRow == 2){
            gameOptions.thirtySixCardsSelected = true
            gameOptions.fourCardsSelected = false
            gameOptions.sixteenCardsSelected = false
        }
        gameOptions.saveData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "Optionplay"){
            let to: StartViewController = segue.destinationViewController as! StartViewController
            to.myGameOptions = gameOptions
            to.navigationItem.setHidesBackButton(true, animated: true)
        }
    }


}
