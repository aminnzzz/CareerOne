import UIKit

// Initializers

var repeatingArray = Array(repeating: Array(repeating: "+", count: 10), count: 10)

let i = 42
let s1 = "\(i)"
let s2 = String(i)

print(s1)
print(s2)

let s3 = String(1996, radix: 16, uppercase: true)
let i3 = Int("7cc", radix: 16)

let scores = [5,3,7,2,4,7,8,3,3,2]
let uniqueScores = Set(scores).description // unordered

var dict = Dictionary<String, Int>(minimumCapacity: 100)

// Strings

let s4 = #"Hello, world!"#
// can be used instead of the following to avoid escaping
let s5 = #"  {"name": "John", "message": "Hello!"}"  \"#
// to not escape every character
let s6 = "{\"name\": \"John\", \"message\": \"Hello!\"}"

func generateBigString() -> Substring {
    let input = String(repeating: UUID().uuidString, count: 10_000_000)
    let endPosition = input.index(input.startIndex, offsetBy: 100)
    return input[...endPosition]
}

func runTest() {
    let substring = generateBigString()
    print(substring)
}

print("Start: Remains in memory")
runTest()
print("Done")

func runTest2() {
    let substring = String(generateBigString())
    print(substring)
}

print("Start: Does not remain in memory")
runTest()
print("So convert to string if you don't want it to remain in memory")

// Enums


enum Weather: CaseIterable {
    case rainy, snowy, sunny, windy
}

for condition in Weather.allCases {
    print(condition)
}

enum Weather1: CaseIterable {
    case rainy, snowy(isHeavy: Bool), sunny, windy

    static var allCases: [Weather1] {
        [.rainy, .snowy(isHeavy: false), .snowy(isHeavy: true), .sunny, .windy]
    }
}

enum Size1: Comparable {
    case extraSmall, small, medium, large, extraLarge
}

print(Size1.extraSmall < Size1.extraLarge)

enum Size2: Comparable {
    case extraSmall, small, medium, large, extraLarge, other(name: String)
}

let baby = Size2.other(name: "Baby")


print(baby > Size2.extraLarge)

enum SpendingType1: Identifiable {
    case food, home, leisure, travel

    var id: SpendingType1 {
        self
    }
}

enum SpendingType2: Identifiable {
    case food, home, leisure, travel

    var id: Self {
        self
    }
}

// will not work because associated values (like 'other(name: String)') make the enum non-equatable by default.
// The Identifiable protocol requires that 'id' be Hashable, and since the enum case contains a String,
// Swift cannot automatically synthesize Equatable conformance. Use Hashable protocol instead as shown in SpendingType4.
//enum SpendingType3: Identifiable {
//    case food, home, leisure, travel, other(name: String)
//
//    var id: SpendingType3 {
//        self
//    }
//}

enum SpendingType4: Hashable {
    case food, home, leisure, travel, other(name: String)

    var id: SpendingType4 {
        self
    }
}

// Dictionaries

let cities = ["Shanghai": 24_256_800, "Karachi": 23_500_000, "Beijing": 21_516_000, "Seoul": 9_995_000]
let roundedCities = cities.mapValues { "\($0 / 1_000_000) million people" }

let groupedCities = Dictionary(grouping: cities.keys) { $0.first! }
print(groupedCities)

var favoriteTVShows = ["Red Dwarf", "Blackadder", "Fawlty Towers", "Red Dwarf"]
var favoriteCounts = [String: Int]()

for show in favoriteTVShows {
    favoriteCounts[show, default: 0] += 1
}

// tuples, ranges, range set

let characters = ["Dr Horrible", "Captain Hammer", "Penny", "Bad Horse", "Moist"]
let bigParts = characters[..<3]
let smallParts = characters[3...]
print(bigParts)
print(smallParts)

let characters2 = ["Dr Horrible", "Captain Hammer", "Penny", "Bad Horse", "Moist"]
let smallParts2 = 3...
let bounded = smallParts2.relative(to: characters2)
print(bounded.upperBound)

struct ExamResult {
    var student: String
    var score: Int
}

let results = [
    ExamResult(student: "Eric Effiong", score: 95),
    ExamResult(student: "Maeve Wiley", score: 70),
    ExamResult(student: "Otis Milburn", score: 100)
]

let topResults = results.indices { student in
    student.score >= 85
}
// DiscontiguousSlice
for result in results[topResults] {
    print("\(result.student) scored \(result.score)%")
}

let earlyAlphabet = "A"..."E"
let next24Hours = Date.now...Date.now.addingTimeInterval(86400)

let uppercaseRange = "A"...
let lowercaseRange = "a"...
print(uppercaseRange.contains("A"))
print(uppercaseRange.contains("a"))
print(lowercaseRange.contains("A"))
print(lowercaseRange.contains("a"))

// pattern matching

let twostraws = (name: "twostraws", password: "fr0st1es")
let bilbo = (name: "bilbo", password: "bagg1n5")
let taylor = (name: "taylor", password: "fr0st1es")

let users = [twostraws, bilbo, taylor]

for case ("twostraws", "fr0st1es") in users {
    print("User twostraws has the password fr0st1es")
}

for case (let name, let password) in users {
    print("User \(name) has the password \(password)")
}

for case let (name, password) in users {
    print("User \(name) has the password \(password)")
}

for case let (name, "fr0st1es") in users {
    print("User \(name) has the password \"fr0st1es\"")
}


let name: String? = "twostraws"
let password: String? = "fr0st1es"

switch (name, password) {
case let (name?, password?):
    print("Hello, \(name)")
case let (name?, nil):
    print("Please enter a password.")
default:
    print("Who are you?")
}

enum WeatherType {
    case cloudy(coverage: Int)
    case sunny
    case windy
}

let today = WeatherType.cloudy(coverage: 100)

switch today {
case .cloudy(let coverage) where coverage == 0:
    print("You must live in Death Valley")
case .cloudy(let coverage) where (1...50).contains(coverage):
    print("It's a bit cloudy, with \(coverage)% coverage")
case .cloudy(let coverage) where (51...99).contains(coverage):
    print("It's very cloudy, with \(coverage)% coverage")
case .cloudy(let coverage) where coverage == 100:
    print("You must live in the UK")
case .windy:
    print("It's windy")
default:
    print("It's sunny")
}

let forecast: [WeatherType] = [.cloudy(coverage: 40), .sunny, .windy, .cloudy(coverage: 100), .sunny]

for case let .cloudy(coverage) in forecast {
    print("It's cloudy with \(coverage)% coverage")
}

for case .cloudy(40) in forecast {
    print("It's cloudy with 40% coverage")
}


let view: AnyObject = UIButton()

switch view {
case is UIButton:
    print("Found a button")
case is UILabel:
    print("Found a label")
case is UISwitch:
    print("Found a switch")
case is UIView:
    print("Found a view")
default:
    print("Found something else")
}

for label in view.subviews where label is UILabel {
    print("Found a label with frame \(label.frame)")
}

for case let label as UILabel in view.subviews {
    print("Found a label with text \(label.text)")
}
