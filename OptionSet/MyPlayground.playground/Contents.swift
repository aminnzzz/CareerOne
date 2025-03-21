import UIKit
import SwiftUI

struct Edge: OptionSet {
    let rawValue: Int

    static let top = Edge(rawValue: 1)
    static let bottom = Edge(rawValue: 1 << 1)
    static let leading = Edge(rawValue: 1 << 2)
    static let trailing = Edge(rawValue: 1 << 3)
    static let vertical: Edge = [.top, .bottom]
    static let horizontal: Edge = [.leading, .trailing]

    init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Days OptionSet
struct Days: OptionSet {
    let rawValue: Int

    // Individual days
    static let monday = Days(rawValue: 1 << 0)      // 1
    static let tuesday = Days(rawValue: 1 << 1)     // 2
    static let wednesday = Days(rawValue: 1 << 2)   // 4
    static let thursday = Days(rawValue: 1 << 3)    // 8
    static let friday = Days(rawValue: 1 << 4)      // 16
    static let saturday = Days(rawValue: 1 << 5)    // 32
    static let sunday = Days(rawValue: 1 << 6)      // 64

    // Common groupings
    static let weekdays: Days = [.monday, .tuesday, .wednesday, .thursday, .friday]
    static let weekend: Days = [.saturday, .sunday]
    static let allDays: Days = [.weekdays, .weekend]

    // MARK: - Helpers for working with raw values

    // Get an array of individual day options from a raw value
    static func daysFromRawValue(_ rawValue: Int) -> [Days] {
        var result: [Days] = []

        if rawValue & Days.monday.rawValue != 0 { result.append(.monday) }
        if rawValue & Days.tuesday.rawValue != 0 { result.append(.tuesday) }
        if rawValue & Days.wednesday.rawValue != 0 { result.append(.wednesday) }
        if rawValue & Days.thursday.rawValue != 0 { result.append(.thursday) }
        if rawValue & Days.friday.rawValue != 0 { result.append(.friday) }
        if rawValue & Days.saturday.rawValue != 0 { result.append(.saturday) }
        if rawValue & Days.sunday.rawValue != 0 { result.append(.sunday) }

        return result
    }

    // Get the name for a specific day
    static func dayName(_ day: Days) -> String {
        switch day {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        default: return "Unknown"
        }
    }

    // Get short name for a specific day
    static func shortDayName(_ day: Days) -> String {
        switch day {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        default: return "Unknown"
        }
    }

    static var allCases: [Days] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }
}

// MARK: - SwiftUI Components

// Individual day button
struct DayButton: View {
    let day: Days
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(Days.shortDayName(day))
                .font(.system(size: 14))
                .frame(width: 40, height: 40)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}

// Custom day selector view
struct DayPicker: View {
    @Binding var selectedDays: Days

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Days")
                .font(.headline)
            
            HStack(spacing: 8) {
                ForEach(Days.allCases, id: \.rawValue) { day in
                    DayButton(
                        day: day,
                        isSelected: selectedDays.contains(day),
                        action: {
                            if selectedDays.contains(day) {
                                selectedDays.remove(day)
                            } else {
                                selectedDays.insert(day)
                            }
                        }
                    )
                }
            }
        }
    }
}
