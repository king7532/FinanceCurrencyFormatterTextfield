//
//  ViewController2.swift
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/23/15.
//  Copyright © 2015 Benjamin King. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userEnteredText: UILabel!
    @IBOutlet weak var formattedText: UILabel!
    
    let formatter = FinanceCurrencyFormatter()
    lazy var charSet :NSCharacterSet = {
        var charSet = NSCharacterSet.decimalDigitCharacterSet().mutableCopy()
        //charSet.addCharactersInString("+*#,")
        return charSet as! NSCharacterSet
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func textFieldUpdate(textField: UITextField) {
        //print("textFieldUpdate")
        userEnteredText.text = textField.text
        
        guard let text = textField.text where !text.isEmpty else {
            return
        }
        
        let thisformattedText = formatter.stringFromString(text)
        self.formattedText.text = thisformattedText
        
        let (left, right) = countDigitsFromCursor(textField)
        print("left: \(left)\tright: \(right)\t\ttext: \(text)")
        
        textField.text = thisformattedText
        
        //setCursor(textField, withDigitsFromRight: right)
    }
    
    @IBAction func endEditing(sender: AnyObject) {
        view.endEditing(false)
    }

    func countDigitsRighterThatCursor(textField: UITextField) -> Int {
        let cursorPos = textField.selectedTextRange?.start
        var digits = -1
        var index = 0
        
        for ch in textField.text!.unicodeScalars {
            if digits == -1 && cursorPos == textField.positionFromPosition(textField.beginningOfDocument, offset: index) {
                digits = 0
            }
            if digits >= 0 && charSet.longCharacterIsMember(ch.value) {
                digits++
            }
            index++;
        }
        
        return digits
    }
    
    func countDigitsFromCursor(textField: UITextField) -> (Int, Int) {
        let cursorPos = textField.selectedTextRange?.start
        var rightDigits = -1
        var leftDigits = -1
        
        var rightindex = 0
        var leftindex = 0
        
        for ch in textField.text!.unicodeScalars {
            if rightDigits == -1 && cursorPos == textField.positionFromPosition(textField.beginningOfDocument, offset: rightindex) {
                rightDigits = 0
            }
            if rightDigits >= 0 && charSet.longCharacterIsMember(ch.value) {
                rightDigits++
            }
            rightindex++;
        }
        
        for ch in textField.text!.unicodeScalars.reverse() {
            if leftDigits == -1 && cursorPos == textField.positionFromPosition(textField.endOfDocument, offset: -1*leftindex) {
                leftDigits = 0
            }
            if leftDigits >= 0 && charSet.longCharacterIsMember(ch.value) {
                leftDigits++;
            }
            leftindex++;
        }
        
        return (leftDigits, rightDigits)
    }
    
    
    
    func setCursor(textField: UITextField, withDigitsFromLeft digits: Int) {
        //let length = textField.text!.characters.count
        var index = 0
        var digitsSkipped = 0
        
        for ch in textField.text!.unicodeScalars {
            if digitsSkipped == digits {
                let pos = textField.positionFromPosition(textField.beginningOfDocument, offset: index)!
                textField.selectedTextRange = textField.textRangeFromPosition(pos, toPosition: pos)
                return
            }
            if charSet.longCharacterIsMember(ch.value) {
                digitsSkipped++
            }
            index++
        }
    }
    
    func setCursor(textField: UITextField, withDigitsFromRight digits: Int) {
        //let length = textField.text!.characters.count
        var index = 0
        var digitsSkipped = 0
        
        for ch in textField.text!.unicodeScalars.reverse() {
            if digitsSkipped == digits {
                let pos = textField.positionFromPosition(textField.endOfDocument, inDirection: .Left, offset: index)!
                textField.selectedTextRange = textField.textRangeFromPosition(pos, toPosition: pos)
                return
            }
            if charSet.longCharacterIsMember(ch.value) {
                digitsSkipped++
            }
            index++
        }
    }
}

extension ViewController2: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = formatter.stringFromNumber(0)
    }
    
    /*
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersInRange")
        return true
    }
    */
}
