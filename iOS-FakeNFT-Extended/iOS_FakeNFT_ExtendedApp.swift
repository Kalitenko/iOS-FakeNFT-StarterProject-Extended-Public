import SwiftUI

@main
struct iOS_FakeNFT_ExtendedApp: App {
    var body: some Scene {
        WindowGroup {
            ServiceTestingView()
                .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
        }
    }
}
