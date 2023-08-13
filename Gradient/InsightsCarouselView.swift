//
//  InsightsCarouselView.swift
//  Gradient
//
//  Created by Brent Meyer on 5/13/22.
//

import SwiftUI

struct InsightsCarouselView: View {
    var entries: [Entry]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    InsightWidgetAverageColor(entries: Array(entries))
                        .frame(width: geometry.size.width / 2.5, height: geometry.size.height)

                    InsightWidgetAverageColor(entries: Array(entries))
                        .frame(width: geometry.size.width / 2.5, height: geometry.size.height)

                    InsightWidgetAverageColor(entries: Array(entries))
                        .frame(width: geometry.size.width / 2.5, height: geometry.size.height)
                }
                .padding()
            }
        }
    }
}

struct InsightsCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        let entries = [Entry(), Entry(), Entry()]
        InsightsCarouselView(entries: entries)
    }
}
