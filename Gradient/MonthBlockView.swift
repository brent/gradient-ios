//
//  MonthBlockView.swift
//  Gradient
//
//  Created by Brent Meyer on 1/9/22.
//

import SwiftUI

struct MonthBlockView: View {
    var entries: [Entry]

    init(entries: [Entry]) {
        self.entries = entries.reversed()
    }

    var datesInMonth: [Date] {
        getAllDaysInMonth(for: entries[0].wrappedDate)
    }

    var startingDay: Int {
        getFirstDayOfMonth(for: datesInMonth[0])
    }

    var monthName: String {
        getMonthName(for: entries[0].wrappedDate)
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
        let datesInMonth: [Date]
        let entries: [Entry]

        var monthCells: [MonthGridCell] {
            var monthArray = [MonthGridCell]()

            for _ in 1..<startingDay {
                monthArray.append(MonthGridCell())
            }

            for date in datesInMonth {
                let dateDay = Calendar.current.component(.day, from: date)

                for (entriesIndex, entry) in entries.enumerated() {
                    let entryDay = Calendar.current.component(.day, from: entry.wrappedDate)

                    if dateDay == entryDay {
                        monthArray.append(MonthGridCell(entry: entry))
                        break
                    }

                    if entriesIndex == entries.count - 1 {
                        monthArray.append(MonthGridCell(date: date))
                    }
                }
            }

            return monthArray
        }

        struct MonthGridCell: View {
            let date: Date?
            let entry: Entry?

            init(entry: Entry) {
                self.date = nil
                self.entry = entry
            }

            init(date: Date) {
                self.date = date
                self.entry = nil
            }

            init() {
                self.date = nil
                self.entry = nil
            }

            var dateNum: String? {
                if let date = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "d"
                    return formatter.string(from: date)
                }

                return ""
            }

            var body: some View {
                if entry != nil {
                    NavigationLink {
                        SentimentDetailView(entry: entry!)
                    } label: {
                        SentimentBlockContentMini(entry: entry!)
                    }
                } else if date != nil {
                    Text(dateNum ?? "")
                        .frame(minWidth: 44, maxWidth: .infinity, minHeight: 44, maxHeight: .infinity)
                        .background(.gray.opacity(0.15))
                        .foregroundColor(.primary.opacity(0.33))
                        .cornerRadius(8)
                } else {
                    Text("")
                }
            }
        }

        let gridLayout: [GridItem] = Array(repeating: .init(.flexible()), count: 7)

        var body: some View {
            LazyVGrid(columns: gridLayout) {
                ForEach(0..<monthCells.count) { index in
                    monthCells[index]
                    /*
                    if index < startingDay - 1 {
                        Text("")
                    } else if monthEntries[index] != nil {
                        NavigationLink {
                            SentimentDetailView(entry: monthEntries[index] ?? Entry())
                        } label: {
                            SentimentBlockContentMini(entry: monthEntries[index] ?? Entry())
                        }
                    } else {
                        Text("\(index)")
                    }
                    */
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
            MonthGrid(startingDay: startingDay, datesInMonth: datesInMonth, entries: entries)
        }
    }
}

struct MonthBlockView_Previews: PreviewProvider {
    static var previews: some View {
        MonthBlockView(entries: [Entry()])
    }
}
