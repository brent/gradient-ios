//
//  LinePlot.swift
//  Gradient
//
//  Created by Brent Meyer on 3/14/22.
//

import SwiftUI

struct LinePlot: View {
    let values: [Int]
    let entry: Entry

    var gradientColors: [Color] {
        GradientGenerator().generate(steps: 100)
    }

    var averageSentimentColor: Color {
        let average = getAverage(for: values)
        return gradientColors[average - 1]
    }

    var entrySentimentColor: Color {
        gradientColors[entry.wrappedSentiment - 1]
    }

    func getAverage(for values: [Int]) -> Int {
        let total = values.reduce(0) { $0 + $1 }
        return total/values.count
    }

    func getRelativePointPosition(for sentimentValue: Int, in parentWidth: Double) -> Double {
        let position = (Double(sentimentValue) / 100) * parentWidth
        return position
    }

    struct Tooltip: View {
        enum TooltipOrientation {
            case top, bottom
        }

        var label: String = "Label"
        var bgColor: Color = .white
        var textColor: Color = .black
        var cornerRadius: Double = 4
        var pointerPosition: TooltipOrientation = .bottom

        struct TooltipLabel: View {
            var label: String
            var bgColor: Color
            var cornerRadius: Double

            var body: some View {
                Text(label.uppercased())
                    .fontWeight(.bold)
                    .foregroundColor(.black.opacity(0.5))
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(bgColor)
                    .cornerRadius(cornerRadius)
            }
        }

        struct TooltipPointer: View {
            var orientation: TooltipOrientation
            var bgColor: Color

            var tooltipOffset: Double {
                switch(orientation) {
                case .bottom:
                    return -5
                case .top:
                    return 5
                }
            }

            var body: some View {
                Rectangle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(bgColor)
                    .cornerRadius(2)
                    .rotationEffect(.degrees(45))
                    .offset(y: tooltipOffset)
            }
        }

        var body: some View {
            VStack(alignment: .center, spacing: 0) {
                switch pointerPosition {
                case .bottom:
                    TooltipLabel(label: label, bgColor: bgColor, cornerRadius: cornerRadius)
                    TooltipPointer(orientation: .bottom, bgColor: bgColor)
                case .top:
                    TooltipPointer(orientation: .top, bgColor: bgColor)
                    TooltipLabel(label: label, bgColor: bgColor, cornerRadius: cornerRadius)
                }
            }
        }
    }

    struct LinePlotPoint: View {
        enum PlotPointType {
            case avg, today
        }

        var type: PlotPointType
        var pointColor: Color

        struct LinePlotCircle: View {
            var color: Color

            var body: some View {
                Circle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(color)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 3)
                            .fill(.white)
                    }
            }
        }

        var body: some View {
            VStack(alignment: .center, spacing: 8) {
                switch type {
                case .avg:
                    LinePlotCircle(color: pointColor)
                    Tooltip(label: "Avg", pointerPosition: .top)
                case .today:
                    Tooltip(label: "Today")
                    LinePlotCircle(color: pointColor)
                }
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: geometry.frame(in: .local).width, height: 8)
                    .foregroundColor(.white)

                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 1, height: 16)
                    .foregroundColor(.white)
                    .position(
                        x: geometry.frame(in: .local).width / 2,
                        y: geometry.frame(in: .local).height / 2
                    )

                LinePlotPoint(type: .avg, pointColor: averageSentimentColor)
                    .position(
                        x: getRelativePointPosition(
                            for: getAverage(for: values),
                            in: geometry.frame(in: .local).width),
                        y: (geometry.frame(in: .local).height/2) + 22
                    )

                LinePlotPoint(type: .today, pointColor: entrySentimentColor)
                    .position(
                        x: getRelativePointPosition(
                            for: entry.wrappedSentiment,
                            in: geometry.frame(in: .local).width),
                        y: (geometry.frame(in: .local).height/2) - 22
                    )
            }
        }
    }
}

struct LineChart_Previews: PreviewProvider {
    static let entry = Entry()
    static var values: [Int] {
        (1...50).map { _ in
            Int.random(in: 1...100)
        }
    }

    static var previews: some View {
        LinePlot(
            values: values, entry: entry
        )
    }
}
