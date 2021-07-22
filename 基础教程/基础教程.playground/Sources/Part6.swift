import Foundation

/**
 * 构造过程、析构过程
 * https://www.yuque.com/mingtianhuijia/ockuv1/xgxfh8
 */

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    
    // 自定义构造器 无法访问默认构造器和逐一成员构造器
    //    init(center: Point, size: Size) {
    //        let originX = center.x - (size.width / 2)
    //        let originY = center.y - (size.height / 2)
    //        self.init(origin: Point(x: originX, y: originY), size: size)
    //    }
}

extension Rect {
    // 将自定义构造器定义在扩展中 可以访问默认构造起和逐一成员构造器
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

public func test6() {
    let breakfastList = [
        ShoppingListItem(),
        ShoppingListItem(name: "Bacon"),
        ShoppingListItem(name: "Eggs", quantity: 6),
    ]
    breakfastList[0].name = "Orange juice"
    breakfastList[0].purchased = true
    for item in breakfastList {
        print(item.description)
    }
}

// 指定构造器和便利构造器实践
class Food {
    var name: String
    // 指定构造器
    init(name: String) {
        self.name = name
    }
    // 便利构造器
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    // 指定构造器
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    // 将父类的指定构造器重写为便利构造器
    // 但是它依然提供了父类的所有指定构造器的实现。
    // 所以RecipeIngredient会继承Food类所有的便利构造器
    convenience override init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

// 可失败构造器
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

// 析构器实践
class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        self.coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}

public func testDeinit() {
    var playerOne: Player? = Player(coins: 100)
    print("A new player has joined the game with \(playerOne!.coinsInPurse) coins")
    print("The bank now has \(Bank.coinsInBank) coins")
    playerOne?.win(coins: 2_000)
    print("PlayerOne won 2000 coins & now has \(playerOne!.coinsInPurse) coins")
    print("The bank now has \(Bank.coinsInBank) coins")
    playerOne = nil
    print("PlayerOne has left the game")
    print("The bank now has \(Bank.coinsInBank) coins")
}
