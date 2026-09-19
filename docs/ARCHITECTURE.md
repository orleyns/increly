# Incr&ly — Technical Architecture

## Target stack

- Swift
- SwiftUI
- SwiftData
- WidgetKit
- App Intents

## Layers

- App: application entry point and model container.
- Models: persistent counters and timestamped events.
- Views: SwiftUI screens and reusable components.
- Widgets: WidgetKit extension and interactive actions.
- Shared logic: formatting and calculations reusable by app and widget targets.

## Initial data model

### Counter

- id: UUID
- name: String
- emoji: String
- colorHex: String
- createdAt: Date
- initialValue: Int
- isArchived: Bool
- events: [CounterEvent]

### CounterEvent

- id: UUID
- timestamp: Date
- counter: Counter?

The total is derived from `initialValue + events.count`. The latest occurrence is derived from the most recent event timestamp.

## Design principles

1. Record events, not derived values.
2. Keep the domain model independent from presentation.
3. Make the primary action immediate and low-friction.
4. Prefer native iOS components and APIs.
5. Keep V1 local-first and privacy-friendly.
6. Build the widget into the architecture from the beginning.
