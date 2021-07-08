import Foundation

/**
 * Covariance，Contravariance是什么？？？
 * 文档地址：https://www.yuque.com/mingtianhuijia/ockuv1/pxdrl5
 */

class Animal: NSObject {}
class Cat: Animal {}

// section1
// 正确
let animal: Animal = Cat()
// 错误
// let cat: Cat = Animal()
// ====================================================================================================

// section2
// function
func animalF() -> Animal { return Animal() }
func catF() -> Cat { return Cat() }

// closure
var animalC: () -> Animal = { return Animal() }
var catC: () -> Cat = { return Cat() }

// 正确
var animalReturn: () -> Animal = catF
// animalReturn = catC

// 错误
// var catReturns: () -> Cat = animalF
// catReturns = animalC
// ====================================================================================================

// section 3
// function
func animalFF(_ animal: Animal) -> Animal { return Animal() }
func catFF(_ cat: Cat) -> Cat { return Cat() }

// closure
var animalCC: (Animal) -> Animal = { animal in
    return animal
}
var catCC: (Cat) -> Cat = { cat in
    return cat
}

// 全部错误
// var animalGetter: (Animal) -> Animal = catFF
// animalGetter = catCC
// var catGetter: (Cat) -> Cat = animalFF
// catGetter = animalCC

// 正确
var animalGetter: (Cat) -> Animal = animalFF
// animalGetter = animalCC
// ====================================================================================================

// section 4
class Dog: Animal {}

class Person {
    func getAnimal() -> Animal { return Cat() }
    func feed(animal: Animal) {}
}
class Man: Person {
    override func getAnimal() -> Dog { return Dog() }
    override func feed(animal: Animal) {}
}
// ====================================================================================================

// section 5
func testCatAnimal(f: ((Cat) -> Animal)) { print("cat -> animal") }
func testAnimalCat(f: ((Animal) -> Cat)) { print("animal -> cat") }

func catAnimal(cat: Cat) -> Animal { return Animal();}
func catCat(cat: Cat) -> Cat { return Cat(); }
func AnimalCat(animal: Animal) -> Cat { return Cat(); }
func AnimalAnimal(animal: Animal) -> Animal { return Animal(); }

func test() {
    // 四个都正确
    testCatAnimal(f: catAnimal)
    testCatAnimal(f: catCat)
    testCatAnimal(f: AnimalCat)
    testCatAnimal(f: AnimalAnimal)

    // 错误
    // testAnimalCat(f: catAnimal)
    // 错误
    // testAnimalCat(f: catCat)
    // 正确
    testAnimalCat(f: AnimalCat)
    // 错误
    // testAnimalCat(f: AnimalAnimal)
}
