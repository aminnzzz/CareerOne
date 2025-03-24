import UIKit

struct Stack<Element> {
    private var array = [Element]()
    var count: Int { array.count }
    var isEmpty: Bool { array.isEmpty }

    init(_ items: [Element]) {
        self.array = items
    }

    init() { }

    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }

    func peek() -> Element? {
        array.last
    }
}

extension Stack: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.array = elements
    }
}

extension Stack: CustomDebugStringConvertible {
    var debugDescription: String {
        var result = "["
        var first = true

        for item in array {
            if first {
                first = false
            } else {
                result += ", "
            }

            debugPrint(item, terminator: "", to: &result)
        }

        result += "]"
        return result
    }
}

extension Stack: Equatable where Element: Equatable { }
extension Stack: Hashable where Element: Hashable { }
extension Stack: Encodable where Element: Encodable { }
extension Stack: Decodable where Element: Decodable { }

protocol Prioritized {
    var priority: Int { get }
}

struct Work: Prioritized {
    let name: String
    let priority: Int
}


struct Queue<Element> {
    private var array = [Element]()
    var first: Element? { array.first }
    var last: Element? { array.last }

    mutating func append(_ element: Element) {
        array.append(element)
    }

    mutating func dequeue() -> Element? {
        guard array.count > 0 else { return nil }
        return array.remove(at: 0)
    }
}

extension Queue where Element: Prioritized {
    mutating func dequeue() -> Element? {
        guard array.count > 0 else { return nil }

        var choice = array[0]
        var choiceIndex = 0

        for (index, item) in array.enumerated() {
            if item.priority > choice.priority {
                choice = item
                choiceIndex = index
            }
        }

        return array.remove(at: choiceIndex)
    }
}

struct Deque<Element> {
    private var array = [Element]()
    var first: Element? { array.first }
    var last: Element? { array.last }

    mutating func prepend(_ element: Element) {
        array.insert(element, at: 0)
    }

    mutating func append(_ element: Element) {
        array.append(element)
    }

    mutating func dequeueFront() -> Element? {
        guard array.count > 0 else { return nil}
        return array.remove(at: 0)
    }

    mutating func dequeueBack() -> Element? {
        guard array.count > 0 else { return nil}
        return array.removeLast()
    }
}

extension Deque where Element: Equatable {
    func firstIndex(of element: Element) -> Int? {
        for (i, current) in array.enumerated() {
            if current == element {
                return i
            }
        }

        return nil
    }

    @inlinable
    func contains(_ element: Element) -> Bool {
        array.contains(element)
    }
}

@resultBuilder
struct NodeBuilder {
    static func buildBlock<Value>(_ children: Node<Value>...) -> [Node<Value>] {
        children
    }
}

struct Node<Value> {
    var value: Value
    private(set) var children: [Node]

    var count: Int {
        1 + children.reduce(0) { $0 + $1.count }
    }

    init(_ value: Value) {
        self.value = value
        children = []
    }

    init(_ value: Value, children: [Node]) {
        self.value = value
        self.children = children
    }

    init(_ value: Value, @NodeBuilder builder: () -> [Node]) {
        self.value = value
        self.children = builder()
    }

    mutating func add(child: Node) {
        children.append(child)
    }
}

extension Node: Equatable where Value: Equatable { }
extension Node: Hashable where Value: Hashable { }
extension Node: Codable where Value: Codable { }

extension Node where Value: Equatable {
    func find(_ value: Value) -> Node? {
        if self.value == value {
            return self
        }

        for child in children {
            if let match = child.find(value) {
                return match
            }
        }

        return nil
    }
}
