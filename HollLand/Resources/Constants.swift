import SwiftUI

struct Constants {
    struct Colors {
        static let textGradient = LinearGradient(colors: [.l1, .l2, .l1], startPoint: .leading, endPoint: .trailing)
    }
    
    struct Fonts {
        static let largeTitle: Font = .system(size: 24, weight: .regular)
        static let largeTitle2: Font = .system(size: 24, weight: .medium)
        static let title: Font = .system(size: 20, weight: .regular)
        static let title2: Font = .system(size: 20, weight: .medium)
        static let text: Font = .system(size: 16, weight: .regular)
        static let text2: Font = .system(size: 16, weight: .medium)
        static let subtitle: Font = .system(size: 14, weight: .regular)
        static let subtitle2: Font = .system(size: 14, weight: .medium)
        static let caption: Font = .system(size: 12, weight: .regular)
    }
    
    struct Spacing {
        static let xs: CGFloat = 2
        static let s: CGFloat = 4
        static let m: CGFloat = 8
        static let l: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }
    
    struct CornerRadius {
        static let main: CGFloat = 8
    }
    
    struct Components {
        static let moodButtonHeight: CGFloat = 48
        static let circleButtonSize: CGFloat = 56
        static let textField: CGFloat = 48
        static let textEditor: CGFloat = 97
        static let cardHeight: CGFloat = 120
        static let symptomRowHeight: CGFloat = 44
        static let tabBarHeight: CGFloat = 49
    }
    
    struct Icons {
        static let mountain = "mountain.2"
        static let calendar = "calendar"
        static let chart = "chart.bar"
        static let home = "house"
        static let location = "location"
        static let thermometer = "thermometer"
        static let wind = "wind"
        static let snowflake = "snowflake"
        static let plus = "plus"
        static let pencil = "square.and.pencil"
        static let trash = "trash"
        static let chevronLeft = "chevron.left"
        static let chevronRight = "chevron.right"
        static let checkmark = "checkmark"
        static let xmark = "xmark.circle.fill"
        static let medal = "medal.fill"
    }
}

#Preview {
    let icons = [
        Constants.Icons.mountain,
        Constants.Icons.calendar,
        Constants.Icons.chart,
        Constants.Icons.home,
        Constants.Icons.location,
        Constants.Icons.thermometer,
        Constants.Icons.wind,
        Constants.Icons.snowflake,
        Constants.Icons.plus,
        Constants.Icons.pencil,
        Constants.Icons.trash,
        Constants.Icons.chevronLeft,
        Constants.Icons.chevronRight,
        Constants.Icons.checkmark,
        Constants.Icons.xmark,
        Constants.Icons.medal
    ]
    return VStack(spacing: Constants.Spacing.m) {
        ForEach(icons, id: \.self) { icon in
            Image(systemName: icon)
                .font(Constants.Fonts.title)
                .foregroundStyle(.accent)
        }
    }
}
