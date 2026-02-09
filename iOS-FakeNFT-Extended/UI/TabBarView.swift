import SwiftUI

struct TabBarView: View {
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
            CartView()
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
