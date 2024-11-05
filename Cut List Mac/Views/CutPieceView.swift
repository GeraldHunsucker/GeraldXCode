import SwiftUI

struct CutPieceView: View {
    let piece: CutPiece
    let width: Double
    let length: Double
    let rotated: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            // Piece rectangle
            Rectangle()
                .fill(.blue.opacity(0.1))
                .border(.blue)
            
            // Label
            let shouldRotate = length > width
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(piece.label) #\(piece.sequenceNumber ?? 0)")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(shouldRotate ? 90 : 0))
                        .fixedSize()
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(width: width * 4, height: length * 4)
    }
}

#Preview {
    CutPieceView(
        piece: CutPiece(
            length: 24,
            width: 12,
            quantity: 1,
            label: "Test",
            sequenceNumber: 1,
            requiredGrainDirection: .none
        ),
        width: 12,
        length: 24,
        rotated: false
    )
} 