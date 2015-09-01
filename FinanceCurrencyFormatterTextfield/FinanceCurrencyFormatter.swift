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
    }
    
    override public func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        
        if partialString.isEmpty {
            return true
        }
        
        // Only return true for digits "01234567890"
        let scanner = NSScanner(string: partialString)
        if !scanner.scanInt(nil) || !scanner.atEnd {
            return false
        }
        return true
    }
}