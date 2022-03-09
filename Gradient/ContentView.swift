//
//  ContentView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors:[SortDescriptor(\.date, order: .reverse)]) var entries: FetchedResults<Entry>

    @State private var showingAddSentimentSheet = false
    @State private var showingSettings = false
    @State private var showingWarning = false

    var entriesByMonth: [[Entry]] {
        guard !entries.isEmpty else { return [] }

        var allEntries = [[Entry]]()
        var monthEntries = [Entry]()
        var currentMonth = Calendar.current.dateComponents([.month], from: entries[0].wrappedDate).month

        entries.forEach { entry in
            let currentEntryMonth = Calendar.current.dateComponents([.month], from: entry.wrappedDate).month

            if currentEntryMonth == currentMonth {
                monthEntries.append(entry)
            } else {
                allEntries.append(monthEntries)
                monthEntries = []
                currentMonth = currentEntryMonth
                monthEntries.append(entry)
            }
        }

        if monthEntries.count > 0 { allEntries.append(monthEntries) }
        return allEntries
    }

    var entriesPreviousMonths: [[Entry]] {
        guard !entriesByMonth.isEmpty else { return [] }

        let mostRecentEntry = entriesByMonth[0][0]
        let mostRecentEntryMonth = Calendar.current.dateComponents([.month], from: mostRecentEntry.wrappedDate).month
        let currentMonth = Calendar.current.dateComponents([.month], from: Date.now).month

        if mostRecentEntryMonth == currentMonth {
            return Array(entriesByMonth[1..<entriesByMonth.count])
        } else {
            return entriesByMonth
        }
    }

    var entriesThisMonth: [Entry] {
        guard !entriesByMonth.isEmpty else { return [] }

        let mostRecentMonthEntries = entriesByMonth[0]
        let mostRecentEntry = mostRecentMonthEntries[0]
        let mostRecentEntryMonth = Calendar.current.dateComponents([.month], from: mostRecentEntry.wrappedDate).month
        let currentMonth = Calendar.current.dateComponents([.month], from: Date.now).month

        if mostRecentEntryMonth == currentMonth {
            return mostRecentMonthEntries
        } else {
            return []
        }
    }

    var entriesEarlierThisMonth: [Entry] {
        var entriesBeforeThisWeek = [Entry]()

        let thisWeek = Calendar.current.dateComponents([.weekOfYear], from: Date.now).weekOfYear

        entriesThisMonth.forEach { entry in
            let entryWeekNum = Calendar.current.dateComponents([.weekOfYear], from: entry.wrappedDate).weekOfYear

            if entryWeekNum != thisWeek {
                entriesBeforeThisWeek.append(entry)
            }
        }

        return entriesBeforeThisWeek
    }

    var entriesThisWeek: [Entry] {
        let thisWeek = Calendar.current.dateComponents([.weekOfYear], from: Date.now).weekOfYear
        var thisWeekEntries = [Entry]()

        entriesThisMonth.forEach { entry in
            let entryWeek = Calendar.current.dateComponents([.weekOfYear], from: entry.wrappedDate).weekOfYear

            if entryWeek == thisWeek {
                thisWeekEntries.append(entry)
            }
        }

        return thisWeekEntries
    }

    var body: some View {
        NavigationView {
            ZStack {
                if entries.count == 0 {
                    VStack {
                        Spacer()
                        Text("No entries")
                        Spacer()
                    }
                } else {
                    ScrollView {
                        HStack {
                            Spacer()
                            Button {
                                showingSettings = true
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()

                        if entriesThisWeek.count > 0 {
                            VStack(alignment: .center) {
                                BlockTitle(label: "This week")

                                ForEach(entriesThisWeek) { entry in
                                    NavigationLink {
                                        SentimentDetailView(entry: entry)
                                    } label: {
                                        SentimentBlockContentFull(entry: entry)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }

                        if entriesEarlierThisMonth.count > 0 {
                            VStack(alignment: .center) {
                                BlockTitle(label: "Earlier this month")

                                ForEach(entriesEarlierThisMonth) { entry in
                                    NavigationLink {
                                        SentimentDetailView(entry: entry)
                                    } label: {
                                        SentimentBlockContentCondensed(entry: entry)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding([.horizontal, .bottom])
                        }

                        if entriesPreviousMonths.count > 0 {
                            Divider()
                                .padding(.vertical)

                            ForEach(entriesPreviousMonths, id: \.self) { monthEntries in
                                MonthBlockView(entries: monthEntries)
                                    .padding()
                            }
                        }

                        Spacer(minLength: 64)
                    }
                    .navigationTitle("Home")
                    .navigationBarHidden(true)
                }

                if !Calendar.current.isDateInToday(entries[0].wrappedDate) {
                    VStack {
                        Spacer()

                        Button {
                            let warningTimeCutoff = Calendar.current.date(from: DateComponents(hour: 20)) ?? Date.now

                            if Date.now < warningTimeCutoff {
                                showingWarning = true
                            } else {
                                showingAddSentimentSheet = true
                            }
                        } label: {
                            Text("Log day")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                        }
                        .padding()
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 60)
                        .background(.white)
                        .cornerRadius(8)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 16, x: 0, y: 8)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showingAddSentimentSheet) {
            NewEntryView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .alert("Are you sure?", isPresented: $showingWarning) {
            Button {
                showingAddSentimentSheet = true
            } label: {
                Text("Yes")
            }

            Button {
            } label: {
                Text("Nevermind")
            }
        } message: {
            Text("We recommend logging your day when it's just about done and it looks like you might have some day left.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
