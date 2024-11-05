import SwiftUI

struct PrintableView: View {
    let layouts: [CutLayout]
    
    var body: some View {
        VStack(spacing: 40) {
            ForEach(Array(layouts.enumerated()), id: \.element.id) { index, layout in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sheet \(index + 1)")
                        .font(.title2)
                    
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
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white)
                    )
                }
            }
        }
        .padding(40)
        .background(Color.white)
    }
} 