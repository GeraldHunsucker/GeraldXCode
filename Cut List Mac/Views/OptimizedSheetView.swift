import SwiftUI

struct OptimizedSheetView: View {
    let layout: CutLayout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(layout.material.name)
                .font(.headline)
            HStack {
                Text("Waste: \(String(format: "%.1f", layout.wastePercentage))%")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if layout.material.cost > 0 {
                    Text("Sheet Cost: \(layout.material.cost, format: .currency(code: "USD"))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            RenderableLayoutView(layout: layout)
                .frame(
                    width: layout.material.width * 4,
                    height: layout.material.length * 4
                )
                .background(Color.white)
                .drawingGroup() // Force Metal rendering
        }
        .padding()
        .background(Color.white)
    }
} 