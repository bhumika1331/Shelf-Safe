//
//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import Foundation
import SwiftUICore

extension Color {
    static func from(colorName: String) -> Color {
        switch colorName.lowercased() {
        case "red": return .red
        case "yellow": return .yellow
        case "green": return .green
        default: return .gray
        
        }
    }
}
