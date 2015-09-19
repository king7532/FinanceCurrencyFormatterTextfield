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
let components = str2.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).filter({!$0.characters.isEmpty})
components.joinWithSeparator("")

//let v = String(filter(str2) { $0 != "." })

let w = String(str2.characters.filter({ !(formatter.decimalSeparator!).characters.contains($0) }))

//let str3 = "1 234.56 €"
let str3 = "$1,234.56"
str3.characters.count

let digits = NSCharacterSet.decimalDigitCharacterSet()
//let isADigit = digits.longCharacterIsMember(uni.value)

let unicodes = str3.unicodeScalars
var ui = unicodes.endIndex

while !digits.longCharacterIsMember(unicodes[ui].value) {
    ui = ui.predecessor()
}
ui
let stri = ui.samePositionIn(str3)!
str