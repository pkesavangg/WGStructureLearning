import SwiftUI

struct AuthButtonStyle: ButtonStyle {
    @Environment(\.appTheme) private var theme
    let isPrimary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.all, .p16)
            .background(
                isPrimary ? theme.primary : theme.surface
            )
            .foregroundColor(
                isPrimary ? theme.onPrimary : theme.onSurface
            )
            .cornerRadius(.medium)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusSize.medium.value)
                    .stroke(isPrimary ? Color.clear : theme.primary, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == AuthButtonStyle {
    static func auth(isPrimary: Bool = true) -> AuthButtonStyle {
        AuthButtonStyle(isPrimary: isPrimary)
    }
} 
