import Foundation

struct CutLayout: Identifiable, Codable {
    let id: UUID
    let material: Material
    var placements: [Placement]
    var wastePercentage: Double
    var kerfThickness: Double
    
    struct Placement: Identifiable, Codable {
        let id: UUID
        let piece: CutPiece
        let x: Double
        let y: Double
        let rotated: Bool
        
        enum CodingKeys: String, CodingKey {
            case id, piece, x, y, rotated
        }
        
        init(id: UUID = UUID(), piece: CutPiece, x: Double, y: Double, rotated: Bool) {
            self.id = id
            self.piece = piece
            self.x = x
            self.y = y
            self.rotated = rotated
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(UUID.self, forKey: .id)
            piece = try container.decode(CutPiece.self, forKey: .piece)
            x = try container.decode(Double.self, forKey: .x)
            y = try container.decode(Double.self, forKey: .y)
            rotated = try container.decode(Bool.self, forKey: .rotated)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(piece, forKey: .piece)
            try container.encode(x, forKey: .x)
            try container.encode(y, forKey: .y)
            try container.encode(rotated, forKey: .rotated)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, material, placements, wastePercentage, kerfThickness
    }
    
    init(id: UUID = UUID(), material: Material, placements: [Placement], wastePercentage: Double, kerfThickness: Double) {
        self.id = id
        self.material = material
        self.placements = placements
        self.wastePercentage = wastePercentage
        self.kerfThickness = kerfThickness
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        material = try container.decode(Material.self, forKey: .material)
        placements = try container.decode([Placement].self, forKey: .placements)
        wastePercentage = try container.decode(Double.self, forKey: .wastePercentage)
        kerfThickness = try container.decode(Double.self, forKey: .kerfThickness)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(material, forKey: .material)
        try container.encode(placements, forKey: .placements)
        try container.encode(wastePercentage, forKey: .wastePercentage)
        try container.encode(kerfThickness, forKey: .kerfThickness)
    }
} 