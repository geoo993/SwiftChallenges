
public struct ColorComponents {
    var red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat
}

public extension UIColor {
    convenience init(hex: String?) {
        let normalizedHexString: String = UIColor.normalize(hex)
        var c: CUnsignedInt = 0
        Scanner(string: normalizedHexString).scanHexInt32(&c)
        self.init(red: UIColorMasks.redValue(c),
                  green: UIColorMasks.greenValue(c),
                  blue: UIColorMasks.blueValue(c),
                  alpha: UIColorMasks.alphaValue(c))
    }

    convenience init(colorArray array: NSArray) {
        if
            let r = array[0] as? CGFloat,
            let g = array[1] as? CGFloat,
            let b = array[2] as? CGFloat {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
        } else {
            self.init()
        }
    }

    convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start.utf16Offset(in: hexString))

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x0000_00FF) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }

    convenience init(rgba: String) {
        // https://raw.githubusercontent.com/yeahdongcn/UIColor-Hex-Swift/master/UIColorExtension.swift
        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var alpha: Double = 1.0

        if rgba.hasPrefix("#") {
            let start = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex = rgba.substring(from: start.utf16Offset(in: rgba))
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                let numElements = hex.count
                if numElements == 6 {
                    red = Double((hexValue & 0xFF0000) >> 16) / 255.0
                    green = Double((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = Double(hexValue & 0x0000FF) / 255.0
                } else if numElements == 8 {
                    red = Double((hexValue & 0xFF00_0000) >> 24) / 255.0
                    green = Double((hexValue & 0x00FF_0000) >> 16) / 255.0
                    blue = Double((hexValue & 0x0000_FF00) >> 8) / 255.0
                    alpha = Double(hexValue & 0x0000_00FF) / 255.0
                }
            }
        }
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    private convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
    }

    static var systemsBlueColor: UIColor {
        return UIColor(red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0)
    }
    
    static var selectedEmojiColor: UIColor {
        return UIColor(red: 38/255, green: 192/255, blue: 185/255, alpha: 1.0) 
    }
    
    static var selectedColor: UIColor {
        return UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    }
    
    static var shadowGray: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 230.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
    }
    
    static var random: UIColor {
        return UIColor(red: .rand(),
                       green: .rand(),
                       blue: .rand(),
                       alpha: 1.0)
    }

    var inverse: UIColor {
        return UIColor(red: 1.0 - self.redValue,
                       green: 1.0 - self.greenValue,
                       blue: 1.0 - self.blueValue,
                       alpha: self.alphaValue)
    }

    var redValue: CGFloat {
        return cgColor.components! [0]
    }

    var greenValue: CGFloat {
        return cgColor.components! [1]
    }

    var blueValue: CGFloat {
        return cgColor.components! [2]
    }

    var alphaValue: CGFloat {
        return cgColor.components! [3]
    }

    var rgbValues: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        return (red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }

    var components: ColorComponents {
        if cgColor.numberOfComponents == 2 {
            let cc = cgColor.components
            return ColorComponents(red: cc![0], green: cc![0], blue: cc![0], alpha: cc![1])
        } else {
            let cc = cgColor.components
            return ColorComponents(red: cc![0], green: cc![1], blue: cc![2], alpha: cc![3])
        }
    }

    var colorComponents: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = cgColor.components!

        switch components.count == 2 {
        case true: return (r: components[0], g: components[0], b: components[0], a: components[1])
        case false: return (r: components[0], g: components[1], b: components[2], a: components[3])
        }
    }

    private func hexDescription(includingAlpha: Bool = false) -> String {
        guard cgColor.numberOfComponents == 4 else {
            return "Color not RGB."
        }
        let a = cgColor.components!.map { Int($0 * CGFloat(255)) }
        let color = String(format: "%02x%02x%02x", a[0], a[1], a[2])
        if includingAlpha {
            let alpha = String(format: "%02x", a[3])
            return "\(color)\(alpha)"
        }
        return color
    }

    func hexDescription(withHash: Bool, includingAlpha: Bool = false) -> String {
        let hexDescription = self.hexDescription(includingAlpha: includingAlpha)
        return withHash ? "#" + hexDescription : hexDescription
    }

    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        // let rgb:Int = (Int)(r * 255)<<16 | (Int)(g * 255)<<8 | (Int)(b * 255)<<0
        // return NSString(format:"#%06x", rgb) as String
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xFF),
            Int(g * 0xFF),
            Int(b * 0xFF)
        )
    }

    fileprivate enum UIColorMasks: CUnsignedInt {
        case redMask = 0xFF00_0000
        case greenMask = 0x00FF_0000
        case blueMask = 0x0000_FF00
        case alphaMask = 0x0000_00FF

        static func redValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 24) / 255.0
        }

        static func greenValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
        }

        static func blueValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
        }

        static func alphaValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat(value & alphaMask.rawValue) / 255.0
        }
    }

    fileprivate static func normalize(_ hex: String?) -> String {
        guard var hexString = hex else {
            return "00000000"
        }
        if let cssColor = ColorsCSS.cssToHexDictionairy[hexString.uppercased()] {
            return cssColor.count == 8 ? cssColor : cssColor + "ff"
        }
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        let hasAlpha = hexString.count > 7
        if !hasAlpha {
            hexString += "ff"
        }
        return hexString
    }

    fileprivate static func hexFromCssName(_ cssName: String) -> String {
        let key = cssName.uppercased()
        if let hex = ColorsCSS.cssToHexDictionairy[key] {
            return hex
        }
        return cssName
    }

    static func cssNameFromHex(_ hexValue: String?) -> String {
        guard var hexString = hexValue else {
            return "00000000"
        }
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        return ColorsCSS.cssToHexDictionairy.firstKeyForValue(forValue: hexString.uppercased()) ?? "1"
    }

    static var colorNamesFromCSSLibrary: [String] {
        return ColorsCSS.cssToHexDictionairy.map { $0.key }.sorted()
    }
}
