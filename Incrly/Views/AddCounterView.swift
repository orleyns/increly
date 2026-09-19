import SwiftUI
import SwiftData

struct AddCounterView: View {
    @Environment(\\.dismiss) private var dismiss
    @Environment(\\.modelContext) private var modelContext

    @State private var name = ""
    @State private var emoji = "✨"
    @State private var colorHex = "E9A7F4"
    @State private var initialValue = 0

    private var canCreate: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text(emoji)
                            .font(.system(size: 64))
                            .frame(width: 96, height: 96)
                            .background(Color(hex: colorHex).opacity(0.72), in: Circle())
                        Spacer()
                    }
                }

                Section("Counter") {
                    TextField("Name", text: $name)
                    TextField("Emoji", text: $emoji)
                        .textInputAutocapitalization(.never)
                    Stepper("Initial value: \\(initialValue)", value: $initialValue, in: 0...Int.max)
                }

                Section("Color") {
                    ColorPicker("Counter color", selection: colorBinding)
                }
            }
            .navigationTitle("New Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createCounter() }
                        .disabled(!canCreate)
                }
            }
        }
    }

    private var colorBinding: Binding<Color> {
        Binding(
            get: { Color(hex: colorHex) },
            set: { colorHex = $0.hexString }
        )
    }

    private func createCounter() {
        let counter = Counter(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            emoji: emoji.isEmpty ? "✨" : String(emoji.prefix(2)),
            colorHex: colorHex,
            initialValue: initialValue
        )
        modelContext.insert(counter)
        try? modelContext.save()
        dismiss()
    }
}
