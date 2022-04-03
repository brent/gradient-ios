//
//  GradientGenerator.swift
//  Gradient
//
//  Created by Brent Meyer on 1/10/22.
//

import Foundation
import SwiftUI

struct GradientGenerator {
    enum ColorSpace {
        case rgb, hsb
    }

    private struct RGBColorComponents {
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

    private struct HSBColorComponents {
        let hue: Double
        let saturation: Double
        let brightness: Double

        init(from color: Color) {
            let uiColor = UIColor(color)

            var h: CGFloat = 0
            var s: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0

            guard uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) else {
                hue = 0
                saturation = 0
                brightness = 0
                return
            }

            hue = h
            saturation = s
            brightness = s
        }
    }

    let startColor: Color
    let endColor: Color

    init(startColor: Color, endColor: Color) {
        self.startColor = startColor
        self.endColor = endColor
    }

    init() {
        self.startColor = Color(
            hue: 0/360,
            saturation: 75/100,
            brightness: 75/100
        )

        self.endColor = Color(
            hue: 90/360,
            saturation: 75/100,
            brightness: 75/100
        )
    }

    func generate(steps: Int) -> [Color] {
        var gradientColors = [Color]()
        let colorSpace: ColorSpace = .hsb

        if colorSpace == .rgb {
            let startColorComponents = RGBColorComponents(from: self.startColor)
            let endColorComponents = RGBColorComponents(from: self.endColor)

            let redColorSteps = getValueSteps(startValue: startColorComponents.red, endValue: endColorComponents.red, steps: steps)
            let greenColorSteps = getValueSteps(startValue: startColorComponents.green, endValue: endColorComponents.green, steps: steps)
            let blueColorSteps = getValueSteps(startValue: startColorComponents.blue, endValue: endColorComponents.blue, steps: steps)

            for i in 0...(steps - 1) {
                gradientColors.append(Color(red: redColorSteps[i], green: greenColorSteps[i], blue: blueColorSteps[i], opacity: 1))
            }
        } else if colorSpace == .hsb {
            let startColorComponents = HSBColorComponents(from: self.startColor)
            let middleColorComponents = HSBColorComponents(from: Color(
                hue: 55/360, saturation: 75/100, brightness: 75/100
            ))
            let endColorComponents = HSBColorComponents(from: self.endColor)

            let firstHalfHueSteps = getValueSteps(startValue: startColorComponents.hue, endValue: middleColorComponents.hue, steps: 50 - 2)
            let firstHalfSaturationSteps = getValueSteps(startValue: startColorComponents.saturation, endValue: middleColorComponents.saturation, steps: 50 - 2)
            let firstHalfBrightnessSteps = getValueSteps(startValue: startColorComponents.brightness, endValue: middleColorComponents.brightness, steps: 50 - 2)

            let secondHalfHueSteps = getValueSteps(startValue: middleColorComponents.hue, endValue: endColorComponents.hue, steps: 50 - 2)
            let secondHalfSaturationSteps = getValueSteps(startValue: middleColorComponents.saturation, endValue: endColorComponents.saturation, steps: 50 - 2)
            let secondHalfBrightnessSteps = getValueSteps(startValue: middleColorComponents.brightness, endValue: endColorComponents.brightness, steps: 50 - 2)

            for i in 0...((steps - 1) / 2) {
                gradientColors.append(Color(hue: firstHalfHueSteps[i], saturation: firstHalfSaturationSteps[i], brightness: firstHalfBrightnessSteps[i]))
            }

            for i in 0...((steps - 1) / 2) {
                gradientColors.append(Color(hue: secondHalfHueSteps[i], saturation: secondHalfSaturationSteps[i], brightness: secondHalfBrightnessSteps[i]))
            }

            /*
            let hueColorSteps = getValueSteps(startValue: startColorComponents.hue, endValue: endColorComponents.hue, steps: steps)
            let saturationColorSteps = getValueSteps(startValue: startColorComponents.saturation, endValue: endColorComponents.saturation, steps: steps)
            let brightnessColorSteps = getValueSteps(startValue: startColorComponents.brightness, endValue: endColorComponents.brightness, steps: steps)

            for i in 0...(steps - 1) {
                gradientColors.append(Color(hue: hueColorSteps[i], saturation: saturationColorSteps[i], brightness: brightnessColorSteps[i], opacity: 1))
            }
            */
        }

        return gradientColors
    }

    private func getValueSteps(startValue: Double, endValue: Double, steps: Int) -> [Double] {
        let stepIncrement = abs((startValue - endValue)) / Double(steps)
        //let middleSteps = steps - 2

        var stepValues: [Double] = [startValue]

        for i in 0...steps {
            var nextColor: Double {
                if startValue < endValue {
                    return startValue + (stepIncrement * Double(i))
                } else {
                    return startValue - (stepIncrement * Double(i))
                }
            }
            stepValues.append(nextColor)
        }

        stepValues.append(endValue)

        return stepValues
    }
}
