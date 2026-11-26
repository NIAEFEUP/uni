import SwiftUI

enum WidgetPalette {
    static let lectureAccentDark = Color(red: 229/255, green: 200/255, blue: 199/255)
    static let lectureAccentLight = Color(red: 0.4, green: 0.1, blue: 0.1)
    static let backgroundDark = Color(red: 47/255, green: 19/255, blue: 19/255)
    static let backgroundLight = Color(red: 255/255, green: 245/255, blue: 243/255)


    static func accentColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? lectureAccentDark : lectureAccentLight
    }

    static func primaryTextColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : .black
    }

    static func subtleTextColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? lectureAccentDark : .secondary
    }

    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? backgroundDark : backgroundLight
    }

    static func secondaryCardFill(for colorScheme: ColorScheme) -> Color {
        Color.secondary.opacity(colorScheme == .dark ? 0.15 : 0.05)
    }

    static func badgeOverlay() -> Color {
        Color.secondary.opacity(0.3)
    }

    static func typeClassColor(_ typeClass: String) -> Color {
        switch typeClass {
        case "T":
            return Color(red: 251/255, green: 193/255, blue: 31/255)
        case "TP":
            return Color(red: 211/255, green: 148/255, blue: 76/255)
        case "P":
            return Color(red: 171/255, green: 77/255, blue: 57/255)
        case "PL":
            return Color(red: 118/255, green: 156/255, blue: 135/255)
        case "OT":
            return Color(red: 124/255, green: 165/255, blue: 184/255)
        case "TC":
            return Color(red: 205/255, green: 190/255, blue: 177/255)
        case "S":
            return Color(red: 145/255, green: 124/255, blue: 155/255)
        default:
            return .secondary
        }
    }
}
