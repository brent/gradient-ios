//
//  HistogramChart.swift
//  Gradient
//
//  Created by Brent Meyer on 2/22/22.
//

import SwiftUI

struct HistogramChart: View {
    let values: [Int]
    let entry: Entry
    let label: String

    var chartHelper: HistogramChartHelper {
        HistogramChartHelper(values: self.values)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(chartHelper.data) { datum in
                        let width = (geometry.frame(in: .local).width / CGFloat(chartHelper.data.count)) - 8
                        //let height = (geometry.size.height * CGFloat(datum.rawValues.count) / 100)
                        //let height = ((CGFloat(datum.rawValues.count)) * (geometry.frame(in: .global).height * 0.05))
                        let height = (geometry.frame(in: .local).height * 0.025) * CGFloat(datum.rawValues.count)

                        if (entry.wrappedSentiment >= datum.min) && (entry.wrappedSentiment <= datum.max) {
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(4)
                                .frame(width: width, height: height)
                        } else {
                            Rectangle()
                                .fill(.black.opacity(0.25))
                                .cornerRadius(4)
                                .frame(width: width, height: height)
                        }
                    }
                }

                Text(label)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
        }
    }
}

struct HistogramChartHelper {
    let minValue: Int
    let maxValue: Int
    let bucketSize: Int
    var data = [HistogramBucket]()

    init(values: [Int]) {
        self.minValue = 1
        self.maxValue = 100
        self.bucketSize = 20
        self.data = getHistogram(for: values)
    }

    class HistogramBucket: Identifiable {
        let id = UUID()
        let min: Int
        let max: Int
        var frequency: Int
        var rawValues: [Int]

        init(min: Int, max: Int, frequency: Int) {
            self.min = min
            self.max = max
            self.rawValues = [Int]()
            self.frequency = frequency
        }
    }

    private func getFrequency(for values: [Int]) -> [Int: Int] {
        let mappedItems = values.map { ($0, 1) }
        return Dictionary(mappedItems, uniquingKeysWith: +)
    }

    private func getBuckets() -> [HistogramBucket] {
        var count = 1
        var bucketsArray = [[Int]]()
        var rangeArray = [Int]()
        var histogramBuckets = [HistogramBucket]()

        for num in minValue...maxValue {
            rangeArray.append(num)

            if count%bucketSize == 0 {
                bucketsArray.append(rangeArray)
                rangeArray = []
            }

            count += 1
        }

        for histogramRange in bucketsArray {
            let first = histogramRange[0]
            let last = histogramRange[histogramRange.count - 1]

            let histogramBucket = HistogramBucket(min: first, max: last, frequency: 0)

            histogramBuckets.append(histogramBucket)
        }

        return histogramBuckets
    }

    private func getHistogram(for values: [Int]) -> [HistogramBucket] {
        let frequencyData = getFrequency(for: values)
        let histogramBuckets = getBuckets()

        for sentimentValue in frequencyData.keys {
            for histogramBucket in histogramBuckets {
                if (sentimentValue >= histogramBucket.min) && (sentimentValue <= histogramBucket.max) {
                    if let frequency = frequencyData[sentimentValue] {
                        for _ in 0..<frequency {
                            histogramBucket.rawValues.append(sentimentValue)
                        }

                        histogramBucket.frequency += frequency
                    }
                }
            }
        }

        return histogramBuckets
    }
}

struct HistogramChart_Previews: PreviewProvider {
    static let entry = Entry()
    static var values: [Int] {
        (1...50).map { _ in
            Int.random(in: 1...100)
        }
    }

    static var previews: some View {
        HistogramChart(values: values, entry: entry, label: "chart")
    }
}
