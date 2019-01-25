//
//  LableSizer.swift
//  MoreMocha
//
//  Created by Casey Shimata on 1/23/19.
//  Copyright © 2019 Casey Shimata. All rights reserved.
//

import UIKit

extension UIFont {
    
    /**
     Will return the best font conforming to the descriptor which will fit in the provided bounds.
     */
    static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor, additionalAttributes: [NSAttributedString.Key: Any]? = nil) -> CGFloat {
//        let constrainingDimension = min(bounds.width, bounds.height)

        let constrainingDimension: CGFloat = 200.0

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

extension UILabel {
    
    /// Will auto resize the contained text to a font size which fits the frames bounds.
    /// Uses the pre-set font to dynamically determine the proper sizing
    func fitTextToBounds() -> UIFont? {
        guard let text = text, let currentFont = font else { return font }
        
        let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor, additionalAttributes: basicStringAttributes)
        font = bestFittingFont
        
        let deviceOrient = UIApplication.shared.statusBarOrientation
        
        if deviceOrient == .portrait {
            print("final best size port")
            print(currentFont.pointSize)

            return bestFittingFont
            
        }
        print("final best size land")
        print(currentFont.pointSize)

        return UIFont(name: bestFittingFont.fontName, size: bestFittingFont.pointSize * 0.5)
    }
    
    private var basicStringAttributes: [NSAttributedString.Key: Any] {
        var attribs = [NSAttributedString.Key: Any]()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = self.lineBreakMode
        paragraphStyle.lineSpacing = 0.75
        paragraphStyle.lineHeightMultiple = 0.0
        paragraphStyle.alignment = .center

        
        attribs[.paragraphStyle] = paragraphStyle
        
        return attribs
    }
}

