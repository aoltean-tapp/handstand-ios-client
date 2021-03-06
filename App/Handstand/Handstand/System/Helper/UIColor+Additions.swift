//
//  UIColor+Additions.swift
//  Handstand
//
//  Created by science on 8/3/17.
//  Copyright © 2017 Handstand. All rights reserved.
//

import Foundation

public extension UIColor {
    
    public class func rgb(_ fromHex: Int) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public class func rgba(_ fromHex: Int, alpha: CGFloat) -> UIColor {
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

struct HSColorUtility {
    static func UIAppThemeGreenColor() -> UIColor {
        return UIColor.rgb(0x54CC96)
    }
    static func UIAppThemeErrorColor() -> UIColor {
        return UIColor.rgb(0xC91F37)
    }
    
    static func UIAppThemeLightGrayColor() -> UIColor {
        return UIColor.rgb(0xc9cdd9)
    }
    static func tabBarTextColor() -> UIColor {
        return UIColor.rgb(0x989899)
    }
    static func navigationBarTintColor() -> UIColor {
        return UIColor.init(red: 247, green: 247, blue: 247, alpha: 1.0)
    }
    static func tableViewBackgroundColor() -> UIColor {
        return UIColor.rgb(0xFAFAFA)
    }
    static func roundedRedColor() -> UIColor {
        return UIColor.rgb(0xDB5241)
    }
    static func getMarkerTagColor(with code:String?) -> UIColor {
        if let code = code {
            let hash = abs(code.hashValue)
            let colorNum = hash % (256*256*256)
            let red = colorNum >> 16
            let green = (colorNum & 0x00FF00) >> 8
            let blue = (colorNum & 0x0000FF)
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
        }
        return UIColor.black
    }
    static func globalSeparatorColor() -> UIColor {
        return UIColor.rgba(0xD4D4D4, alpha: 0.3)
    }
}
