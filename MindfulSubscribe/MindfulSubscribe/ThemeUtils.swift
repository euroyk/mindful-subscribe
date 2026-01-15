//
//  SwiftUIView.swift
//  MindfulSubscribe
//
//  Created by Yodsaphat Kumwong on 20/11/2568 BE.
//

import SwiftUI

struct Theme {
    // Colors
    static let background = Color(red: 248/255, green: 247/255, blue: 244/255)
    static let headingText = Color(red: 130/255, green: 85/255, blue: 65/255)
    static let insightBox = Color(red: 209/255, green: 192/255, blue: 169/255)
    static let itemBox = Color(red: 237/255, green: 230/255, blue: 221/255)
    static let currentDayCircle = Color(red: 96/255, green: 148/255, blue: 26/255)
    
    // Fonts
    static func headingFont(size: CGFloat) -> Font {
        return .custom("Hoefler Text", size: size).weight(.black) // Serif font example
    }
    
    static func bodyFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight)
    }
    
    // Common Style modifiers
    static let cornerRadius: CGFloat = 20
}
