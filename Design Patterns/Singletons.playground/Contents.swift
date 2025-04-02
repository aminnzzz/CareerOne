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
