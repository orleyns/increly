import SwiftUI

struct CounterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let counter: Counter

    @State private var showingManualAdd = false

    private var events: [CounterEvent] {
        counter.events.sorted { $0.timestamp > $1.timestamp }
    }

    private var chronologicalEvents: [CounterEvent] {
        counter.events.sorted { $0.timestamp < $1.timestamp }
    }

    private var calendar: Calendar {
        .current
    }

    private var todayCount: Int {
        events.filter { calendar.isDateInToday($0.timestamp) }.count
    }

    private var weekCount: Int {
        guard let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: .now)) else {
            return 0
        }
        return events.filter { $0.timestamp >= start }.count
    }

    private var monthCount: Int {
        guard let start = calendar.date(from: calendar.dateComponents([.year, .month], from: .now)) else {
            return 0
        }
        return events.filter { $0.timestamp >= start }.count
    }

    private var averagePerDay: Double? {
        guard !events.isEmpty else { return nil }

        let firstDay = calendar.startOfDay(for: chronologicalEvents.first!.timestamp)
        let today = calendar.startOfDay(for: .now)
        let dayCount = max(calendar.dateComponents([.day], from: firstDay, to: today).day ?? 0, 0) + 1

        return Double(events.count) / Double(dayCount)
    }

    private var averageInterval: TimeInterval? {
        intervalStatistics.average
    }

    private var longestInterval: TimeInterval? {
        intervalStatistics.longest
    }

    private var intervalStatistics: (average: TimeInterval?, longest: TimeInterval?) {
        guard chronologicalEvents.count >= 2 else {
            return (nil, nil)
        }

        let intervals = zip(chronologicalEvents, chronologicalEvents.dropFirst()).map {
            $1.timestamp.timeIntervalSince($0.timestamp)
        }

        return (
            intervals.reduce(0, +) / Double(intervals.count),
            intervals.max()
        )
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    Text(counter.emoji)
                        .font(.system(size: 52))

                    Text("\(counter.total)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text(ElapsedTimeFormatter.string(since: counter.lastOccurrence))
                        .foregroundStyle(.secondary)

                    Button {
                        counter.increment()
                        try? modelContext.save()
                    } label: {
                        Label("Increment", systemImage: "plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }

            Section("Statistics") {
                StatisticRow(title: "Today", value: "\(todayCount)")
                StatisticRow(title: "Last 7 days", value: "\(weekCount)")
                StatisticRow(title: "This month", value: "\(monthCount)")

                if let averagePerDay {
                    StatisticRow(
                        title: "Average per day",
                        value: averagePerDay.formatted(.number.precision(.fractionLength(1)))
                    )
                }

                if let averageInterval {
                    StatisticRow(title: "Average interval", value: formatInterval(averageInterval))
                }

                if let longestInterval {
                    StatisticRow(title: "Longest interval", value: formatInterval(longestInterval))
                }
            }

            Section("History") {
                if events.isEmpty {
                    Text("No events recorded yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(events) { event in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(event.timestamp, format: .dateTime.weekday(.wide))
                                    .font(.subheadline.weight(.medium))
                                Text(event.timestamp, format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(event.timestamp, format: .dateTime.hour().minute())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: deleteEvents)
                }
            }
        }
        .navigationTitle(counter.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingManualAdd = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add past clicks")
            }
        }
        .sheet(isPresented: $showingManualAdd) {
            AddManualIncrementsView(counter: counter)
        }
    }

    private func deleteEvents(at offsets: IndexSet) {
        let selectedEvents = offsets.map { events[$0] }

        for event in selectedEvents {
            modelContext.delete(event)
        }

        try? modelContext.save()
    }

    private func formatInterval(_ interval: TimeInterval) -> String {
        let totalMinutes = max(Int(interval / 60), 0)
        let days = totalMinutes / (24 * 60)
        let hours = (totalMinutes % (24 * 60)) / 60
        let minutes = totalMinutes % 60

        if days > 0 {
            return hours > 0 ? "\(days)d \(hours)h" : "\(days)d"
        }

        if hours > 0 {
            return minutes > 0 ? "\(hours)h \(minutes)min" : "\(hours)h"
        }

        return "\(minutes)min"
    }
}

private struct StatisticRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
    }
}
