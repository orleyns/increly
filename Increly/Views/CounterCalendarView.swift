import SwiftUI

struct CounterCalendarView: View {
    let events: [CounterEvent]

    @State private var displayedMonth = Date()

    private var calendar: Calendar { .current }

    private var eventCountsByDay: [Date: Int] {
        Dictionary(grouping: events) { calendar.startOfDay(for: $0.timestamp) }
            .mapValues(\.count)
    }

    private var monthDays: [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        let firstDay = firstWeek.start
        let numberOfDays = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 0

        let weekday = calendar.component(.weekday, from: firstDay)
        let firstWeekday = calendar.firstWeekday
        let leading = (weekday - firstWeekday + 7) % 7

        return Array(repeating: nil, count: leading)
            + (0..<numberOfDays).compactMap {
                calendar.date(byAdding: .day, value: $0, to: monthInterval.start)
            }.map { Optional($0) }
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                } label: {
                    Image(systemName: "chevron.left")
                }

                Spacer()

                Text(displayedMonth, format: .dateTime.month(.wide).year())
                    .font(.headline)

                Spacer()

                Button {
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                } label: {
                    Image(systemName: "chevron.right")
                }
            }

            let weekdaySymbols = calendar.veryShortStandaloneWeekdaySymbols
            HStack(spacing: 0) {
                ForEach(rotatedWeekdaySymbols(weekdaySymbols), id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(monthDays.enumerated()), id: \.offset) { _, day in
                    if let day {
                        let startOfDay = calendar.startOfDay(for: day)
                        let count = eventCountsByDay[startOfDay] ?? 0

                        VStack(spacing: 3) {
                            Text(day, format: .dateTime.day())
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, minHeight: 28)

                            if count > 0 {
                                Text(count > 99 ? "99+" : "\(count)")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(.tint, in: Capsule())
                            } else {
                                Color.clear.frame(height: 16)
                            }
                        }
                    } else {
                        Color.clear.frame(height: 47)
                    }
                }
            }
        }
    }

    private func rotatedWeekdaySymbols(_ symbols: [String]) -> [String] {
        let start = max(calendar.firstWeekday - 1, 0)
        return Array(symbols[start...] + symbols[..<start])
    }
}
