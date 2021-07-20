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
    let _ = Rect()
}
