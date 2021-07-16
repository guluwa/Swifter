//
//  main.swift
//  Swifter
//
//  Created by 杨俊康 on 2021/6/9.
//

import Foundation

print("Hello, World!")

@propertyWrapper
struct TwolveOrLess {
    private var value = 0
    var projectedValue = true
    var wrappedValue: Int {
        get { value }
        set { value = min(newValue, 12) }
    }
}

struct Person {
    @TwolveOrLess var age: Int
}

var person = Person()
person.age = 100
print(person.$age)

struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            print("didSet \(currentLevel)")
            if currentLevel > AudioChannel.thresholdLevel {
                // 将当前音量限制在阈值之内
                currentLevel = AudioChannel.thresholdLevel
            }
            print("channel: \(currentLevel)")
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // 存储当前音量作为新的最大输入音量
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var channel = AudioChannel()
channel.currentLevel = 1
channel.currentLevel = 11
