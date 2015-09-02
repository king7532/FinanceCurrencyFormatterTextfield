//: Playground - noun: a place where people can play

import UIKit



var d = NSDecimalNumber(string: "abc")
var g = NSDecimalNumber(string: "-1.23")

g == NSDecimalNumber.notANumber()


var formatter = NSNumberFormatter()
formatter.numberStyle = .CurrencyStyle
formatter.generatesDecimalNumbers = true

formatter.numberFromString("$1,923.45")?.stringValue

let scanner = NSScanner(string: "123.45")
//if !scanner.scanInt(nil) || !scanner.atEnd {
//    println(
//}

var decFormatter = NSNumberFormatter()
decFormatter.numberStyle = .DecimalStyle
decFormatter.minimumFractionDigits = 0
decFormatter.maximumFractionDigits = 0
decFormatter.numberFromString("123.45")
/*
let vowels = "eaoiu"
let isConsonant = { !contains(vowels, $0) }
let s = "hello, i must be going"
// filtered will be an array
let filtered = filter(s, isConsonant)
// and then we have to turn it back into a string
let only_consonants = String(filtered)
// only_consonants is "hll,  mst b gng"
*/
let str2 = "$1,23.45"
let components = str2.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).filter({!isEmpty($0)})
join("", components)

//let v = String(filter(str2) { $0 != "." })

let w = String(filter(str2, { !contains(formatter.decimalSeparator!, $0) }))

//let str3 = "1 234.56 €"
let str3 = "$1,234.56"
count(str3)

let digits = NSCharacterSet.decimalDigitCharacterSet()
//let isADigit = digits.longCharacterIsMember(uni.value)

let unicodes = str3.unicodeScalars
var ui = unicodes.endIndex

while !digits.longCharacterIsMember(unicodes[ui].value) {
    ui = ui.predecessor()
}
ui
let stri = ui.samePositionIn(str3)!
str3[stri]

let cursor = distance(stri, str3.endIndex)


