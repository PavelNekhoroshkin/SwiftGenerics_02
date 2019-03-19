import UIKit

//“Реализовать базовый протокол для контейнеров. Контейнеры должны отвечать, сколько они содержат элементов, добавлять новые элементы и возвращать элемент по индексу. На основе базового протокола реализовать универсальный связанный список и универсальную очередь (FIFO) в виде структуры или класса. ”


protocol MyProtocol {
    associatedtype Item
    
    func protocolMethod(y: Item)
}

struct MyStruct {
    
    var x: Int = 1
    
    func method1() {
        print("method1")
    }
    
    func method2(){
        print("method2")
    }
}

extension MyStruct: MyProtocol {
    typealias Item = Int
    
    func protocolMethod(y: Item) {
        print(self.x + y)
    }
}

class MyClass: MyProtocol {
    typealias Item = Int
    
    var x: Int = 2
    
    func newMethod1(){
        print("newMethod1")
    }
    
    func newMethod2(){
        print("newMethod2")
    }
    
    func protocolMethod(y: Item){
        print(self.x + y)
    }
}

class AnyMyProtocol<T>: MyProtocol{
    //что-то что поддреживает
    init<U: MyProtocol>(_ p: U ) where U.Item == T  {
        _protocolMethod = p.protocolMethod
    }
    
    var _protocolMethod: (_ y : T)->Void
    
    func protocolMethod(y: T){
        return _protocolMethod(y)
    }
    
    
}


let a = [AnyMyProtocol(MyClass()), AnyMyProtocol(MyStruct())]
print(a)

for i in a {
    i._protocolMethod(10)
}


