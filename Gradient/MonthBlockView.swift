//
//  MonthBlockView.swift
//  Gradient
//
//  Created by Brent Meyer on 1/9/22.
//

import SwiftUI

struct MonthBlockView: View {
    let date: Date

    var daysInMonth: [Date] {
        getAllDaysInMonth(for: date)
    }

    var startingDay: Int {
        getFirstDayOfMonth(for: daysInMonth[0])
    }

    var monthName: String {
        getMonthName(for: date)
    }

    func getMonthName(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }

    func getFirstDayOfMonth(for date: Date) -> Int {
        let userCalendar = Calendar.current
        let weekday = userCalendar.component(.weekday, from: date)
        return weekday
    }

    func getAllDaysInMonth(for date: Date) -> [Date] {
        let userCalendar = Calendar.current

        let dateComponents = userCalendar.dateComponents([.month, .year], from: date)

        var firstDayInMonth: Date {
            let firstDay = DateComponents(calendar: userCalendar, year: dateComponents.year, month: dateComponents.month).date!
            return firstDay
        }

        var days = [Date]()
        let calRange = userCalendar.range(of: .day, in: .month, for: firstDayInMonth)

        if let calRange = calRange {
            for dayNum in calRange {
                if let day = userCalendar.date(byAdding: .day, value: dayNum - 1, to: firstDayInMonth) {
                    days.append(day)
                }
            }
        }

        return days
    }

    struct MonthGrid: View {
        let startingDay: Int
        let days: [Date]

        var monthDays: [Date?] {
            var monthWithNilDays = [Date?]()

            for _ in 1..<startingDay {
                monthWithNilDays.append(nil)
            }

            for day in days {
                monthWithNilDays.append(day)
            }

            return monthWithNilDays
        }

        let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

        var body: some View {
            LazyVGrid(columns: gridLayout) {
                ForEach(monthDays, id: \.self) { day in
                    if day == nil {
                        Text("")
                    } else {
                        NavigationLink {
                            SentimentDetailView(date: day!)
                        } label: {
                            SentimentBlockContentMini(date: day!)
                        }
                    }
                }
            }
        }
    }

    struct WeekdayHeadings: View {
        var body: some View {
            HStack(alignment: .center) {
                ForEach(0..<7) { num in
                    Text(["S", "M", "T", "W", "T", "F", "S"][num])
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }

    var body: some View {
        VStack {
            BlockTitle(label: monthName)
            WeekdayHeadings()
            MonthGrid(startingDay: startingDay, days: daysInMonth)
        }
    }
}

struct MonthBlockView_Previews: PreviewProvider {
    static var previews: some View {
        MonthBlockView(date: Date.now)
    }
}
