//
//  SentimentBlock.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

protocol SentimentBlockContent {
    var date: Date { get }
    var bgColor: Color { get }
}

extension SentimentBlockContent {
    var bgColor: Color {
        return Color(red: 0.34, green: 0.68, blue: 0.45)
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
    let date: Date

    var monthDay: String {
        getMonthNameDayNum(from: date)
    }

    var dayOfWeek: String {
        getDayOfWeekName(from: date)
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
    let date: Date

    var monthDay: String {
        getMonthNameDayNum(from: date)
    }

    var dayOfWeek: String {
        getDayOfWeekName(from: date)
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

                Text(dayOfWeek)
                    .font(.system(.title3))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SentimentBlockContentMini: View, SentimentBlockContent {
    let date: Date

    var dayNum: String {
        getDayOfWeekNum(from: date)
    }

    var body: some View {
        Text(dayNum)
            .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
            .background(bgColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct SentimentBlockContentFull_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        SentimentBlockContentFull(date: date)
    }
}

struct SentimentBlockContentCondensed_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        SentimentBlockContentCondensed(date: date)
    }
}

struct SentimentBlockContentMini_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        SentimentBlockContentMini(date: date)
    }
}
