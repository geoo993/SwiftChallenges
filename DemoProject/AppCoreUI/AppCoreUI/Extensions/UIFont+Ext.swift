//
//  UIFont+Ext.swift
//  ViperCore
//
//  Created by GEORGE QUENTIN on 23/02/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
public enum FamilyName: String {
    // Font Family: ABeeZee
    case aBeeZeeItalic = "ABeeZee-Italic"
    case aBeeZeeRegular = "ABeeZee-Regular"

    // Font Family: Montserrat
    case montserratRegular = "Montserrat-Regular"
    case montserratMedium = "Montserrat-Medium"
    case montserratItalic = "Montserrat-Italic"
    case montserratBold = "Montserrat-Bold"

    // Font Family: Quicksand
    case quicksandRegular = "Quicksand-Regular"
    case quicksandMedium = "Quicksand-Medium"
    case quicksandBold = "Quicksand-Bold"

    // Font Family: SanFrancisco
    case sanFranciscoDisplayRegular = "SanFranciscoDisplay-Regular"
    case sanFranciscoDisplayMedium = "SanFranciscoDisplay-Medium"
    case sanFranciscoDisplayBold = "SanFranciscoDisplay-Bold"

    case sanFranciscoTextRegular = "SanFranciscoText-Regular"
    case sanFranciscoTextMedium = "SanFranciscoText-Medium"
    case sanFranciscoTextBold = "SanFranciscoText-Bold"
}

extension UIFont {
    public convenience init?(name: FamilyName, size: CGFloat) {
        self.init(name: name.rawValue, size: size)
    }

    /// returns true if the font symbolicTraits contains .traitBold
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    /// returns true if the font symbolicTraits contains .traitItalic
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

    /// Makes a copy of the font modifying it with the trait parameter.
    /// - Parameter traits: pass option set of traits to modify the copied font.
    /// - Returns: the copied font with modified traits.
    public func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) // size 0 means keep size as it is
    }

    public func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    public func nonBold() -> UIFont {
        if isBold {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitBold])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        } else {
            return self
        }
    }

    public func nonItalic() -> UIFont {
        if isItalic {
            var fontAtrAry = fontDescriptor.symbolicTraits
            fontAtrAry.remove([.traitItalic])
            let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
            return UIFont(descriptor: fontAtrDetails!, size: 0)
        } else {
            return self
        }
    }

    public func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

    public func reduceSize(by size: CGFloat) -> UIFont {
        return (pointSize - size) > 0 ? withSize(pointSize - size) : self
    }
    
    // https://medium.com/@joncardasis/dynamic-text-resizing-in-swift-3da55887beb3
    /**
     Will return the best font conforming to the descriptor which will fit in the provided bounds.
     */
    static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
        let constrainingDimension = min(bounds.width, bounds.height)
        let properBounds = CGRect(origin: .zero, size: bounds.size)
        var attributes = additionalAttributes ?? [:]
        
        let infiniteBounds = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
        var bestFontSize: CGFloat = constrainingDimension
        
        for fontSize in stride(from: bestFontSize, through: 0, by: -1) {
            let newFont = UIFont(descriptor: fontDescriptor, size: fontSize)
            attributes[.font] = newFont
            
            let currentFrame = text.boundingRect(with: infiniteBounds, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
            
            if properBounds.contains(currentFrame) {
                bestFontSize = fontSize
                break
            }
        }
        return bestFontSize
    }
    
    static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> UIFont {
        let bestSize = bestFittingFontSize(for: text, in: bounds, fontDescriptor: fontDescriptor, additionalAttributes: additionalAttributes)
        return UIFont(descriptor: fontDescriptor, size: bestSize)
    }
    
}
