//
//  ViewController.swift
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/1/15.
//  Copyright (c) 2015 Benjamin King. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userTextLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var formatter = FinanceCurrencyFormatter()
    var userEntered :String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func endEditingAction(sender: AnyObject) {
        self.view.endEditing(false)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        println("textFieldDidBeginEditing")
        self.userEntered = nil
        self.userTextLabel.text = ""
        textField.text = self.formatter.stringFromNumber(NSDecimalNumber.zero())
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing: \(textField.text)")
        self.userTextLabel.text = textField.text
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        println("shouldChangeCharactersInRange: \(range) replacementString: \(string) (len: \(count(string)))")
        
        if !formatter.isPartialStringValid(string, newEditingString: nil, errorDescription: nil) {
            println("partial string is invalid!")
            return false
        }
        
        self.userTextLabel.text = self.userEntered
        
        // Get the cursor position
        let selectedRange :UITextRange? = textField.selectedTextRange
        let start :UITextPosition? = textField.beginningOfDocument
        let cursorOffset = textField.offsetFromPosition(start!, toPosition: selectedRange!.start)
        
        if !string.isEmpty {
            if let userStr = self.userEntered {
                self.userEntered = userStr + string
            }
            else {
                self.userEntered = string
            }
        }
        else {
            // Backspace
            if let userStr = self.userEntered where !userStr.isEmpty {
                self.userEntered = dropLast(userStr)
            }
        }
        
        self.userTextLabel.text = self.userEntered
        
        var decimal :NSDecimalNumber = NSDecimalNumber.zero()
        if let userStr = self.userEntered {
            decimal = NSDecimalNumber(string: self.userEntered)
            debugPrintln(decimal)
            
            if decimal != NSDecimalNumber.notANumber() {
                decimal = decimal.decimalNumberByMultiplyingByPowerOf10(Int16(formatter.currencyScale))
            }
            else {
                decimal = NSDecimalNumber.zero()
            }
        }

        textField.text = self.formatter.stringFromNumber(decimal)
        
        return false
    }


}
