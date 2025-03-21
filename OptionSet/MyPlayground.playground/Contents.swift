import UIKit

struct Edge: OptionSet {
    let rawValue: Int

    enum Days {
        case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    }

    static let top = Edge(rawValue: 1)
    static let bottom = Edge(rawValue: 1 << 1)
    static let leading = Edge(rawValue: 1 << 2)
    static let trailing = Edge(rawValue: 1 << 3)
    static let vertical: Edge = [.top, .bottom]
    static let horizontal: Edge = [.leading, .trailing]

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    init(days: [Days]) {
        var e: Edge
        for case let day in days {
            switch day {
            case .Monday:
                <#code#>
            case .Tuesday:
                <#code#>
            case .Wednesday:
                <#code#>
            case .Thursday:
                <#code#>
            case .Friday:
                <#code#>
            case .Saturday:
                <#code#>
            case .Sunday:
                <#code#>
            }
        }
    }
}
