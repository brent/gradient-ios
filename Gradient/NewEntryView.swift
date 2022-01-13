//
//  NewEntryView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/30/21.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var sentiment: Double = 50
    @State private var showingAddNoteView = false
    @State private var noteContent = ""

    var gradientColors: [Color] {
        return GradientGenerator().generate(steps: 100)
    }

    var bgColor: Color {
        gradientColors[Int(sentiment)]
    }

    var body: some View {
        VStack {
            VStack {
                Image(systemName: "chevron.compact.down")
                    .font(.system(size: 48))
                    .foregroundColor(Color(white: 1, opacity: 0.5))
                    .padding(.top, 16)
                    .onTapGesture {
                        dismiss()
                    }

                Spacer()

                VStack {
                    Text("Hey")
                        .font(.system(size: 112))
                        .fontWeight(.bold)
                        .padding(.bottom)

                    Text("How was your day?")
                        .font(.system(size: 28))
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .foregroundColor(.white)

            VStack {
                Slider(value: $sentiment, in: 0...99)
                    .padding(.bottom)

                VStack {
                    Button {
                        showingAddNoteView = true
                    } label: {
                        Text(noteContent == "" ? "Add note" : "Edit note")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color(red: 0.46, green: 0.46, blue: 0.46))
                            .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 8)
                    .buttonStyle(PlainButtonStyle())

                    Button {
                        //
                    } label: {
                        Text("Done")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(bgColor)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .frame(maxWidth: .infinity)
            }
            .padding([.top, .horizontal])
            .background(.white)
        }
        .sheet(isPresented: $showingAddNoteView) {
            AddNoteView(noteContent: $noteContent)
        }
    }
}

struct LogSentimentView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView()
    }
}
