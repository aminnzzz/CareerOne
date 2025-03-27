import UIKit

struct RemoteFile<T: Decodable> {
    var url: URL
    var type: T.Type

    var contents: T {
        get async throws {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let session = URLSession(configuration: config)

            let (data, _) = try await session.data(from: url)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

struct Settings: Codable {
    enum CodingKeys: String, CodingKey {
        case username
        case age
        case lastLogin = "lastLoginDate"
        case friends
        case darkMode
    }

    var username: String
    var age: Int
    var lastLogin: Date
    var friends: [String]
    var darkMode: Bool

    init(username: String, age: Int, lastLogin: Date, friends: [String], darkMode: Bool) {
        self.username = username
        self.age = age
        self.lastLogin = lastLogin
        self.friends = friends
        self.darkMode = darkMode
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? "Some default value"
        self.age = try container.decode(Int.self, forKey: .age)
        self.lastLogin = try container.decode(Date.self, forKey: .lastLogin)
        self.friends = try container.decode([String].self, forKey: .friends)
        self.darkMode = try container.decode(Bool.self, forKey: .darkMode)

        if !friends.contains("Tom") {
            friends.append("Tom")
        }

//        let colorData = try container.decode(Data.self, forKey: .favoriteColor)
//        favoriteColor = (try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: colorData)) ?? .black
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.username, forKey: .username)
        try container.encode(self.age, forKey: .age)
        try container.encode(self.lastLogin, forKey: .lastLogin)
        try container.encode(self.friends, forKey: .friends)
        try container.encode(self.darkMode, forKey: .darkMode)
//        let colorData = try NSKeyedArchiver.archivedData(withRootObject: favoriteColor, requiringSecureCoding: true)
//        try container.encode(colorData, forKey: .favoriteColor)
    }
}

let settings = Settings(username: "tswift13", age: 26, lastLogin: .now, friends: ["Adele"], darkMode: true)
let encoder = JSONEncoder()

encoder.dateEncodingStrategy = .iso8601

//let formatter = DateFormatter()
//formatter.dateStyle = .full
//formatter.timeStyle = .full
//encoder.dateEncodingStrategy = .formatted(formatter)

//encoder.dateEncodingStrategy = .custom { date, encoder in
//    var container = encoder.singleValueContainer()
//    try container.encode("The date is \(date)")
//}

encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

let data = try encoder.encode(settings)
let str = String(decoding: data, as: UTF8.self)
print(str)

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
let loadedSettings = try decoder.decode(Settings.self, from: data)
print(loadedSettings)


let jsonString = """
{
    "name": "Taylor Swift",
    "address": {
        "street": "555 Taylor Swift Avenue",
        "city": "Nashville",
        "state": "Tennessee"
    }
}
"""

let jsonData = Data(jsonString.utf8)

struct User: Codable {
//    struct Address: Codable {
//        var street: String
//        var city: String
//        var state: String
//    }
    enum CodingKeys: String, CodingKey {
        case name
        case address
    }

    enum AddressCodingKeys: String, CodingKey {
        case street
        case city
        case state
    }

    var name: String
    var street: String
    var city: String
    var state: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let addressContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        self.street = try addressContainer.decode(String.self, forKey: .street)
        self.city = try addressContainer.decode(String.self, forKey: .city)
        self.state = try addressContainer.decode(String.self, forKey: .state)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        var addressContainer = container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        try addressContainer.encode(street, forKey: .street)
        try addressContainer.encode(city, forKey: .city)
        try addressContainer.encode(state, forKey: .state)
    }
}

//let decoder = JSONDecoder()
//let user = try decoder.decode(User.self, from: jsonData)
//print(user.address.city)

// Singletons

@MainActor
class Logger {
    static let shared = Logger()

    private init() { }

    func log(_ message: String) {
        print(message)
    }
}

@MainActor
protocol Logging {
    func log(_ message: String)
}

extension Logging {
    func log(_ message: String) {
        Logger.shared.log(message)
    }
}

struct MainScreen: Logging {
    func authenticate() {
        log("Authentication was successful!")
    }
}

let screen = MainScreen()
screen.authenticate()
