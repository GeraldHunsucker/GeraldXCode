import SwiftUI

struct RenderableLayoutView: View {
    let layout: CutLayout
    
    var body: some View {
        Canvas { context, size in
            // Draw white background
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(.white)
            )
            
            // Draw sheet outline
            let outline = Path(CGRect(origin: .zero, size: size))
            context.stroke(outline, with: .color(.gray), lineWidth: 2)
            
            // Draw pieces
            for placement in layout.placements {
                // Get the actual dimensions after any rotation
                let pieceWidth = placement.rotated ? placement.piece.length : placement.piece.width
                let pieceLength = placement.rotated ? placement.piece.width : placement.piece.length
                
                // Calculate piece position
                let x = placement.x * 4
                let y = placement.y * 4
                
                // Draw piece rectangle
                let pieceRect = CGRect(
                    x: x,
                    y: y,
                    width: pieceWidth * 4,
                    height: pieceLength * 4
                )
                let piecePath = Path(pieceRect)
                
                // Fill and stroke piece
                context.fill(piecePath, with: .color(.blue.opacity(0.1)))
                context.stroke(piecePath, with: .color(.blue), lineWidth: 1)
                
                // Create two separate text elements
                let labelText = Text(placement.piece.label)
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                
                let numberText = Text("#\(placement.piece.sequenceNumber ?? 0)")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                
                // Calculate center of piece
                let centerX = x + (pieceWidth * 4) / 2
                let centerY = y + (pieceLength * 4) / 2
                
                // Draw label slightly above center
                context.draw(labelText, at: CGPoint(x: centerX, y: centerY - 8), anchor: .center)
                
                // Draw sequence number slightly below center
                context.draw(numberText, at: CGPoint(x: centerX, y: centerY + 8), anchor: .center)
                
                // Draw kerf lines
                let kerfWidth = layout.kerfThickness * 4
                
                // Bottom kerf
                let bottomKerfRect = CGRect(
                    x: x,
                    y: y + pieceLength * 4,
                    width: pieceWidth * 4,
                    height: kerfWidth
                )
                context.fill(
                    Path(bottomKerfRect),
                    with: .color(.red.opacity(0.2))
                )
                
                // Right kerf
                let rightKerfRect = CGRect(
                    x: x + pieceWidth * 4,
                    y: y,
                    width: kerfWidth,
                    height: pieceLength * 4
                )
                context.fill(
                    Path(rightKerfRect),
                    with: .color(.red.opacity(0.2))
                )
            }
        }
        .frame(
            width: layout.material.width * 4,
            height: layout.material.length * 4
        )
        .background(Color.white)
    }
} 