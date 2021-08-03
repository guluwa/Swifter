import Foundation

/**
 * 范型
 * https://www.yuque.com/mingtianhuijia/ockuv1/ohzga7
 */

func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

struct Stack<Element>: Container {
    var items: [Element] = []
    // 入栈
    mutating func push(_ item: Element) {
        self.items.append(item)
    }
    // 出栈
    mutating func pop() -> Element {
        self.items.removeLast()
    }
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int { self.items.count }
    subscript(i: Int) -> Element { self.items[i] }
}

// 泛型扩展
extension Stack {
    var topItem: Element? { self.items.last }
}

// 类型约束
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, item) in array.enumerated() {
        if item == valueToFind {
            return index
        }
    }
    return nil
}

// 关联类型
protocol Container {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
//    associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
//    func makeIterator() -> Iterator
}

protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

extension Stack: SuffixableContainer {
    func suffix(_ size: Int) -> Stack {
        var result = Stack()
        for index in (count - size) ..< count {
            result.append(self[index])
        }
        return result
    }
}

// C1 必须符合 Container 协议（写作 C1: Container）。
// C2 必须符合 Container 协议（写作 C2: Container）。
// C1 的 Item 必须和 C2 的 Item 类型相同（写作 C1.Item == C2.Item）。
// C1 的 Item 必须符合 Equatable 协议（写作 C1.Item: Equatable）。
func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    if someContainer.count != anotherContainer.count {
        return false
    }
    for index in 0 ..< someContainer.count {
        if someContainer[index] != anotherContainer[index] {
            return false
        }
    }
    return true
}

// 具有泛型 Where 子句的扩展
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

//extension Container where Item: Equatable {
//    func startWith(_ item: Item) -> Bool {
//        return count >= 1 && self[0] == item
//    }
//}

//extension Container where Item == Double {
//    func average() -> Double {
//        var sum = 0.0
//        for index in 0 ..< count {
//            sum += self[index]
//        }
//        return sum / Double(count)
//    }
//}

// 包含上下文关系的 where 分句
extension Container {
    func average() -> Double where Item == Int {
        var sum = 0.0
        for index in 0 ..< count {
            sum += Double(self[index])
        }
        return sum / Double(count)
    }
    func endWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count - 1] == item
    }
}

protocol ComparableContainer: Container where Item: Comparable { }

extension Container {
    subscript<Indices: Sequence>(indices: Indices) -> [Item] where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
