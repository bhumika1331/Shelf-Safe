//  SwiftUIView.swift
//  shelfSafe
//
//  Created by user@61 on 22/02/25.
//

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct ListView: View {
    @Query(sort: \ProductList.name, order: .forward) var lists: [ProductList]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(lists) { list in
                    NavigationLink(destination: ProductListView(list: list)) {
                        Text(list.name)
                            .font(.headline)
                            .padding()
                        
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle(Text("Lists"))
        }
    }
}


#Preview {
    if #available(iOS 17.0, *) {
        ListView()
        
    } else {
        
    }
}
