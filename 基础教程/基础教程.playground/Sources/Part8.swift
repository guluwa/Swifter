import Foundation

/**
 * 协议
 * https://www.yuque.com/mingtianhuijia/ockuv1/kpkyk4
 */

protocol FullyNamed {
    var fullName: String { get }
    func printName(prefix: String) -> Void
}

struct PersonNamed: FullyNamed {
    var fullName: String
    func printName(prefix: String = "i am ") {
        print(prefix + fullName)
    }
}

class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    func printName(prefix: String) {
        print(prefix + fullName)
    }
}

public func test8() {
    var john = PersonNamed(fullName: "John Appleseed")
    john.printName()
    john.fullName = "john Appleseed II"
    john.printName()
    let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
    ncc1701.printName(prefix: "i am ")
    let d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
    let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
    print([d6, d12].textualDescription)
}

// =========================================
// 委托

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

// DiceGame 协议可以被任意涉及骰子的游戏遵循。
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

// DiceGameDelegate 协议可以被任意类型遵循，用来追踪 DiceGame 的游戏过程。
// 为了防止强引用导致的循环引用问题，可以把协议声明为弱引用
protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String { "A \(sides)-sided dice" }
}

// 有条件地遵循协议
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        "[" + self.map { $0.textualDescription }.joined(separator: ", ") + "]"
    }
}

public func testDiceGame() {
    let tracker = DiceGameTracker()
    let game = SnakesAndLadders()
    game.delegate = tracker
    game.play()
    print(game.prettyTextualDescription)
}

// =========================================
// 使用合成实现来采纳协议

struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
    var description: String {
        get {
            "x: \(x), y: \(y), z: \(z)"
        }
        set {
            x = 0.0
            y = 0.0
            z = 0.0
        }
    }
}

enum SkillLevel: Comparable {
    case beginner
    case intermediate
    case expert(stars: Int)
}

public func testEqualable() {
    let vector1 = Vector3D(x: 1.0, y: 1.0, z: 1.0)
    let vector2 = Vector3D(x: 1.0, y: 1.0, z: 1.0)
    print(vector1 == vector2)
    let levels = [SkillLevel.intermediate, SkillLevel.beginner,
                  SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
    for level in levels.sorted() {
        print(level)
    }
}

// =========================================
// 协议继承

extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}

// =========================================
// 协议合成

protocol Named {
    var name: String { get }
}

protocol Aged {
    var age: Int { get }
}

struct Person8: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}

func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

func testCombine() {
    let birthdayPerson = Person8(name: "Malcolm", age: 21)
    wishHappyBirthday(to: birthdayPerson)
    let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
    beginConcert(in: seattle)
}

// =========================================
// 协议扩展

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
