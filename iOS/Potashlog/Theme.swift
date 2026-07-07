import SwiftUI

enum Theme {
    static let accent = Color(hex: "#8A8A8A")
    static let accent2 = Color(hex: "#5B7A4F")
    static let background = Color(hex: "#111111")
    static let card = Color(hex: "#1A1A1A")
    static let textPrimary = Color.white.opacity(0.94)
    static let textSecondary = Color.white.opacity(0.6)

    static let titleFont = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
