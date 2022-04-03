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
            hue: 10/360,
            saturation: 85/100,
            brightness: 85/100
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
            let quarterColorComponents = HSBColorComponents(from: Color(
                hue: 40/360, saturation: 85/100, brightness: 75/100
            ))
            let middleColorComponents = HSBColorComponents(from: Color(
                hue: 55/360, saturation: 75/100, brightness: 75/100
            ))
            let endColorComponents = HSBColorComponents(from: self.endColor)

            let firstQuarterHueSteps = getValueSteps(startValue: startColorComponents.hue, endValue: quarterColorComponents.hue, steps: 25 - 1)
            let firstQuarterSaturationSteps = getValueSteps(startValue: startColorComponents.saturation, endValue: quarterColorComponents.saturation, steps: 25 - 1)
            let firstQuarterBrightnessSteps = getValueSteps(startValue: startColorComponents.brightness, endValue: quarterColorComponents.brightness, steps: 25 - 1)

            let secondQuarterHueSteps = getValueSteps(startValue: quarterColorComponents.hue, endValue: middleColorComponents.hue, steps: 25 - 1)
            let secondQuarterSaturationSteps = getValueSteps(startValue: quarterColorComponents.saturation, endValue: middleColorComponents.saturation, steps: 25 - 1)
            let secondQuarterBrightnessSteps = getValueSteps(startValue: quarterColorComponents.brightness, endValue: middleColorComponents.brightness, steps: 25 - 1)

            let secondHalfHueSteps = getValueSteps(startValue: middleColorComponents.hue, endValue: endColorComponents.hue, steps: 50 - 2)
            let secondHalfSaturationSteps = getValueSteps(startValue: middleColorComponents.saturation, endValue: endColorComponents.saturation, steps: 50 - 2)
            let secondHalfBrightnessSteps = getValueSteps(startValue: middleColorComponents.brightness, endValue: endColorComponents.brightness, steps: 50 - 2)

            gradientColors.append(startColor)
            for i in 0...22 {
                gradientColors.append(Color(hue: firstQuarterHueSteps[i], saturation: firstQuarterSaturationSteps[i], brightness: firstQuarterBrightnessSteps[i]))
            }
            gradientColors.append(Color(hue: quarterColorComponents.hue, saturation: quarterColorComponents.saturation, brightness: quarterColorComponents.brightness))
            for i in 0...22 {
                gradientColors.append(Color(hue: secondQuarterHueSteps[i], saturation: secondQuarterSaturationSteps[i], brightness: secondQuarterBrightnessSteps[i]))
            }
            gradientColors.append(Color(hue: middleColorComponents.hue, saturation: middleColorComponents.saturation, brightness: middleColorComponents.brightness))
            for i in 0...49 {
                gradientColors.append(Color(hue: secondHalfHueSteps[i], saturation: secondHalfSaturationSteps[i], brightness: secondHalfBrightnessSteps[i]))
            }
            gradientColors.append(endColor)

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
