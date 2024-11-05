import SwiftUI

struct WoodworkingColors {
    static let walnut = Color(red: 0.4, green: 0.25, blue: 0.15)
    static let maple = Color(red: 0.95, green: 0.85, blue: 0.7)
    static let cherry = Color(red: 0.6, green: 0.3, blue: 0.2)
    static let oak = Color(red: 0.8, green: 0.7, blue: 0.5)
    static let sawdust = Color(red: 0.95, green: 0.9, blue: 0.8)
    
    // UI Colors
    static let background = oak.opacity(0.1)
    static let accent = walnut
    static let text = walnut
    static let secondaryText = walnut.opacity(0.6)
    static let border = walnut.opacity(0.3)
} 