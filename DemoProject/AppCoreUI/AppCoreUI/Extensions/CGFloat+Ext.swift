public extension CGFloat {

    static func width(ofDevice device: DeviceType) -> (width: CGFloat, exponent: CGFloat) {
        switch device {
        case .iPhone4, .iPhone4s, .iPhone5, .iPhone5s, .iPhone5c, .iPhoneSE:
            return (320.0, 0.3125)
        case .iPhone6, .iPhone6s, .iPhone7, .iPhone8, .iPhoneX, .iPhoneXS:
            return (375.0, 0.36621094)
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneXR, .iPhoneXSMax:
            return (414.0, 0.40429688)
        case .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4,
             .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPadAir, .iPadAir2, .iPadPro9_7:
            return (768.0, 0.75)
        case .iPadPro10_5:
            return (834.0, 0.81445312)
        case .iPadPro12_9, .iPadPro2_12_9:
            return (1024.0, 1.0)
        case .unrecognized, .appleTV, .appleTV4K, .simulator:
            return (0.0, 0.0)
        }
    }

    static func height(ofDevice device: DeviceType) -> (height: CGFloat, exponent: CGFloat) {
        switch device {
        case .iPhone4, .iPhone4s:
            return (480.0, 0.35139)
        case .iPhone5, .iPhone5s, .iPhone5c, .iPhoneSE:
            return (568.0, 0.41581259)
        case .iPhone6, .iPhone6s, .iPhone7, .iPhone8:
            return (667.0, 0.4992515)
        case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
            return (736.0, 0.53879941)
        case .iPhoneX, .iPhoneXS:
            return (812.0, 0.59443631)
        case .iPhoneXR, .iPhoneXSMax:
            return (896.0, 0.67065868)
        case .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4,
             .iPad2, .iPad3, .iPad4, .iPad5, .iPad6, .iPadAir, .iPadAir2, .iPadPro9_7:
            return (1024.0, 0.74963397)
        case .iPadPro10_5:
            return (1112.0, 0.81405564)
        case .iPadPro12_9, .iPadPro2_12_9:
            return (1366.0, 1.0)
        case .unrecognized, .appleTV, .appleTV4K, .simulator:
            return (0.0, 0.0)
        }
    }

    static func recommenedWidth(withReferencedDevice device: DeviceType,
                                       desiredWidth: CGFloat? = nil) -> CGFloat {
        let referencedDevice = CGFloat.width(ofDevice: device)
        let referencedDeviceWidth = desiredWidth ?? CGFloat.width(ofDevice: device).width
        let size = referencedDeviceWidth / referencedDevice.exponent
        let currentDevice = UIDevice.current.modelName
        let currentDeviceWidthExponent = CGFloat.width(ofDevice: currentDevice).exponent
        return size * currentDeviceWidthExponent
    }

    static func recommenedHeight(withReferencedDevice device: DeviceType,
                                        desiredHeight: CGFloat? = nil) -> CGFloat {
        let referencedDevice = CGFloat.height(ofDevice: device)
        let referencedDeviceHeight = desiredHeight ?? CGFloat.height(ofDevice: device).height
        let size = referencedDeviceHeight / referencedDevice.exponent
        let currentDevice = UIDevice.current.modelName
        let currentDeviceHeightExponent = CGFloat.height(ofDevice: currentDevice).exponent
        return size * currentDeviceHeightExponent
    }
}
