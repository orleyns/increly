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

    @Relationship(deleteRule: .cascade, inverse: \CounterEvent.counter)
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

    /// Records a real event at a specific point in time.
    func increment(at date: Date = .now) {
        events.append(CounterEvent(timestamp: date, counter: self))
    }

    /// Adds to the total without creating a historical event.
    /// This is useful when importing a previous total without knowing when
    /// the corresponding increments happened.
    func addUndatedIncrements(_ count: Int) {
        guard count > 0 else { return }
        initialValue += count
    }

    /// Adds multiple historical events on the same date.
    func addHistoricalIncrements(_ count: Int, on date: Date) {
        guard count > 0 else { return }
        for _ in 0..<count {
            increment(at: date)
        }
    }
}
