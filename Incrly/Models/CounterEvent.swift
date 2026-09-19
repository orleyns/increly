import Foundation
import SwiftData

@Model
final class CounterEvent {
    @Attribute(.unique) var id: UUID
    var timestamp: Date
    var counter: Counter?

    init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        counter: Counter? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.counter = counter
    }
}
