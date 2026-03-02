import SwiftUI

struct TabBarViewCart: View {
    @Environment(ServicesAssembly.self) var servicesAssembly

    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        L10n.TabBar.catalog,
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
            CartView(viewModel: CartViewModel(cartService: servicesAssembly.cartService))
                .tabItem {
                    Label {
                        Text(L10n.TabBar.cart)
                    } icon: {
                        Image(.cart)
                    }
                }
        }
        .tint(.appBlue)
    }
}
