//
//  File.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import Foundation
import SwiftData
import UIKit

@available(iOS 17.0, *)
@Model
class Products {
    var id: UUID
    var name: String
    var category: String
    var purchaseDate: Date
    var expiryDate: Date
    var type: String
    var details: String
    var productList : ProductList?
    var receiptImage: Data?
    var cardImage: Data?
    var productImage: Data?
    
    init( name: String, category: String, purchaseDate: Date, expiryDate: Date, type: String, details: String, receiptImage: Data? = nil, cardImage: Data? = nil, productImage: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.expiryDate = expiryDate
        self.type = type
        self.details = details
        self.receiptImage = receiptImage
        self.cardImage = cardImage
        self.productImage = productImage
    }
}

@available(iOS 17.0, *)
@Model
class ProductList {
    @Attribute(.unique) var id : UUID
    var name : String
    var colorName : String
    var products : [Products] = []
    
    init(name: String, colorName: String) {
        self.id = UUID()
        self.name = name
        self.colorName = colorName
       
    }
    
}
