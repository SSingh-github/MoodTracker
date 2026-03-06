//
//  Color.swift
//  MoodTracker
//
//  Created by Sukhpreet Singh on 05/03/26.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    
    let accent = Color("accentColor")
    let background = Color("backgroundColor")
    let primaryText = Color("primaryFont")
    let secondaryText = Color("secondaryFont")
    let shimmerBackground = Color("ShimmerColor")
}


