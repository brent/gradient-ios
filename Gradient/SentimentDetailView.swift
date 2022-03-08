//
//  SentimentDetailView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/30/21.
//

import SwiftUI

struct SentimentDetailView: View, SentimentBlockContent {
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors:[SortDescriptor(\.date, order: .reverse)]) var allEntries: FetchedResults<Entry>

    let entry: Entry

    var bgColor: Color {
        if let uiColor = UIColor(hex: "#\(entry.wrappedColor)FF") {
            return Color(uiColor: uiColor)
        }

        return Color.red
    }

    var noteContent: String {
        if let content = entry.note?.content {
            return content
        }
        return ""
    }

    var entriesThisMonth: [Entry] {
        let thisMonth = Calendar.current.component(.month, from: entry.wrappedDate)

        var entries = [Entry]()

        allEntries.forEach { entry in
            let entryMonth = Calendar.current.component(.month, from: entry.wrappedDate)

            if entryMonth == thisMonth {
                entries.append(entry)
            }
        }

        return entries
    }

    var entriesThisYear: [Entry] {
        let thisYear = Calendar.current.component(.year, from: entry.wrappedDate)

        var entries = [Entry]()

        allEntries.forEach { entry in
            let entryYear = Calendar.current.component(.year, from: entry.wrappedDate)

            if entryYear == thisYear {
                entries.append(entry)
            }
        }

        return entries
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Button {
                 dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                        .frame(width: 44, height: 44, alignment: .leading)
                        .onTapGesture {
                            dismiss()
                        }
                }

                Text(getFullDate(from: entry.wrappedDate))
                    .foregroundColor(.white)
                    .font(.system(size: 24))

                Text(getDayOfWeekName(from: entry.wrappedDate))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("#\(entry.wrappedColor)")
                    .foregroundColor(.white)
                    .font(.system(size: 24))

                HistogramChart(
                    values: allEntries.map { $0.wrappedSentiment },
                    entry: entry,
                    label: "Today vs all time"
                )
                .frame(height: 200)

                if noteContent != "" {
                    VStack(alignment: .leading) {
                        Text("Note".uppercased())
                            .font(.system(.subheadline))
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Text(noteContent)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .background(bgColor)
    }
}

struct SentimentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SentimentDetailView(entry: Entry())
    }
}
