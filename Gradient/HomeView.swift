//
//  HomeView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors:[SortDescriptor(\.date, order: .reverse)]) var entries: FetchedResults<Entry>
    @StateObject private var viewModel = ViewModel()

    private var showingCtaBinding: Binding<Bool> { Binding (
        get: { viewModel.getCtaVisibility(entries: self.entries) },
        set: { _ in }
    )}

    var entriesByMonth: [[Entry]] {
        viewModel.splitEntriesByMonth(entries)
    }

    var entriesPreviousMonths: [[Entry]] {
        viewModel.getPreviousMonthsEntries(from: entriesByMonth)
    }

    var entriesThisMonth: [Entry] {
        viewModel.getThisMonthsEntries(from: entriesByMonth)
    }

    var entriesEarlierThisMonth: [Entry] {
        viewModel.getEntriesEarlierInMonth(from: entriesThisMonth)
    }

    var entriesThisWeek: [Entry] {
        viewModel.getThisWeeksEntries(from: entriesThisMonth)
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
                                viewModel.showSettings()
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

                if showingCtaBinding.wrappedValue {
                    VStack {
                        Spacer()

                        Button {
                            let warningTimeCutoff = Calendar.current.date(from: DateComponents(hour: 20))
                            let timeNowDateComponents = Calendar.current.dateComponents([.hour], from: Date.now)
                            let timeNow = Calendar.current.date(from: timeNowDateComponents)

                            guard let timeNow = timeNow else { return }
                            guard let warningTimeCutoff = warningTimeCutoff else { return }

                            if timeNow < warningTimeCutoff {
                                viewModel.showTimeWarning()
                            } else {
                                viewModel.showAddSentimentSheet()
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
        .sheet(isPresented: $viewModel.showingAddSentimentSheet) {
            NewEntryView()
        }
        .sheet(isPresented: $viewModel.showingSettings) {
            SettingsView()
        }
        .alert("Are you sure?", isPresented: $viewModel.showingWarning) {
            Button {
                viewModel.showAddSentimentSheet()
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
        HomeView()
    }
}
