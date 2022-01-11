//
//  ContentView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/29/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddSentimentSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
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

                    HStack {
                        Spacer()

                        Button {
                            showingAddSentimentSheet = true
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(.purple)

                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 28))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(minWidth: 52, maxWidth: 64, minHeight: 52, maxHeight: 64)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 16, x: 0, y: 8)

                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingAddSentimentSheet) {
            LogSentimentView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
