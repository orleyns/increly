import Foundation

struct ElapsedTimeFormatter {
    static func string(since date: Date?, now: Date = .now) -> String {
        guard let date else { return "No events yet" }

        let seconds = max(0, Int(now.timeIntervalSince(date)))
        if seconds < 60 { return "less than a minute" }

        let minutes = seconds / 60
        if minutes < 60 { return "(minutes) min" }

        let hours = minutes / 60
        if hours < 24 { return "(hours) h" }

        let days = hours / 24
        return "(days) d"
    }
}
