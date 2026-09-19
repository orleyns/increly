import SwiftUI

struct EditCounterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let counter: Counter

    @State private var name: String
    @State private var emoji: String
    @State private var color: Color

    init(counter: Counter) {
        self.counter = counter
        _name = State(initialValue: counter.name)
        _emoji = State(initialValue: counter.emoji)
        _color = State(initialValue: Color(hex: counter.colorHex))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Text(emoji.isEmpty ? "?" : emoji)
                            .font(.system(size: 54))
                            .frame(width: 92, height: 92)
                            .background(color.opacity(0.72), in: Circle())
                        Spacer()
                    }
                }

                Section("Counter") {
                    TextField("Name", text: $name)

                    TextField("Emoji", text: $emoji)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    ColorPicker("Color", selection: $color, supportsOpacity: false)
                }

                Section {
                    LabeledContent("Current total") {
                        Text("\(counter.total)")
                            .monospacedDigit()
                    }

                    LabeledContent("Events recorded") {
                        Text("\(counter.events.count)")
                            .monospacedDigit()
                    }

                    LabeledContent("Initial value") {
                        Text("\(counter.initialValue)")
                            .monospacedDigit()
                    }
                } footer: {
                    Text("The initial value and event history are not changed when editing the counter.")
                }
            }
            .navigationTitle("Edit counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || emoji.isEmpty)
                }
            }
        }
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedEmoji = String(emoji.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1))

        guard !trimmedName.isEmpty, !normalizedEmoji.isEmpty else { return }

        counter.name = trimmedName
        counter.emoji = normalizedEmoji
        counter.colorHex = color.toHex() ?? counter.colorHex

        try? modelContext.save()
        dismiss()
    }
}
