import UIKit

var greeting = "Hello, playground"

let actor = Actor(name: "guluwa")

enum CompassPoint: CaseIterable {
    case north
    case south
    case east
    case west
}

for item in CompassPoint.allCases {
    print(item)
}
