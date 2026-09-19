import SwiftUI

struct CounterDetailView: View {
    @Environment(\\.modelContext) private var modelContext
    let counter: Counter

    private var events: [CounterEvent] {
        counter.events.sorted { $0.timestamp > $1.timestamp }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    Text(counter.emoji)
                        .font(.system(size: 52))
                    Text("\\(counter.total)")
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

            Section("History") {
                if events.isEmpty {
                    Text("No events recorded yet")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(events) { event in
                        HStack {
                            Text(event.timestamp, format: .dateTime.day().month().year())
                            Spacer()
                            Text(event.timestamp, format: .dateTime.hour().minute())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(counter.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
