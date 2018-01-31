//
//  HSFontUtilities.swift
//  Handstand
//
//  Created by Ranjith Kumar on 11/20/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

//Todo: Introuduce Enum here to avoid code redundant.
//Now keep it as it is. but it not best practise

struct HSFontFamily {
    //MARK: - AvenirNext
    static let AvenirNextRegular            = "AvenirNext-Regular"
    static let AvenirNextDemiBold           = "AvenirNext-DemiBold"
    static let AvenirNextMedium             = "AvenirNext-Medium"
    static let AvenirNextUltraLight         = "AvenirNext-UltraLight"
    static let AvenirNextItalic             = "AvenirNext-Italic"
    static let AvenirNextMediumItalic       = "AvenirNext-MediumItalic"
    static let AvenirNextUltraLightItalic   = "AvenirNext-UltraLightItalic"
    static let AvenirNextBold               = "AvenirNext-Bold"
    static let AvenirNextHeavy              = "AvenirNext-Heavy"
    static let AvenirNextBoldItalic         = "AvenirNext-BoldItalic"
    static let AvenirNextDemiBoldItalic     = "AvenirNext-DemiBoldItalic"
    static let AvenirNextHeavyItalic        = "AvenirNext-HeavyItalic"
    
    //MARK: - SourceSansPro
    static let SourceSansProBlack           = "SourceSansPro-Black"
    static let SourceSansProBlackIt         = "SourceSansPro-BlackIt"
    static let SourceSansProBold            = "SourceSansPro-Bold"
    static let SourceSansProBoldIt          = "SourceSansPro-BoldIt"
    static let SourceSansProExtraLight      = "SourceSansPro-ExtraLight"
    static let SourceSansProExtraLightIt    = "SourceSansPro-ExtraLightIt"
    static let SourceSansProIt              = "SourceSansPro-It"
    static let SourceSansProLight           = "SourceSansPro-Light"
    static let SourceSansProLightIt         = "SourceSansPro-LightIt"
    static let SourceSansProRegular         = "SourceSansPro-Regular"
    static let SourceSansProSemibold        = "SourceSansPro-Semibold"
    static let SourceSansProSemiboldIt      = "SourceSansPro-SemiboldIt"
}

struct HSFontUtilities {
    //MARK: - SourceSansPro
    static func sourceSansProBlack(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProBlack, size: size)!
    }
    static func sourceSansProBlackIt(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProBlackIt, size: size)!
    }
    static func sourceSansProBold(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProBold, size: size)!
    }
    static func sourceSansProBoldIt(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProBoldIt, size: size)!
    }
    static func sourceSansProExtraLight(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProExtraLight, size: size)!
    }
    static func sourceSansProIt(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProIt, size: size)!
    }
    static func sourceSansProLight(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProLight, size: size)!
    }
    static func sourceSansProLightIt(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProLightIt, size: size)!
    }
    static func sourceSansProRegular(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProRegular, size: size)!
    }
    static func sourceSansProSemibold(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProSemibold, size: size)!
    }
    static func sourceSansProSemiboldIt(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.SourceSansProSemiboldIt, size: size)!
    }
    
    
    //MARK: - AvenirNext
    static func avenirNextRegular(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextRegular, size: size)!
    }
    static func avenirNextDemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextDemiBold, size: size)!
    }
    static func avenirNextMedium(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextMedium, size: size)!
    }
    static func avenirNextUltraLight(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextUltraLight, size: size)!
    }
    static func avenirNextItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextItalic, size: size)!
    }
    static func avenirNextMediumItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextMediumItalic, size: size)!
    }
    static func avenirNextUltraLightItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextUltraLightItalic, size: size)!
    }
    static func avenirNextBold(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextBold, size: size)!
    }
    static func avenirNextHeavy(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextHeavy, size: size)!
    }
    static func avenirNextBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextBoldItalic, size: size)!
    }
    static func avenirNextDemiBoldItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextDemiBoldItalic, size: size)!
    }
    static func avenirNextHeavyItalic(size: CGFloat) -> UIFont {
        return UIFont(name: HSFontFamily.AvenirNextHeavyItalic, size: size)!
    }
}

