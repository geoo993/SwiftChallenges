//
//  TextUtilities.swift
//  StoryView
//
//  Created by Daniel Asher on 08/12/2017.
//  Copyright © 2017 LEXI LABS. All rights reserved.
//

import Foundation

public class TextUtilities {
 
    public static func measureTextWidth(text: String, forFont font: UIFont) -> CGFloat {
        let attributedText = NSAttributedString(
            string: text, attributes: [
                .font: font
        ])

        let frame = attributedText.boundingRect(
            with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity),
            options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return frame.width
    }

    public static func getTextRangeFrames(for ranges: [CountableRange<Int>], in string: String,
                                   with font: UIFont, ofWidth width: CGFloat) -> [CGRect] {
        let fontAttribute: [NSAttributedString.Key: Any] = [.font: font]
        let attributedText = NSAttributedString(string: string, attributes: fontAttribute)
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager() // not sure how expensive a call this is, might want to cache it
        let size = CGSize(width: CGFloat(width), height: CGFloat.infinity)
        let textContainer = NSTextContainer(size: size) // not sure how expensive a call this is, might want to cache it

        textContainer.lineFragmentPadding = 0 // needed so the left and right inset matches that of UILabel

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let boundingRects = ranges.map { range -> CGRect in
            let length = range.distance(from: range.startIndex, to: range.endIndex)
            let glyphRange = NSRange(location: range.lowerBound, length: length)
            return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        }
        return boundingRects
    }

    public static func getWordFramesByLine(for text: String, withFont font: UIFont,
                                           ofWidth width: CGFloat) -> ([[CGRect]]) {
        return TextUtilities.getWordsAndFramesByLine(for: text, withFont: font, ofWidth: width).frames
    }

    public static func getWordsAndFramesByLine(for text: String,
                                               withFont font: UIFont,
                                               ofWidth width: CGFloat) -> (words: [[String]], frames: [[CGRect]]) {
        var wordFramesByLine: [[CGRect]] = []
        var wordsByLine: [[String]] = []
        let fontAttribute: [NSAttributedString.Key: Any] =
            [.font: font]
        let attributedText = NSAttributedString(string: text, attributes: fontAttribute)
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager() // not sure how expensive a call this is, might want to cache it
        let size = CGSize(width: CGFloat(width), height: CGFloat.infinity)
        let textContainer = NSTextContainer(size: size) // not sure how expensive a call this is, might want to cache it

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let nsText = text as NSString
        let range = text.nsRange(fromStringIndex: text.startIndex ..< text.endIndex)
        let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        layoutManager.enumerateLineFragments(forGlyphRange: glyphRange) { _, _, textContainer, glyphRange, _ in
            var words: [String] = []
            var wordFrames: [CGRect] = []
            nsText.enumerateSubstrings(in: glyphRange, options: .byWords, using: { word, wordRange, _, _ in
                words.append(word ?? "")
                let wordFrame = layoutManager.boundingRect(forGlyphRange: wordRange, in: textContainer)
                wordFrames.append(wordFrame)
            })
            wordsByLine.append(words)
            wordFramesByLine.append(wordFrames)
        }
        return (wordsByLine, wordFramesByLine)
    }
    
    public static func getTextRangeFrames(withRanges: [Range<Int>],
                                          withAttributedText: NSAttributedString,
                                          withTextContainer: NSTextContainer) -> [CGRect] {
        let textStorage = NSTextStorage(attributedString: withAttributedText)
        let layoutManager = NSLayoutManager() // not sure how expensive a call this is, might want to cache it
        // let size = CGSize(width: withTextContainer.size.width, height: CGFloat.infinity)
        let textContainer = NSTextContainer(size: withTextContainer.size)
        textContainer.widthTracksTextView = withTextContainer.widthTracksTextView
        textContainer.heightTracksTextView = withTextContainer.heightTracksTextView
        textContainer.maximumNumberOfLines = withTextContainer.maximumNumberOfLines
        textContainer.lineBreakMode = withAttributedText.lineBreakMode

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let boundingRects = withRanges.map { range -> CGRect in
            let length = (range.upperBound - range.lowerBound)
            let glyphRange = NSRange(location: range.lowerBound, length: length)
            return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        }
        return boundingRects
    }
}
