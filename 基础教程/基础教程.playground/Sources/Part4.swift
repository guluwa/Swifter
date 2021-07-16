import Foundation

/**
 * 函数、闭包
 * https://www.yuque.com/mingtianhuijia/ockuv1/nuxpw9
 */

func backward(_ s1: Int, _ s2: Int) -> Bool {
    return s1 > s2
}

// 排序
public func order() {
    let numbers = [10, 20, 30, 40, 50, 60, 70]
    // 用函数作为参数
    // let temp = numbers.sorted(by: backward)
    
    // 内联闭包
    // let temp = numbers.sorted(by: { (_ s1: Int, _ s2: Int) -> Bool in return s1 > s2 })
    
    // 根据上下文推断类型（参数、返回值）
    // let temp = numbers.sorted { s1, s2 in return s1 > s2 }
    
    // 单表达式闭包的隐式返回
    // let temp = numbers.sorted { s1, s2 in s1 > s2 }
    
    // 参数名称缩写
    // let temp = numbers.sorted(by: { $0 > $1 })
    
    // 运算符方法
    // let temp = numbers.sorted(by: >)
    
    // 尾随闭包
    let temp = numbers.sorted { $0 > $1 }
    print(temp)
}
