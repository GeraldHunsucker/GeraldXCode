import Foundation

struct CommonMaterial: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let length: Double
    let width: Double
    let cost: Double
    let description: String
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CommonMaterial, rhs: CommonMaterial) -> Bool {
        lhs.id == rhs.id
    }
    
    static let commonMaterials: [CommonMaterial] = [
        // Plywood Sheets
        CommonMaterial(name: "1/4\" Plywood", length: 96, width: 48, cost: 25.99, description: "1/4\" × 4' × 8' Standard Plywood"),
        CommonMaterial(name: "1/2\" Plywood", length: 96, width: 48, cost: 35.99, description: "1/2\" × 4' × 8' Standard Plywood"),
        CommonMaterial(name: "3/4\" Plywood", length: 96, width: 48, cost: 45.99, description: "3/4\" × 4' × 8' Standard Plywood"),
        
        // MDF Sheets
        CommonMaterial(name: "1/4\" MDF", length: 96, width: 48, cost: 22.99, description: "1/4\" × 4' × 8' Medium Density Fiberboard"),
        CommonMaterial(name: "1/2\" MDF", length: 96, width: 48, cost: 32.99, description: "1/2\" × 4' × 8' Medium Density Fiberboard"),
        CommonMaterial(name: "3/4\" MDF", length: 96, width: 48, cost: 42.99, description: "3/4\" × 4' × 8' Medium Density Fiberboard"),
        
        // Particle Board
        CommonMaterial(name: "1/2\" Particle Board", length: 96, width: 48, cost: 28.99, description: "1/2\" × 4' × 8' Particle Board"),
        CommonMaterial(name: "3/4\" Particle Board", length: 96, width: 48, cost: 38.99, description: "3/4\" × 4' × 8' Particle Board"),
        
        // Melamine
        CommonMaterial(name: "3/4\" White Melamine", length: 96, width: 48, cost: 52.99, description: "3/4\" × 4' × 8' White Melamine"),
        
        // OSB
        CommonMaterial(name: "7/16\" OSB", length: 96, width: 48, cost: 18.99, description: "7/16\" × 4' × 8' Oriented Strand Board"),
        
        // Common construction sizes
        CommonMaterial(name: "5' × 5' Sheet", length: 60, width: 60, cost: 40.99, description: "5' × 5' Custom Sheet"),
        CommonMaterial(name: "2' × 4' Sheet", length: 48, width: 24, cost: 15.99, description: "2' × 4' Project Panel"),
        
        // European sizes (in inches)
        CommonMaterial(name: "2440mm × 1220mm Sheet", length: 96.06, width: 48.03, cost: 45.99, description: "2440mm × 1220mm Standard European")
    ]
} 