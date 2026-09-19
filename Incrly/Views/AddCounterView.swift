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

private extension Color {
    var hexString: String {
        #if os(iOS)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        #else
        return "E9A7F4"
        #endif
    }

    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}
