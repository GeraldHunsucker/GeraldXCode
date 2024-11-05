import SwiftUI

struct CutPieceEditView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (CutPiece) -> Void
    
    @State private var label: String
    @State private var length: Double
    @State private var width: Double
    @State private var quantity: Int
    @State private var requiredGrainDirection: Material.GrainDirection
    
    // Default initializer for new pieces
    init(onSave: @escaping (CutPiece) -> Void) {
        self.onSave = onSave
        _label = State(initialValue: "New Piece")
        _length = State(initialValue: 0)
        _width = State(initialValue: 0)
        _quantity = State(initialValue: 0)
        _requiredGrainDirection = State(initialValue: .none)
    }
    
    // Editing initializer for existing pieces
    init(piece: CutPiece, onSave: @escaping (CutPiece) -> Void) {
        self.onSave = onSave
        _label = State(initialValue: piece.label)
        _length = State(initialValue: piece.length)
        _width = State(initialValue: piece.width)
        _quantity = State(initialValue: piece.quantity)
        _requiredGrainDirection = State(initialValue: piece.requiredGrainDirection)
    }
    
    var body: some View {
        Form {
            TextField("Label", text: $label)
            LengthField("Length", value: $length)
            LengthField("Width", value: $width)
            
            HStack {
                Stepper("Quantity:", value: $quantity, in: 0...100)
                TextField("", value: $quantity, format: .number)
                    .frame(width: 50)
                    .multilineTextAlignment(.trailing)
            }
            
            Picker("Required Grain", selection: $requiredGrainDirection) {
                Text("None").tag(Material.GrainDirection.none)
                Text("Lengthwise").tag(Material.GrainDirection.lengthwise)
                Text("Widthwise").tag(Material.GrainDirection.widthwise)
            }
        }
        .padding()
        .frame(minWidth: 300)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    let piece = CutPiece(
                        length: length,
                        width: width,
                        quantity: quantity,
                        label: label,
                        requiredGrainDirection: requiredGrainDirection
                    )
                    onSave(piece)
                    dismiss()
                }
            }
        }
        .background {
            Button("") {  // Hidden button to handle return key
                let piece = CutPiece(
                    length: length,
                    width: width,
                    quantity: quantity,
                    label: label,
                    requiredGrainDirection: requiredGrainDirection
                )
                onSave(piece)
                dismiss()
            }
            .keyboardShortcut(.return, modifiers: [])
            .opacity(0)
        }
    }
}

struct LengthField: View {
    let label: String
    @Binding var value: Double
    
    init(_ label: String, value: Binding<Double>) {
        self.label = label
        self._value = value
    }
    
    var body: some View {
        HStack {
            Text(label)
            TextField("", value: $value, format: .number)
            Text("inches")
        }
    }
}

#Preview {
    CutPieceEditView { piece in
        print("Piece saved: \(piece.label)")
    }
} 
