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
