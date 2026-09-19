import Foundation
import SwiftData

@Model
final class Counter {
    @Attribute(.unique) var id: UUID
    var name: String
    var emoji: String
    var colorHex: String
    var createdAt: Date
    var initialValue: Int
    var isArchived: Bool

    @Relationship(deleteRule: .cascade, inverse: \\CounterEvent.counter)
    var events: [CounterEvent]

    init(
        id: UUID = UUID(),
        name: String,
        emoji: String,
        colorHex: String,
        createdAt: Date = .now,
        initialValue: Int = 0,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.colorHex = colorHex
        self.createdAt = createdAt
        self.initialValue = initialValue
        self.isArchived = isArchived
        self.events = []
    }

    var total: Int { initialValue + events.count }

    var lastOccurrence: Date? {
        events.max(by: { $0.timestamp < $1.timestamp })?.timestamp
    }

    func increment(at date: Date = .now) {
        events.append(CounterEvent(timestamp: date, counter: self))
    }
}
