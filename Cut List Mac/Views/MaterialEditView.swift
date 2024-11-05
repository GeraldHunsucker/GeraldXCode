import SwiftUI

struct MaterialEditView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Material) -> Void
    
    @State private var name: String
    @State private var length: Double
    @State private var width: Double
    @State private var quantity: Int
    @State private var grainDirection: Material.GrainDirection
    @State private var cost: Double
    @State private var selectedCommonMaterial: CommonMaterial?
    @State private var kerfThickness: Double = 0.125
    @State private var customKerfText: String = ""
    @State private var showCustomKerfInput = false
    
    init(material: Material? = nil, onSave: @escaping (Material) -> Void) {
        let material = material ?? Material(
            length: 96,
            width: 48,
            quantity: 1,
            name: "New Sheet",
            grainDirection: .none,
            cost: 0.0,
            kerfThickness: 0.125
        )
        _name = State(initialValue: material.name)
        _length = State(initialValue: material.length)
        _width = State(initialValue: material.width)
        _quantity = State(initialValue: material.quantity)
        _grainDirection = State(initialValue: material.grainDirection)
        _cost = State(initialValue: material.cost)
        _kerfThickness = State(initialValue: material.kerfThickness)
        _customKerfText = State(initialValue: String(format: "%.5f", material.kerfThickness))
        self.onSave = onSave
    }
    
    private var materialPicker: some View {
        Picker("Select Material", selection: $selectedCommonMaterial) {
            Text("Custom").tag(nil as CommonMaterial?)
            Divider()
            ForEach(CommonMaterial.commonMaterials) { material in
                Text(material.description).tag(material as CommonMaterial?)
            }
        }
        .onChange(of: selectedCommonMaterial) { _, newValue in
            if let material = newValue {
                name = material.name
                length = material.length
                width = material.width
                cost = 0.0
            }
        }
    }
    
    private var dimensionsSection: some View {
        HStack {
            TextField("Length", value: $length, format: .number)
                .textFieldStyle(.roundedBorder)
            TextField("Width", value: $width, format: .number)
                .textFieldStyle(.roundedBorder)
            TextField("Quantity", value: $quantity, format: .number)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    private var kerfThicknessSection: some View {
        VStack {
            HStack {
                Text("Kerf Thickness")
                Spacer()
                Text(String(format: "%.5f", kerfThickness))
            }
            
            Menu {
                Button("1/8\" (0.125)") { 
                    kerfThickness = 0.125
                    customKerfText = "0.125"
                    showCustomKerfInput = false
                }
                Button("1/32\" (0.03125)") { 
                    kerfThickness = 0.03125
                    customKerfText = "0.03125"
                    showCustomKerfInput = false
                }
                Button("Custom...") {
                    showCustomKerfInput = true
                }
            } label: {
                Text(showCustomKerfInput ? "Custom" : "Select Kerf Thickness")
            }
            
            if showCustomKerfInput {
                TextField("Custom Kerf Thickness", text: $customKerfText)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: customKerfText) { _, newValue in
                        if let value = Double(newValue.replacingOccurrences(of: ",", with: ".")) {
                            kerfThickness = value
                        }
                    }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Common Materials") {
                    materialPicker
                }
                
                Section("Material Details") {
                    TextField("Name", text: $name)
                    dimensionsSection
                    TextField("Cost per Sheet", value: $cost, format: .currency(code: "USD"))
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Grain Direction", selection: $grainDirection) {
                        Text("None").tag(Material.GrainDirection.none)
                        Text("Lengthwise").tag(Material.GrainDirection.lengthwise)
                        Text("Widthwise").tag(Material.GrainDirection.widthwise)
                    }
                    
                    kerfThicknessSection
                }
            }
            .padding()
            .frame(minWidth: 400)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let newMaterial = Material(
                            length: length,
                            width: width,
                            quantity: quantity,
                            name: name,
                            grainDirection: grainDirection,
                            cost: cost,
                            kerfThickness: kerfThickness
                        )
                        onSave(newMaterial)
                        dismiss()
                    }
                    .keyboardShortcut(.return, modifiers: [])
                }
            }
        }
    }
}

#Preview {
    MaterialEditView { material in
        print("Material saved: \(material.name)")
    }
} 