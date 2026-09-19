import SwiftUI

struct AddManualIncrementsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let counter: Counter

    @State private var quantity = 1
    @State private var hasDate = false
    @State private var date = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper(value: $quantity, in: 1...100_000) {
                        HStack {
                            Text("Quantity")
                            Spacer()
                            Text("\(quantity)")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                }

                Section {
                    Toggle("Add a date", isOn: $hasDate)

                    if hasDate {
                        DatePicker(
                            "Date and time",
                            selection: $date,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                } footer: {
                    Text(
                        hasDate
                        ? "The increments will be added to the history on this date."
                        : "Without a date, the increments are added to the total without creating history entries."
                    )
                }
            }
            .navigationTitle("Add past clicks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addIncrements()
                    }
                }
            }
        }
    }

    private func addIncrements() {
        if hasDate {
            counter.addHistoricalIncrements(quantity, on: date)
        } else {
            counter.addUndatedIncrements(quantity)
        }

        try? modelContext.save()
        dismiss()
    }
}
