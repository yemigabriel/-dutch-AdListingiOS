//
//  ChameleonStyleManager.swift
//  Dutch
//
//  Created by Apple on 02/07/2017.
//  Copyright © 2017 Doxa360. All rights reserved.
//

import Foundation
import ChameleonFramework

typealias Style = StyleManager

//MARK: - StyleManager
final class StyleManager {
    
    // MARK: - StyleManager
    
    static func setUpTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryTheme(), withSecondaryColor: theme(), usingFontName: font(), andContentStyle: content())
    }
    
    // MARK: - Theme
    
    static func primaryTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func theme() -> UIColor {
        return FlatWhite()
    }
    
    static func toolBarTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func tintTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func titleTextTheme() -> UIColor {
        return FlatWhite()
    }
    
    static func titleTheme() -> UIColor {
        return FlatCoffeeDark()
    }
    
    static func textTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func backgroudTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func positiveTheme() -> UIColor {
        return FlatRedDark()
    }
    
    static func negativeTheme() -> UIColor {
        return FlatRed()
    }
    
    static func clearTheme() -> UIColor {
        return UIColor.clear
    }
    
    // MARK: - Content
    
    static func content() -> UIContentStyle {
        return UIContentStyle.contrast
    }
    
    // MARK: - Font
    static func font() -> String {
        return UIFont(name: FontType.Primary.fontName, size: FontType.Primary.fontSize)!.fontName
    }
}

//MARK: - FontType
enum FontType {
    case Primary
}

extension FontType {
    var fontName: String {
        switch self {
        case .Primary:
            return "Avenir"
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .Primary:
            return 16
        }
    }
}
