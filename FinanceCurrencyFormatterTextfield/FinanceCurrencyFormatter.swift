//
//  FinanceCurrencyFormatter.swift
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/1/15.
//  Copyright (c) 2015 Benjamin King. All rights reserved.
//

import Foundation

public class FinanceCurrencyFormatter : NSNumberFormatter {
    
    private(set) var currencyScale :Int!
    private(set) var cursorOffsetFromEndOfString :Int = 0
    
    override init() {
        super.init()
        setupFormatter()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFormatter()
    }
    
    func setupFormatter() {
        numberStyle = .CurrencyStyle
        generatesDecimalNumbers = true
        self.currencyScale = -1 * maximumFractionDigits
        
        // Determine the textfield cursor offeset from the end of the string
        // Some locales put the currency symbol at the end of the string like "1 234.56 €"
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        let s = self.stringFromNumber(NSDecimalNumber.zero())!
        println(s)
        let unicodes = s.unicodeScalars
        var ui = unicodes.endIndex
        
        while !digits.longCharacterIsMember(unicodes[ui].value) {
            ui = ui.predecessor()
        }
        let si = ui.samePositionIn(s)!
        self.cursorOffsetFromEndOfString = -1*(distance(si, s.endIndex)-1)
        println("cursorOffsetFromEnd = \(self.cursorOffsetFromEndOfString)")
    }
    
    func stringDecimalDigits(s: String) -> String {
        return join("", s.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
    }
    
    override public func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        
        if partialString.isEmpty {
            return true
        }
        
        // Only return true for digits "0123456789"
        let scanner = NSScanner(string: partialString)
        if !scanner.scanInt(nil) || !scanner.atEnd {
            return false
        }
        return true
    }
}