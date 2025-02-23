//
//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import Foundation
import SwiftUICore

@available(iOS 17.0, *)
struct CardView: View {
    let title: String
    let subtitle: String
    let icon : String

var body: some View {
    HStack(spacing: 10) {
        Image(systemName: icon)
            .font(.title)
            .foregroundColor(.green)
        
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .bold()
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        
        Spacer()
        
    }
    
    .padding()
    .frame(height: 90)
    .background(
        RoundedRectangle(cornerRadius: 15)
            .fill(Color(.systemBackground))
            .shadow(radius: 2)
        
        
    )
}
}

