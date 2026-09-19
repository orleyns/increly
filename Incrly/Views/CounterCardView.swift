import SwiftUI

struct CounterCardView: View {
    @Environment(\\.modelContext) private var modelContext
    let counter: Counter

    var body: some View {
        NavigationLink {
            CounterDetailView(counter: counter)
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(counter.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(ElapsedTimeFormatter.string(since: counter.lastOccurrence))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 8)

                Text("\\(counter.total)")
                    .font(.title2.weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(.primary)

                Button {
                    counter.increment()
                    try? modelContext.save()
                } label: {
                    Text(counter.emoji)
                        .font(.title2)
                        .frame(width: 48, height: 48)
                        .background(.thinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Increment \\(counter.name)")
            }
            .padding(14)
            .background(
                Color(hex: counter.colorHex).opacity(0.72),
                in: RoundedRectangle(cornerRadius: 24, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                counter.isArchived = true
                try? modelContext.save()
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
        }
    }
}

private extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)

        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
