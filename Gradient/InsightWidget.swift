//
//  InsightWidget.swift
//  Gradient
//
//  Created by Brent Meyer on 5/12/22.
//

import SwiftUI

struct InsightWidget<Content>: View where Content: View {
    var entries: [Entry]
    let widgetChart: Content
    let chartLabel: Content

    init(entries: [Entry], @ViewBuilder widgetChart: () -> Content, @ViewBuilder chartLabel: () -> Content) {
        self.entries = entries
        self.widgetChart = widgetChart()
        self.chartLabel = chartLabel()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 4)

            VStack {
                widgetChart
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                chartLabel
            }
            .padding(.horizontal, 16)
            .padding([.top, .bottom], 12)
        }
    }
}

struct InsightWidgetAverageColorChart: View {
    var entries: [Entry]
    let gradientColors = GradientGenerator().generate(steps: 100)

    struct AverageColor {
        let name: String
        let color: Color

        init(color: Color) {
            self.color = color
            self.name = color.description.subString(from: 1, to: 7)
        }
    }

    func getAverageColor(from entries: [Entry], with colors: [Color]) -> AverageColor {
        let sentimentSum = Int(entries.reduce(0) { partialResult, entry in
            partialResult + entry.sentiment
        })

        let averageSentiment = Double(sentimentSum / entries.count)
        return AverageColor(color: colors[Int(averageSentiment.rounded())])
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .foregroundColor(getAverageColor(from: entries, with: gradientColors).color)
            Text(getAverageColor(from: entries, with: gradientColors).name)
                .foregroundColor(.black)
        }
    }
}

struct InsightWidgetAverageColor: View {
    var entries: [Entry]

    var body: some View {
        InsightWidget(entries: entries) {
           // InsightWidgetAverageColorChart() requires entries
           // entries is not in scope here
        } chartLabel: {
            Text("Label")
        }

    }
}

struct InsightWidget_Previews: PreviewProvider {
    static var previews: some View {
        let entries = [Entry(), Entry(), Entry()]

        InsightWidget(entries: entries) {
            Text("Chart here")
        } chartLabel: {
            Text("Chart label")
        }
    }
}
