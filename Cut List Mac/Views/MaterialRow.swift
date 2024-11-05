import SwiftUI

struct MaterialRow: View {
    let material: Material
    @State private var isEditing = false
    var onUpdate: (Material) -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(material.name)
                    .fontWeight(.medium)
                Text("\(material.length)\" × \(material.width)\" × \(material.quantity)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if material.cost > 0 {
                    Text(material.cost, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if material.kerfThickness > 0 {
                    Text("Kerf: \(String(format: "%.5f", material.kerfThickness))\"")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(WoodworkingColors.maple.opacity(0.1))
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isEditing = true
        }
        .sheet(isPresented: $isEditing) {
            MaterialEditView(material: material) { updatedMaterial in
                onUpdate(updatedMaterial)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        MaterialRow(
            material: Material(
                length: 96,
                width: 48,
                quantity: 1,
                name: "Sample Sheet",
                grainDirection: .lengthwise,
                cost: 45.99,
                kerfThickness: 0.125
            ),
            onUpdate: { _ in }
        )
        
        MaterialRow(
            material: Material(
                length: 96,
                width: 48,
                quantity: 1,
                name: "Sample Sheet",
                grainDirection: .widthwise,
                cost: 45.99,
                kerfThickness: 0.03125
            ),
            onUpdate: { _ in }
        )
        
        MaterialRow(
            material: Material(
                length: 96,
                width: 48,
                quantity: 1,
                name: "Sample Sheet",
                grainDirection: .none,
                cost: 45.99,
                kerfThickness: 0.125
            ),
            onUpdate: { _ in }
        )
    }
    .padding()
} 