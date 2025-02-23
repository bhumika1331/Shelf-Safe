//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import Foundation
import UIKit
import SwiftUICore
import SwiftUI

@available(iOS 17.0, *)

struct WarrantyProductCard: View {
    let products : Products
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(spacing: 15){
                
                if let imageData = products.productImage, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                }else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(products.name)
                        .font(.headline)
                        
                    Text("Category : \(products.category)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Purshase Date : \(products.purchaseDate, style: .date)")
                        .font(.subheadline)
                        
                    Text("Expire Date : \(products.expiryDate, style: .date)")
                        .font(.subheadline)
                        .foregroundColor(.red)
                    
                    Text("Days Remaining: \(daysRemaining(until: products.expiryDate))")
                        .font(.subheadline)
                        .foregroundColor(daysRemaining(until: products.expiryDate) > 7 ? .green : .red)
                    
                }
                Spacer()
            }
            
            HStack {
                if let billData = products.receiptImage, let billImage = UIImage(data: billData) {
                    Button(action: {
                        showFullscreenImage(image: billImage)}) {
                            Label("View Bill", systemImage:"doc.text.magnifyingglass")
                        }
                        .buttonStyle(.bordered)
                    
                }
            if let warrantyData = products.cardImage, let warrantyImage = UIImage(data: warrantyData) {
                Button(action: {
                    showFullscreenImage(image: warrantyImage)}) {
                        Label("View Warranty Card", systemImage:"doc.text.magnifyingglass")
                    }
                    .buttonStyle(.bordered)
                
            }
            Spacer()
            }

        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)).shadow(radius: 3))
        .padding(.vertical, 5)
    }

// Date Formatter

    private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    return formatter.string(from: date)
    }

    private func daysRemaining(until date: Date) -> Int {
    let remainingDays = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    return remainingDays
    }

@MainActor private func showFullscreenImage(image: UIImage) {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .black
    let vc = UIViewController()
    vc.view.addSubview(imageView)
    imageView.frame = vc.view.bounds
    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = scene.windows.first,
       let rootVC = window.rootViewController {
        rootVC.present(vc, animated: true)
    }
}
}
