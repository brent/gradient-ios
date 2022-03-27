//
//  HomeView-ViewModel.swift
//  Gradient
//
//  Created by Brent Meyer on 3/13/22.
//

import Foundation
import SwiftUI

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var showingAddSentimentSheet = false
        @Published var showingSettings = false
        @Published var showingWarning = false
        @Published var showingLogButton = true
        @Published var showingCtaButton = true

        typealias EntriesResults = FetchedResults<Entry>
        typealias EntriesByMonth = [[Entry]]
        typealias EntriesArray = [Entry]

        func showAddSentimentSheet() {
            showingAddSentimentSheet = true
        }

        func showTimeWarning() {
            showingWarning = true
        }

        func showSettings() {
            showingSettings = true
        }

        func showCtaButton() {
            showingCtaButton = true
        }

        func hideCtaButton() {
            showingCtaButton = false
        }

        func splitEntriesByMonth(_ entries: EntriesResults) -> EntriesByMonth {
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

        func getPreviousMonthsEntries(from entries: EntriesByMonth) -> EntriesByMonth {
            guard !entries.isEmpty else { return [] }

            let mostRecentEntry = entries[0][0]
            let mostRecentEntryMonth = Calendar.current.dateComponents([.month], from: mostRecentEntry.wrappedDate).month
            let currentMonth = Calendar.current.dateComponents([.month], from: Date.now).month

            if mostRecentEntryMonth == currentMonth {
                return Array(entries[1..<entries.count])
            } else {
                return entries
            }
        }

        func getThisMonthsEntries(from entries: EntriesByMonth) -> EntriesArray {
            guard !entries.isEmpty else { return [] }

            let mostRecentMonthEntries = entries[0]
            let mostRecentEntry = mostRecentMonthEntries[0]
            let mostRecentEntryMonth = Calendar.current.dateComponents([.month], from: mostRecentEntry.wrappedDate).month
            let currentMonth = Calendar.current.dateComponents([.month], from: Date.now).month

            if mostRecentEntryMonth == currentMonth {
                return mostRecentMonthEntries
            } else {
                return []
            }
        }

        func getEntriesEarlierInMonth(from entries: EntriesArray) -> EntriesArray {
            guard !entries.isEmpty else { return [] }

            var entriesBeforeThisWeek = [Entry]()

            let thisWeek = Calendar.current.dateComponents([.weekOfYear], from: Date.now).weekOfYear

            guard let thisWeek = thisWeek else { return [] }

            entries.forEach { entry in
                let entryWeekNum = Calendar.current.dateComponents([.weekOfYear], from: entry.wrappedDate).weekOfYear

                guard let entryWeekNum = entryWeekNum else { return }

                if entryWeekNum != thisWeek && entryWeekNum != thisWeek - 1 {
                    entriesBeforeThisWeek.append(entry)
                }
            }

            return entriesBeforeThisWeek
        }

        func getThisWeeksEntries(from entries: EntriesArray) -> EntriesArray {
            guard !entries.isEmpty else { return [] }

            let thisWeek = Calendar.current.dateComponents([.weekOfYear], from: Date.now).weekOfYear
            var thisWeekEntries = [Entry]()

            entries.forEach { entry in
                let entryWeek = Calendar.current.dateComponents([.weekOfYear], from: entry.wrappedDate).weekOfYear

                if entryWeek == thisWeek {
                    thisWeekEntries.append(entry)
                }
            }

            return thisWeekEntries
        }

        func getLastWeeksEntries(from entries: EntriesArray) -> EntriesArray {
            guard !entries.isEmpty else { return [] }

            let thisWeek = Calendar.current.dateComponents([.weekOfYear], from: Date.now).weekOfYear
            var lastWeekEntries = [Entry]()

            guard let thisWeek = thisWeek else { return [] }

            entries.forEach { entry in
                let entryWeek = Calendar.current.dateComponents([.weekOfYear], from: entry.wrappedDate).weekOfYear

                guard let entryWeek = entryWeek else { return }

                if entryWeek == thisWeek - 1 {
                    lastWeekEntries.append(entry)
                }
            }

            return lastWeekEntries
        }

        func getCtaVisibility(entries: EntriesResults) -> Bool {
            entries.isEmpty || !Calendar.current.isDateInToday(entries[0].wrappedDate)
        }

        func setCtaVisibility(entries: EntriesResults) {
            if entries.isEmpty || !Calendar.current.isDateInToday(entries[0].wrappedDate) {
                showCtaButton()
            } else {
                hideCtaButton()
            }
        }
    }
}
