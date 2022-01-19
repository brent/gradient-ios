//
//  SentimentDetailView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/30/21.
//

import SwiftUI

struct SentimentDetailView: View, SentimentBlockContent {
    @Environment(\.dismiss) var dismiss

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
