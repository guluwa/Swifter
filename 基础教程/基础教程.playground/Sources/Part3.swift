import Foundation

/**
 * 集合类型
 * https://www.yuque.com/mingtianhuijia/ockuv1/py7y7z
 */

public struct SearchHistory: Hashable, Comparable {
    var index: Int
    public var keyword: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(keyword)
    }
    
    public init(index: Int, keyword: String) {
        self.index = index
        self.keyword = keyword
    }
    
    public static func < (lhs: SearchHistory, rhs: SearchHistory) -> Bool {
        return lhs.index < rhs.index
    }
}

public extension Array {
    
    var isNotEmpty: Bool {
        get {
            return !self.isEmpty
        }
    }
    
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < self.count else { return nil }
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    subscript<R>(safe range: R) -> ArraySlice<Element>? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
              let lowerIndex = self.index(self.startIndex, offsetBy: range.lowerBound, limitedBy: self.endIndex),
              let upperIndex = self.index(self.startIndex, offsetBy: range.upperBound, limitedBy: self.endIndex) else {
            return nil
        }
        return self[lowerIndex..<upperIndex]
    }
}

