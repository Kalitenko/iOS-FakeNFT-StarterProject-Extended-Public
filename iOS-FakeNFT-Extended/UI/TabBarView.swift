import SwiftUI

struct TabBarView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.appBackground
        
        appearance.stackedLayoutAppearance.selected.iconColor = .appBlue
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.appBlue]
        
        appearance.stackedLayoutAppearance.normal.iconColor = .appTextPrimary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.appTextPrimary]
        
        appearance.shadowColor = .appSeparator
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            MockProfileView()
                .customBackground(color: .purple)
                .tabItem {
                    Label {
                        Text(L10n.TabBar.profile)
                    } icon: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
            NavigationStack {
                CatalogView(items: CatalogItem.mockItems)
                    .customBackground()
            }
            .tabItem {
                Label {
                    Text(L10n.TabBar.catalog)
                } icon: {
                    Image(systemName: "rectangle.stack.fill")
                }
            }
            MockCartView()
                .customBackground(color: .indigo)
                .tabItem {
                    Label {
                        Text(L10n.TabBar.cart)
                    } icon: {
                        Image(.cart)
                    }
                }
            MockStatisticsView()
                .customBackground(color: .cyan)
                .tabItem {
                    Label {
                        Text(L10n.TabBar.statistics)
                    } icon: {
                        Image(systemName: "flag.2.crossed.fill")
                    }
                }
        }
    }
}

#Preview {
    TabBarView()
}
