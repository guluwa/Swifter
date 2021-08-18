import UIKit

var greeting = "Hello, playground"

let actor = Actor(name: "guluwa")

//test9()

intIntoString(number: 1)

func intIntoString(number: Int) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
    let string:String = formatter.string(from: NSNumber(value: number)) ?? ""
    return string
}
