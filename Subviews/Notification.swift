
//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI

@available(iOS 17, *)
struct Notification: View {
    let notification: ExpiringProductNotification
    var onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading) {
                Text(notification.title)
                    .font(.headline)
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
                
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(uiColor: .systemBackground)))
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.easeInOut(duration: 0.5), value: notification)
    }
    
}

@available(iOS 17.0, *)
struct ExpiringProductNotification: Equatable {
    let title: String
    let message: String
    let products: Products
    static func == (lhs: ExpiringProductNotification, rhs: ExpiringProductNotification) -> Bool {
        return lhs.products.id == rhs.products.id
    }
    
}
