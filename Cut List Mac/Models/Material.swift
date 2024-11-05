import Foundation

struct Material: Identifiable, Codable {
    let id: UUID
    var length: Double
    var width: Double
    var quantity: Int
    var name: String
    var grainDirection: GrainDirection
    var cost: Double
    var kerfThickness: Double
    
    enum GrainDirection: String, Codable {
        case lengthwise
        case widthwise
        case none
    }
    
    init(id: UUID = UUID(), length: Double, width: Double, quantity: Int, name: String, grainDirection: GrainDirection, cost: Double = 0.0, kerfThickness: Double = 0.125) {
        self.id = id
        self.length = length
        self.width = width
        self.quantity = quantity
        self.name = name
        self.grainDirection = grainDirection
        self.cost = cost
        self.kerfThickness = kerfThickness
    }
} 