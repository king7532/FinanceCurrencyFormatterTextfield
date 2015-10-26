//
//  FinanceCurrencyTextField.swift
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 10/26/15.
//  Copyright © 2015 Benjamin King. All rights reserved.
//

import UIKit

class FinanceCurrencyTextField: UITextField {

    let formatter = FinanceCurrencyFormatter()
    let charSet :NSCharacterSet = {
        let charSet = NSCharacterSet.decimalDigitCharacterSet().mutableCopy()
        return charSet as! NSCharacterSet
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        delegate = self
        self.addTarget(self, action: "textFieldDidUpdate:", forControlEvents: .EditingChanged)

    }

    func setCursor(withDigitsFromRight digits: Int, minOffsetFromEnd: Int = 0) {
        var index = 0
        var digitsSkipped = 0
        
        guard digits > 0 else {
            let pos = positionFromPosition(endOfDocument, offset: -1*abs(minOffsetFromEnd))!
            selectedTextRange = textRangeFromPosition(pos, toPosition: pos)
            return
        }
        
        let length = text!.characters.count
        let unicodes = text!.unicodeScalars.reverse()
        //print("setCursor: \(unicodes)")
        for ch in unicodes {
            //print("\tch: \(ch)\tindex: \(index)")
            if digitsSkipped == digits && (charSet.longCharacterIsMember(ch.value) || index == length-1) {
                if index < minOffsetFromEnd {
                    index = minOffsetFromEnd
                }
                let pos = positionFromPosition(endOfDocument, inDirection: .Left, offset: index)!
                //print("\toffset from end: \(index)")
                selectedTextRange = textRangeFromPosition(pos, toPosition: pos)
                return
            }
            if charSet.longCharacterIsMember(ch.value) {
                digitsSkipped++
            }
            index++
        }
    }
    
    func countDigitsFromCursor(textField: UITextField) -> (Int, Int) {
        let cursorPos = textField.selectedTextRange?.start
        var rightDigits = -1
        var leftDigits = -1
        
        var rightindex = 0
        var leftindex = 0
        
        let unicodes = textField.text!.unicodeScalars
        for ch in unicodes {
            if rightDigits == -1 && cursorPos == textField.positionFromPosition(textField.beginningOfDocument, offset: rightindex) {
                rightDigits = 0
            }
            if rightDigits >= 0 && charSet.longCharacterIsMember(ch.value) {
                rightDigits++
            }
            rightindex++;
        }
        
        for ch in unicodes.reverse() {
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
    
    func textFieldDidUpdate(textField: UITextField) {
        guard let str = textField.text where !str.isEmpty else {
            return
        }
        
        if let thisformattedText = formatter.stringFromString(str) {
            textField.text = thisformattedText
        }
        else {
            textField.text = formatter.stringFromNumber(0)
        }
        let (_, right) = countDigitsFromCursor(textField)
        
        setCursor(withDigitsFromRight: right, minOffsetFromEnd: -1*formatter.cursorOffsetFromEndOfString)
    }

}

extension FinanceCurrencyTextField: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if text == nil {
            text = formatter.stringFromNumber(0)
        }
        else if let str = text where str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString.isEmpty {
            text = formatter.stringFromNumber(0)
        }
        
        let cursor = positionFromPosition(endOfDocument, offset: formatter.cursorOffsetFromEndOfString)!
        selectedTextRange = textRangeFromPosition(cursor, toPosition: cursor)

    }
}