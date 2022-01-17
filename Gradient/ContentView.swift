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

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    ForEach(entries) { entry in
                        VStack {
                            Text("Date: \(entry.date!.formatted())")
                            Text("Sentiment: \(String(entry.sentiment))")
                            Text("Color: \(entry.color!)")
                            Text("Note: \(entry.note?.content ?? "No note")")
                        }
                    }

                    VStack(alignment: .center) {
                        BlockTitle(label: "This week")

                        ForEach(0..<7, id: \.self) { _ in
                            NavigationLink {
                                SentimentDetailView(date: Date())
                            } label: {
                                SentimentBlockContentFull(date: Date())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()

                    VStack(alignment: .center) {
                        BlockTitle(label: "Earlier this month")

                        ForEach(0..<7, id: \.self) { _ in
                            NavigationLink {
                                SentimentDetailView(date: Date())
                            } label: {
                                SentimentBlockContentCondensed(date: Date())
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding([.horizontal, .bottom])

                    Divider()
                        .padding(.vertical)

                    MonthBlockView(date: Date.now)
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                }
                .navigationTitle("Gradient")
                .navigationBarHidden(true)

                VStack {
                    Spacer()

                    Button {
                        showingAddSentimentSheet = true
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
        .sheet(isPresented: $showingAddSentimentSheet) {
            NewEntryView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
