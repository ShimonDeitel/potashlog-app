import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Theme.accent)
                    Text("Potashlog Pro")
                        .font(Theme.titleFont)
                        .foregroundStyle(Theme.textPrimary)
                    Text("Potashlog Pro unlocks Potashlog Pro features: 25+ free entries plus unlimited storage.")
                        .font(Theme.bodyFont)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    if let product = purchases.product {
                        Button {
                            Task {
                                await purchases.purchase()
                                if purchases.isPro { dismiss() }
                            }
                        } label: {
                            Text("Unlock for \(product.displayPrice) one-time")
                                .font(Theme.headlineFont)
                                .foregroundStyle(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .accessibilityIdentifier("purchaseButton")
                        .padding(.horizontal)
                    } else {
                        ProgressView()
                    }

                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButtonPaywall")

                    Button("Not now") { dismiss() }
                        .foregroundStyle(Theme.textSecondary)
                        .accessibilityIdentifier("dismissPaywallButton")
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
