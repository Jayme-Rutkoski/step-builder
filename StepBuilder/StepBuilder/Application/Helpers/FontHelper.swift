//
//  FontHelper.swift
//  StepBuilder
//
//  Created by Jayme Rutkoski on 7/9/25.
//

import UIKit

class FontHelper {
    
    private static func getBaseFont(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size)
    }
    private static func getBaseBoldFont(size: CGFloat) -> UIFont {
        return .boldSystemFont(ofSize: size)
    }
    
    static func getFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Palatino", size: size) ?? getBaseFont(size: size)
    }
    static func getBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Palatino-Bold", size: size) ?? getBaseBoldFont(size: size)
    }
    static func getItalicFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Palatino-Italic", size: size) ?? getBaseBoldFont(size: size)
    }
    static func getBoldItalicFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Palatino-Bold-Italic", size: size) ?? getBaseBoldFont(size: size)
    }
}
