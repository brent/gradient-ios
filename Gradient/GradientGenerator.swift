//
//  GradientGenerator.swift
//  Gradient
//
//  Created by Brent Meyer on 1/10/22.
//

import Foundation
import SwiftUI

struct GradientGenerator {
    private struct ColorComponents {
        let red: Double
        let green: Double
        let blue: Double

        init(from color: Color) {
            let uiColor = UIColor(color)

            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0

            guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
                red = 0
                green = 0
                blue = 0
                return
            }

            red = r
            green = g
            blue = b
        }
    }

    let startColor: Color
    let endColor: Color

    init(startColor: Color, endColor: Color) {
        self.startColor = startColor
        self.endColor = endColor
    }

    init() {
        self.startColor = Color(red: 224/255, green: 175/255, blue: 48/255, opacity: 1)
        self.endColor = Color(red: 64/255, green: 173/255, blue: 126/255, opacity: 1)
    }

    func generate(steps: Int) -> [Color] {
        let startColorComponents = ColorComponents(from: self.startColor)
        let endColorComponents = ColorComponents(from: self.endColor)

        let redColorSteps = getColorSteps(startValue: startColorComponents.red, endValue: endColorComponents.red, steps: steps)
        let greenColorSteps = getColorSteps(startValue: startColorComponents.green, endValue: endColorComponents.green, steps: steps)
        let blueColorSteps = getColorSteps(startValue: startColorComponents.blue, endValue: endColorComponents.blue, steps: steps)

        var gradientColors = [Color]()

        for i in 0...(steps - 1) {
            gradientColors.append(Color(red: redColorSteps[i], green: greenColorSteps[i], blue: blueColorSteps[i], opacity: 1))
        }

        return gradientColors
    }

    private func getColorSteps(startValue: Double, endValue: Double, steps: Int) -> [Double] {
        let stepIncrement = (endValue - startValue) / Double(steps)
        let middleSteps = steps - 2

        var stepValues: [Double] = [startValue]

        for i in 1...middleSteps {
            let nextColor = startValue + (stepIncrement * Double(i))
            stepValues.append(nextColor)
        }

        stepValues.append(endValue)

        return stepValues
    }
}
