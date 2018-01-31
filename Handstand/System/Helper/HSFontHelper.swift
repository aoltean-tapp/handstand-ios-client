//
//  HSFontHelper.swift
//  Handstand
//
//  Created by science on 8/7/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

fileprivate let HS_FONT_AVENIR_NEXT_BOLD = "AvenirNextCondensed-Bold"
fileprivate let HS_FONT_AVENIR_NEXT_BOLD_ITALIC = "Avenir Next Bold Italic"
fileprivate let HS_FONT_AVENIR_NEXT_DEMI_BOLD = "Avenir Next Demi Bold"
fileprivate let HS_FONT_AVENIR_NEXT_DEMI_BOLD_ITALIC = "Avenir Next Demi Bold Italic"
fileprivate let HS_FONT_AVENIR_NEXT_HEAVY = "Avenir Next Heavy"
fileprivate let HS_FONT_AVENIR_NEXT_HEAVY_ITALIC = "Avenir Next Heavy Italic"
fileprivate let HS_FONT_AVENIR_NEXT_ITALIC = "Avenir Next Italic"
fileprivate let HS_FONT_AVENIR_NEXT_MEDIUM = "Avenir Next Medium"
fileprivate let HS_FONT_AVENIR_NEXT_MEDIUM_ITALIC = "Avenir Next Medium Italic"
fileprivate let HS_FONT_AVENIR_NEXT_REGULAR = "Avenir Next Regular"
fileprivate let HS_FONT_AVENIR_NEXT_ULTRA_LIGHT = "Avenir Next Ultra Light"
fileprivate let HS_FONT_AVENIR_NEXT_ULTRA_LIGHT_ITALIC = "Avenir Next Ultra Light Italic"

struct HSFontHelper {
    
    //MARK: - Fonts Utilities
    static func appThemeAVBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_BOLD, size: size)!
    }
    static func appThemeAVBoldItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_BOLD_ITALIC, size: size)!
    }
    static func appThemeAVDemiBoldFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_DEMI_BOLD, size: size)!
    }
    static func appThemeAVDemiBoldItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_DEMI_BOLD_ITALIC, size: size)!
    }
    static func appThemeAVHeavyFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_HEAVY, size: size)!
    }
    static func appThemeAVHeavyItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_HEAVY_ITALIC, size: size)!
    }
    static func appThemeAVItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_ITALIC, size: size)!
    }
    static func appThemeAVMediumFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_MEDIUM, size: size)!
    }
    static func appThemeAVMediumItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_MEDIUM_ITALIC, size: size)!
    }
    static func appThemeAVRegularFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_REGULAR, size: size)!
    }
    static func appThemeAVUltraLightFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_ULTRA_LIGHT, size: size)!
    }
    static func appThemeAVUltraLightItalicFont(with size: CGFloat) -> UIFont {
        return UIFont(name: HS_FONT_AVENIR_NEXT_ULTRA_LIGHT_ITALIC, size: size)!
    }
    
}
