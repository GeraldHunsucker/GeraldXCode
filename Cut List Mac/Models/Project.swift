import Foundation

struct Project: Codable {
    var name: String
    var materials: [Material]
    var cutPieces: [CutPiece]
    var layouts: [CutLayout]
    var dateModified: Date
    
    static let defaultFileName = "CutListProject.json"
    
    enum CodingKeys: String, CodingKey {
        case name, materials, cutPieces, layouts, dateModified
    }
    
    init(name: String, materials: [Material], cutPieces: [CutPiece], layouts: [CutLayout], dateModified: Date) {
        self.name = name
        self.materials = materials
        self.cutPieces = cutPieces
        self.layouts = layouts
        self.dateModified = dateModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        materials = try container.decode([Material].self, forKey: .materials)
        cutPieces = try container.decode([CutPiece].self, forKey: .cutPieces)
        layouts = try container.decode([CutLayout].self, forKey: .layouts)
        dateModified = try container.decode(Date.self, forKey: .dateModified)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(materials, forKey: .materials)
        try container.encode(cutPieces, forKey: .cutPieces)
        try container.encode(layouts, forKey: .layouts)
        try container.encode(dateModified, forKey: .dateModified)
    }
} 