import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Counter> { !$0.isArchived }, sort: \.createdAt)
    private var counters: [Counter]

    @State private var showingAddCounter = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 14) {
                    if counters.isEmpty {
                        emptyState
                    } else {
                        ForEach(counters) { counter in
                            CounterCardView(counter: counter)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 96)
            }
            .navigationTitle("incr&ly")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddCounter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Create a counter")
                }
            }
            .overlay(alignment: .bottom) {
                Button {
                    showingAddCounter = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .frame(width: 64, height: 48)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(.bottom, 18)
            }
            .sheet(isPresented: $showingAddCounter) {
                AddCounterView()
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No counters yet", systemImage: "plus.circle")
        } description: {
            Text("Create your first incr&ly counter to start recording events.")
        } actions: {
            Button("Create a counter") {
                showingAddCounter = true
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 120)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Counter.self, CounterEvent.self], inMemory: true)
}
