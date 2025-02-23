import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0,  *) {
                ContentView()
                    .modelContainer(for: [ProductList.self, Products.self])
            }else {
                
            }
            
        }
    }
}
