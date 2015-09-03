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
        
        let initialCursorPostion = textField.positionFromPosition(textField.endOfDocument, offset: formatter.cursorOffsetFromEndOfString)
        textField.selectedTextRange = textField.textRangeFromPosition(initialCursorPostion, toPosition: initialCursorPostion)
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
        let cursorOffset = textField.offsetFromPosition(textField.endOfDocument, toPosition: selectedRange!.start)
        
        println("\tselectedRange: \(selectedRange!)\n\tcursorOffset: \(cursorOffset)")
        
        if !string.isEmpty {
            // If the user moved the text insertion cursor
            if cursorOffset != formatter.cursorOffsetFromEndOfString {
                let fullText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                userEntered = formatter.stringDecimalDigits(fullText)
                println(self.userEntered)
            }
            else if let userStr = self.userEntered {
                self.userEntered = userStr + string
            }
            else {
                userEntered = string
            }
        }
        else {
            // Backspace
            if let userStr = self.userEntered where !userStr.isEmpty {
                if cursorOffset != formatter.cursorOffsetFromEndOfString {
                    let fullText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
                    userEntered = formatter.stringDecimalDigits(fullText)
                }
                else {
                    userEntered = dropLast(userStr)
                }
            }
        }
        
        self.userTextLabel.text = userEntered
        
        var decimal = NSDecimalNumber.zero()
        if let userStr = self.userEntered {
            decimal = NSDecimalNumber(string: userEntered)
            
            if decimal != NSDecimalNumber.notANumber() {
                decimal = decimal.decimalNumberByMultiplyingByPowerOf10(Int16(formatter.currencyScale))
            }
            else {
                decimal = NSDecimalNumber.zero()
            }
        }

        textField.text = formatter.stringFromNumber(decimal)
        
        // Restore the cursor position if it was moved, or go back to the end of the currency
        if cursorOffset != formatter.cursorOffsetFromEndOfString {
            var newCursor :UITextPosition?
            if formatter.cursorOffsetFromEndOfString < 0 && cursorOffset > formatter.cursorOffsetFromEndOfString {
                newCursor = textField.positionFromPosition(textField.endOfDocument, offset: formatter.cursorOffsetFromEndOfString)
            }
            else {
                newCursor = textField.positionFromPosition(textField.endOfDocument, offset: cursorOffset)
            }
            
            textField.selectedTextRange = textField.textRangeFromPosition(newCursor!, toPosition: newCursor!)
        }
        else {
            let cursorPosition = textField.positionFromPosition(textField.endOfDocument, offset: formatter.cursorOffsetFromEndOfString)
            textField.selectedTextRange = textField.textRangeFromPosition(cursorPosition, toPosition: cursorPosition)
        }
        
        return false
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
