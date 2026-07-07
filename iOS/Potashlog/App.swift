import SwiftUI

@main
struct PotashlogApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .preferredColorScheme(.dark)
                .onChange(of: purchases.isPro) { _, newValue in
                    store.isPro = newValue
                }
        }
    }
}
