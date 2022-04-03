//
//  NewEntryView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/30/21.
//

import SwiftUI

struct NewEntryView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var sentiment: Double = 50
    @State private var showingAddNoteView = false
    @State private var noteContent = ""

    var gradientColors: [Color] {
        GradientGenerator().generate(steps: 100)
    }

    var sentimentColor: Color {
        gradientColors[Int(sentiment - 1)]
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

                HStack {
                    Rectangle()
                        .foregroundColor(gradientColors[0])
                    Rectangle()
                        .foregroundColor(gradientColors[99])
                }
            }
            .frame(maxWidth: .infinity)
            .background(sentimentColor)
            .foregroundColor(.white)

            VStack {
                Slider(value: $sentiment, in: 1...100, step: 1)
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
                        save()
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(sentimentColor)
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

    func save() {
        guard let todaysDate = getDateForToday() else {
            print("error generating today's date")
            return
        }

        let entry = Entry(context: moc)

        entry.id = UUID()
        entry.sentiment = Int64(sentiment.rounded())
        entry.date = todaysDate
        entry.createdAt = Date.now
        entry.updatedAt = Date.now

        let trimmedNoteContent = noteContent.trimmingCharacters(in: .whitespaces)
        if trimmedNoteContent != "" {
            let note = Note(context: moc)

            note.id = UUID()
            note.content = trimmedNoteContent
            note.createdAt = Date.now
            note.updatedAt = Date.now

            note.entry = entry
            entry.note = note
        }

        /*
        var additionalEntries = [Entry]()
        var additionalNotes = [Note]()

        for index in 1...100 {
            if Bool.random() {
                let entry = Entry(context: moc)
                let randomNum = Int.random(in: 1...100) - 1
                let date = Calendar.current.date(byAdding: .day, value: -index, to: Date.now)

                entry.id = UUID()
                entry.sentiment = Int64(randomNum)
                entry.date = date
                entry.createdAt = date
                entry.updatedAt = date

                if Bool.random() {
                    let note = Note(context: moc)

                    note.id = UUID()
                    note.content = "Note \(index)"
                    note.createdAt = date
                    note.updatedAt = date

                    note.entry = entry
                    entry.note = note

                    additionalNotes.append(note)
                }
                additionalEntries.append(entry)
            }
        }
        */

        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Couldn't save CoreData entities")
            }
        }
    }

    func getDateForToday() -> Date? {
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([
            .timeZone,
            .year,
            .month,
            .day,
            .weekday
        ], from: Date.now)

        let dateComponentsToSave = DateComponents(
            timeZone: todayDateComponents.timeZone,
            year: todayDateComponents.year,
            month: todayDateComponents.month,
            day: todayDateComponents.day,
            weekday: todayDateComponents.weekday
        )

        return calendar.date(from: dateComponentsToSave)
    }

    func getHexValue(from color: Color) -> String {
        let colorDesc = color.description
        let startIndex = colorDesc.index(colorDesc.startIndex, offsetBy: 1)
        let endIndex = colorDesc.index(colorDesc.endIndex, offsetBy: -3)

        return String(colorDesc[startIndex...endIndex])
    }
}

struct LogSentimentView_Previews: PreviewProvider {
    static var previews: some View {
        NewEntryView()
    }
}
