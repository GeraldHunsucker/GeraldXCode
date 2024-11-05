import Foundation

struct CutPiece: Identifiable, Codable {
    let id: UUID
    var length: Double
    var width: Double
    var quantity: Int
    var label: String
    var sequenceNumber: Int?
    var requiredGrainDirection: Material.GrainDirection
    
    var displayLabel: String {
        if let num = sequenceNumber {
            return "\(label) #\(num)"
        }
        return label
    }
    
    init(id: UUID = UUID(), length: Double, width: Double, quantity: Int, label: String, sequenceNumber: Int? = nil, requiredGrainDirection: Material.GrainDirection) {
        self.id = id
        self.length = length
        self.width = width
        self.quantity = quantity
        self.label = label
        self.sequenceNumber = sequenceNumber
        self.requiredGrainDirection = requiredGrainDirection
    }
} 