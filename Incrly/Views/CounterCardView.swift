import SwiftUI

struct CounterCardView: View {
    @Environment(\.modelContext) private var modelContext
    let counter: Counter

    @State private var showingManualAdd = false

    var body: some View {
        HStack(spacing: 14) {
            NavigationLink {
                CounterDetailView(counter: counter)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(counter.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(ElapsedTimeFormatter.string(since: counter.lastOccurrence))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            Text("\(counter.total)")
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
            .accessibilityLabel("Increment \(counter.name)")

            Button {
                showingManualAdd = true
            } label: {
                Image(systemName: "plus")
                    .font(.caption.weight(.bold))
                    .frame(width: 26, height: 26)
                    .background(.thinMaterial, in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add past clicks to \(counter.name)")
        }
        .padding(14)
        .background(
            Color(hex: counter.colorHex).opacity(0.72),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .contextMenu {
            Button {
                counter.isArchived = true
                try? modelContext.save()
            } label: {
                Label("Archive", systemImage: "archivebox")
            }
        }
        .sheet(isPresented: $showingManualAdd) {
            AddManualIncrementsView(counter: counter)
        }
    }
}
