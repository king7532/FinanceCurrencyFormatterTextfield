//: Playground - noun: a place where people can play

import UIKit

//var formatter = FinanceCurrencyFormatter()

var cursorOffsetFromEndOfString = 0
var currencyScale = 0

var formatter :NSNumberFormatter = {
    let nf = NSNumberFormatter()
    nf.numberStyle = .CurrencyStyle
    nf.generatesDecimalNumbers = true
    currencyScale = -1 * nf.maximumFractionDigits
    return nf
}()

func stringDecimalDigits(s: String) -> String {
    return s.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
}

var str = "Hello, playground"
let a = "123"
let b = "123.4"
let c = "123.45"
let d = "$1234.56"
let e = "$ 1,234.00"
let f = "198 234,89 €"
let g = "9.876,54 €"
let h = "123abc"
let i = "123abc789"
let j = "546.00"
let k = "0.00"

let arr = [a,b,c,d,e,f,g,h,i,j,k]

arr.map { NSDecimalNumber(string: $0) }
arr.map { stringDecimalDigits($0) }

let test = NSDecimalNumber(string: "0")

formatter.stringFromNumber(0)

