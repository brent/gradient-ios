//
//  SentimentDetailView.swift
//  Gradient
//
//  Created by Brent Meyer on 12/30/21.
//

import SwiftUI

struct SentimentDetailView: View, SentimentBlockContent {
    @Environment(\.dismiss) var dismiss

    let date: Date

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading) {
                Text(getFullDate(from: date))
                    .foregroundColor(.white)
                    .font(.system(size: 24))

                Text(getDayOfWeekName(from: date))
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("#52C7BB")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
            Spacer()
        }
        .background(bgColor)
        /*
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                 dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                        .frame(width: 44, height: 44)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
        */
    }
}

struct SentimentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SentimentDetailView(date: Date())
    }
}
