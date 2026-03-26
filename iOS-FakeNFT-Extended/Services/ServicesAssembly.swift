import Foundation

@Observable
@MainActor
final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage

    let commonProfileService: CommonProfileServiceProtocol
    let likesStore: LikesStore

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage

        let commonProfileService = CommonProfileService(networkClient: networkClient)
        self.commonProfileService = commonProfileService
        self.likesStore = LikesStore(commonProfileService: commonProfileService)
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var orderService: OrderServiceProtocol {
        OrderService(networkClient: networkClient)
    }

    var currencyService: CurrencyServiceProtocol {
        CurrencyService(networkClient: networkClient)
    }

    var paymentService: PaymentServiceProtocol {
        PaymentService(networkClient: networkClient)
    }

    var cartService: CartServiceProtocol {
        CartService(
            orderService: orderService,
            nftService: nftService,
            currencyService: currencyService,
            paymentService: paymentService
        )
    }

    var catalogService: CatalogServiceProtocol {
        CatalogService(
            networkClient: networkClient
        )
    }
    
    var commonOrderService: CommonOrderServiceProtocol {
        CommonOrderService(
            networkClient: networkClient
        )
    }
}
