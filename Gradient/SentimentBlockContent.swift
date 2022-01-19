//
//  SentimentBlock.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

protocol SentimentBlockContent {
    var entry: Entry { get }
    var bgColor: Color { get }
}

extension SentimentBlockContent {
    var bgColor: Color {
        if let uiColor = UIColor(hex: "#\(entry.wrappedColor)FF") {
            return Color(uiColor: uiColor)
        }

        return Color.red
    }

    func getMonthNameDayNum(from date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d"
        return dateFormat.string(from: date)
    }

    func getFullDate(from date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d, yyyy"
        return dateFormat.string(from: date)
    }

    func getDayOfWeekName(from date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE"
        return dateFormat.string(from: date)
    }

    func getDayOfWeekNum(from date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "d"
        return dateFormat.string(from: date)
    }
}

struct SentimentBlockContentFull: View, SentimentBlockContent {
    let entry: Entry

    var monthDay: String {
        getMonthNameDayNum(from: entry.wrappedDate)
    }

    var dayOfWeek: String {
        getDayOfWeekName(from: entry.wrappedDate)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(monthDay)
                .font(.subheadline)

            Text(dayOfWeek)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(bgColor)
        .foregroundColor(.white)
        .cornerRadius(8)
    }
}

struct SentimentBlockContentCondensed: View, SentimentBlockContent {
    let entry: Entry

    var monthDay: String {
        getMonthNameDayNum(from: entry.wrappedDate)
    }

    var dayOfWeek: String {
        getDayOfWeekName(from: entry.wrappedDate)
    }

    var body: some View {
        HStack(alignment: .top) {
            Rectangle()
                .foregroundColor(bgColor)
                .frame(width: 40, height: 40)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(monthDay)
                    .font(.system(.subheadline))
                    .foregroundColor(.secondary)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())

                Text(dayOfWeek)
                    .font(.system(.title3))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SentimentBlockContentMini: View, SentimentBlockContent {
    let entry: Entry

    var dayNum: String {
        getDayOfWeekNum(from: entry.wrappedDate)
    }

    var body: some View {
        Text(dayNum)
            .fontWeight(.bold)
            .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
            .background(bgColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct SentimentBlockContentFull_Previews: PreviewProvider {
    static var previews: some View {
        SentimentBlockContentFull(entry: Entry())
    }
}

struct SentimentBlockContentCondensed_Previews: PreviewProvider {
    static var previews: some View {
        SentimentBlockContentCondensed(entry: Entry())
    }
}

struct SentimentBlockContentMini_Previews: PreviewProvider {
    static var previews: some View {
        SentimentBlockContentMini(entry: Entry())
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
