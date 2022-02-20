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

    struct HistogramChart: View {
        let values: [Int]
        let entry: Entry
        let label: String

        var chartHelper: HistogramChartHelper {
            HistogramChartHelper(values: self.values)
        }

        var body: some View {
            GeometryReader { geometry in
                VStack {
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(chartHelper.data) { datum in
                            let width = (geometry.frame(in: .local).width / CGFloat(chartHelper.data.count)) - 8
                            //let height = (geometry.size.height * CGFloat(datum.rawValues.count) / 100)
                            //let height = ((CGFloat(datum.rawValues.count)) * (geometry.frame(in: .global).height * 0.05))
                            let height = (geometry.frame(in: .local).height * 0.05) * CGFloat(datum.rawValues.count)

                            if (entry.wrappedSentiment >= datum.min) && (entry.wrappedSentiment <= datum.max) {
                                Rectangle()
                                    .fill(.white)
                                    .cornerRadius(4)
                                    .frame(width: width, height: height)
                            } else {
                                Rectangle()
                                    .fill(.black.opacity(0.25))
                                    .cornerRadius(4)
                                    .frame(width: width, height: height)
                            }
                        }
                    }

                    Text(label)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
        }
    }

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading) {
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
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            Spacer()

            if noteContent != "" {
                VStack(alignment: .leading) {
                    Text("Note".uppercased())
                        .font(.system(.subheadline))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary.opacity(0.66))
                        .padding(.bottom, 4)

                    Text(noteContent)
                        .font(.system(size: 20))
                        .foregroundColor(.primary.opacity(0.75))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical, 16)
                .background(.white)
            }
        }
        .background(bgColor)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            }
        }
    }
}

struct SentimentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SentimentDetailView(entry: Entry())
    }
}
