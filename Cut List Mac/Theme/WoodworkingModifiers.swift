import SwiftUI

struct WoodworkingStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(WoodworkingColors.background)
            .foregroundStyle(WoodworkingColors.text)
    }
}

struct WoodworkingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? 
                          WoodworkingColors.walnut.opacity(0.8) : 
                          WoodworkingColors.walnut)
            )
            .foregroundStyle(WoodworkingColors.maple)
    }
}

extension View {
    func woodworkingStyle() -> some View {
        modifier(WoodworkingStyle())
    }
} 