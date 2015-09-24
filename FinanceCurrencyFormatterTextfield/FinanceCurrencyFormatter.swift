//
//  FinanceCurrencyFormatter.swift
//  FinanceCurrencyFormatterTextfield
//
//  Created by Benjamin King on 9/1/15.
//  Copyright (c) 2015 Benjamin King. All rights reserved.
//

import Foundation

public class FinanceCurrencyFormatter : NSNumberFormatter {

    static let NumberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.generatesDecimalNumbers = true
        return nf
    }()
    
    private(set) var currencyScale :Int!
    private(set) var cursorOffsetFromEndOfString :Int = 0
    
    override init() {
        super.init()
        setupFormatter()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFormatter()
    }

    func setupFormatter() {
        numberStyle = .CurrencyStyle
        generatesDecimalNumbers = true
        currencyScale = -1 * maximumFractionDigits
        
        // Determine the textfield cursor offeset from the end of the string
        // Some locales put the currency symbol at the end of the string like "1 234.56 €"
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        let s = stringFromNumber(NSDecimalNumber.zero())!

        let unicodes = s.unicodeScalars
        var ui = unicodes.endIndex
        
        while !digits.longCharacterIsMember(unicodes[ui].value) {
            ui = ui.predecessor()
        }
        let si = ui.samePositionIn(s)!
        cursorOffsetFromEndOfString = -1*(si.distanceTo(s.endIndex)-1)
    }
    
    func stringDecimalDigits(s: String) -> String {
        return s.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
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
    
    func stringFromString(string: String?) -> String? {
        guard let s = string else {
            return nil
        }

        let digits = self.stringDecimalDigits(s)
        if digits.isEmpty { return nil }

        var number = NSDecimalNumber(string: digits)
        if number == NSDecimalNumber.notANumber() {
            if let n = FinanceCurrencyFormatter.NumberFormatter.numberFromString(digits) as? NSDecimalNumber {
                number = n
            }
            else {
                number = NSDecimalNumber.zero()
            }
        }
        number = number.decimalNumberByMultiplyingByPowerOf10(Int16(currencyScale))
        return stringFromNumber(number)
    }
}