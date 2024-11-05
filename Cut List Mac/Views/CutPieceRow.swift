import SwiftUI

struct CutPieceRow: View {
    let piece: CutPiece
    @State private var isEditing = false
    var onUpdate: (CutPiece) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(piece.label)
                    .fontWeight(.medium)
                Text("\(piece.length)\" × \(piece.width)\" × \(piece.quantity)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            isEditing = true
        }
        .sheet(isPresented: $isEditing) {
            CutPieceEditView(piece: piece) { updatedPiece in
                onUpdate(updatedPiece)
            }
        }
    }
}

#Preview {
    CutPieceRow(
        piece: CutPiece(
            length: 24,
            width: 12,
            quantity: 1,
            label: "Sample Piece",
            requiredGrainDirection: .lengthwise
        ),
        onUpdate: { _ in }
    )
    .padding()
} 