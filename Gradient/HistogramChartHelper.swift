//
//  HistogramChartHelper.swift
//  Gradient
//
//  Created by Brent Meyer on 2/7/22.
//

import Foundation

struct HistogramChartHelper {
    let minValue: Int
    let maxValue: Int
    let bucketSize: Int
    var data = [HistogramBucket]()

    init(values: [Int]) {
        self.minValue = 1
        self.maxValue = 100
        self.bucketSize = 10
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
