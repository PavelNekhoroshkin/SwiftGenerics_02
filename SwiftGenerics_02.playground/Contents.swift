import UIKit

// MARK: - Задача 2

//В Playground SwiftGenerics_02 создать систему generic-типов. Типы могут быть свои либо можно использовать предложенный ниже вариант 

//Реализовать базовый протокол для контейнеров.
//Контейнеры должны отвечать, сколько они содержат элементов, добавлять новые элементы и возвращать элемент по индексу.
//На основе базового протокола реализовать универсальный связанный список и универсальную очередь (FIFO) в виде структуры или класса.

protocol Container {
    associatedtype Item
    
    func count()->Int
    func add(_ item: Item)
    func getByIndex(_ index: Int) -> Item!
}

//унмиверсальный связанный список
class LinkedList<T>:Container{
    
    
    typealias Item = T
    
    var _item : T?
    var _next : LinkedList<T>?
    
    init(_ item: T){
        self._item = item
    }
    
    //    deinit {
    //        Swift.print("Узел удален: ", terminator : "")
    //        Swift.print(self._item ?? nil)
    //    }
    
    func count()->Int{
        if self._item == nil {
            return 0 //первый узел пустой только в пустом списке
        }
        var node = self
        var count = 1
        while node._next != nil {
            node = node._next!
            count = count + 1
        }
        return count
    }
    
    func add(_ item: T){
        if self._item == nil {
            self._item = item
        }
        var node = self
        while node._next != nil {
            node = node._next!
        }
        let new = LinkedList<T>(item)
        node._next = new
    }
    
    func getByIndex(_ index: Int) -> T!{
        if index<0 {
            return nil
        }
        var count = 0
        var node = self
        while count < index {
            if node._next != nil {
                count = count + 1
                node = node._next!
            } else{
                return nil
            }
        }
        return node._item!
    }
    func removeByIndex(_ index: Int){
        var _index = index
        if index<0 {
            return
        }
        
        //если удаляем первый элемент, то его оставляем,
        //его удалять нельзя потому что он держит связь со всем списком
        //переносим в первый узел значение следующего
        //следующий узел освобождаем и убираем из списка
        var node = self._next
        if _index == 0 {
            //нет следующего узла
            if node == nil {
                self._item = nil
                return //других узлов, исправлять не нужно
            } else {
                //есть следующий узел, тогда его содержимое переносим в первый узел
                self._item = node!._item
                _index = 1 //теперь задача свелась к удалению второго узла
            }
        }
        
        //штатно удаляем нужный узел, это может быть второй или следующие
        if node == nil {
            return//второго и следующих узлов нет, удалять нечего
        }
        //отсчитываем элементы, запоминая предыдущий
        var previous = self
        
        //второй узел есть, начинаем отсчет с него (индекс 1),
        //пока не досчитаем до нужного узла,
        //или список не закончится
        while _index > 1  {
            //список еще не закончился
            if node!._next != nil {
                _index = _index - 1
                previous = node!
                node = node!._next
            } else{
                //завершить, если список закончился
                return
            }
        }
        
        //нашли нужный элемент
        //удаляем ссылку на содержимое-контейнер
        node!._item = nil
        
        if node!._next == nil {
            //если узел последний
            //удаляем ссылку на него с предыдущего значения
            previous._next = nil
            return
        } else {
            //если узел не последний
            //то ссылаемся с предыдущего узла на следующий за удаляемым
            previous._next = node!._next!
            //на всякий случай в удаляемом узле стираем ссылку на следующий
            node!._next = nil
        }
    }
    
    func print(){
        
        if self._item == nil {
            Swift.print("[nil]")
            return
        }
        
        var node = self
        
        Swift.print("[\'", terminator:  "")
        Swift.print(String(describing:node._item!), terminator : "")
        Swift.print("\'", terminator:  "")
        
        while node._next != nil {
            node = node._next!
            Swift.print((", \'" + String(describing:node._item!) + "\'"), terminator : "")
            
        }
        Swift.print("]")
        
    }
    
}



//универсальная очередь
//на основе структур нельзя создать связанный список, потому что компилятор не позволяет делать в стуктуре поле с типом самой структуры.
//видимо выполняется попытка при рассчете размера памяти, которая необходима для объекта структуры, включить в размер также  структуру из поля в расчет.
//Получается нужен расчет, где уже используется результат расчета как входной параметр, компилятор не может это вычислить
//и не дает создать поле в структуре с типом самой структуры.
//приходится в качестве узла в очереди использовать класс.

struct Queue<T>:Container{
    
    typealias Item = T
    
    class Container<T> {
        fileprivate  var _item: T?
        fileprivate  var _next : Container<T>?
        
        init(){}
        init(_ item: T) {
            self._item = item
        }
    }
    
    private var _first = Container<T>()
    
    func count()->Int{
        if _first._item == nil {
            return 0
        }
        var count = 1
        var node = _first
        while node._next != nil {
            count = count + 1
            node =  node._next!
        }
        return count
    }
    
    func add(_ item: T){
        if _first._item == nil {
            _first._item = item
            return
        }
        var node = _first
        while node._next != nil {
            node = node._next!
        }
        let new = Container<T>(item)
        node._next = new
    }
    
    func getByIndex(_ index: Int) -> T!{
        if index<0 {
            return nil
        }
        var count = 0
        var node = _first
        while count < index {
            if node._next != nil {
                count = count + 1
                node = node._next!
            } else{
                return nil
            }
        }
        return node._item!
        
    }
    
    //положить элемент в конец очереди
    func put(_ item: T){
        add(item)
    }
    func isEmpty()->Bool{
        if _first._item == nil {
            return true
        }
        return false
    }
    
    //получить элемент из начала очереди
    func get()->T?{
        let item = _first._item
        if item != nil {
            //узел не пустой
            let next = _first._next
            //он может быть единственный или нет
            if next == nil {
                //если нет следующего узла
                //очистим первый
                _first._item = nil
                //других узлов, исправлять не нужно
            } else {
                //есть следующий узел, тогда его содержимое переносим в первый узел
                _first._item = next!._item
                //теперь удаляем второй узел, на его место сдвигаем третий
                next!._item = nil
                _first._next = next?._next //третьего узла может не быть, но это не важно
            }
        } //если узел пусто, то никаких действий не требуется
        
        //вернем значение первого узла
        return  item
    }
    
    func print(){
        
        if _first._item == nil {
            Swift.print("[nil]")
            return
        }
        
        var node = _first
        
        Swift.print("[", terminator:  "")
        Swift.print("\'", terminator : "")
        Swift.print(String(describing:node._item!), terminator : "")
        Swift.print("\'", terminator : "")
        
        while node._next != nil {
            node = node._next!
            Swift.print( (", \'" + String(describing:node._item!) + "\'"), terminator : "")
        }
        Swift.print("]")
    }
}





//========================================== ТЕСТЫ ==========================================





enum EnumType :Int  {
    case ValueOne , ValueTwo, ValueThree, ValueFour, ValueFive
}

        let string = LinkedList<String>("0")
        let integer = LinkedList<Int>(0)
        let double = LinkedList<Double>(0.0)
        let enumType = LinkedList<EnumType>(EnumType.ValueOne)
        
        
        
        
        for i in 1..<5 {
            string.add(string.getByIndex(0)+String(i))
            integer.add(integer.getByIndex(0)+Int(i))
            double.add(double.getByIndex(0)+Double(i))
            enumType.add(EnumType(rawValue: i)!)
        }
        
        
        string.print()
        integer.print()
        double.print()
        enumType.print()
        
        //удалить третий элемент
        string.removeByIndex(2)
        integer.removeByIndex(2)
        double.removeByIndex(2)
        enumType.removeByIndex(2)
        
        //удалить первый элемент
        string.removeByIndex(0)
        integer.removeByIndex(0)
        double.removeByIndex(0)
        enumType.removeByIndex(0)
        
        
        
        //удалить последний элемент
        
        string.removeByIndex((string.count())-1)
        integer.removeByIndex((integer.count())-1)
        double.removeByIndex(double.count()-1)
        enumType.removeByIndex(enumType.count()-1)
        
        print(string.count())
        print(integer.count())
        print(double.count())
        print(enumType.count())
        
        string.print()
        integer.print()
        double.print()
        enumType.print()
        
        for _ in 0...2 {
            string.removeByIndex((string.count())-1)
            integer.removeByIndex((integer.count())-1)
            double.removeByIndex(double.count()-1)
            enumType.removeByIndex(enumType.count()-1)
        }
        
        print(string.count())
        print(integer.count())
        print(double.count())
        print(enumType.count())
        
        string.print()
        integer.print()
        double.print()
        enumType.print()



        print("====================================")


        let stringQueue = Queue<String>()
        let integerQueue = Queue<Int>()
        let doubleQueue = Queue<Double>()
        let enumTypeQueue = Queue<EnumType>()





for i in 0..<5 {
    stringQueue.put(String(i))
    integerQueue.put(Int(i))
    doubleQueue.put(Double(i))
    enumTypeQueue.put(EnumType(rawValue: i)!)
}


stringQueue.print()
integerQueue.print()
doubleQueue.print()
enumTypeQueue.print()



for _ in 0..<5 {
    print(stringQueue.get()!)
    print(integerQueue.get()!)
    print(doubleQueue.get()!)
    print(enumTypeQueue.get()!)
    print()
}


print("========= Пустые очереди =========")

print(stringQueue.count())
print(integerQueue.count())
print(doubleQueue.count())
print(enumTypeQueue.count())

stringQueue.print()
integerQueue.print()
doubleQueue.print()
enumTypeQueue.print()


print("====================================")







