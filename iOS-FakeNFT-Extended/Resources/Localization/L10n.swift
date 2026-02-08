//
//  L10n.swift
//  iOS-FakeNFT-Extended
//
//  Created by Bogdan Kalitenko on 08.02.2026.
//

import Foundation

enum L10n {
    
    enum Common {
        static let close  = String(localized: "common.close")
        static let cancel = String(localized: "common.cancel")
        static let retry  = String(localized: "common.retry")
        static let price  = String(localized: "common.price")
    }
    
    enum TabBar {
        static let profile     = String(localized: "tabbar.profile")
        static let catalog     = String(localized: "tabbar.catalog")
        static let cart        = String(localized: "tabbar.cart")
        static let statistics  = String(localized: "tabbar.statistics")
    }
    
    enum Sort {
        static let title        = String(localized: "sort.title")
        static let byTitle      = String(localized: "sort.by_title")
        static let byNFTCount   = String(localized: "sort.by_nft_count")
        static let byPrice      = String(localized: "sort.by_price")
        static let byRating     = String(localized: "sort.by_rating")
        static let byName       = String(localized: "sort.by_name")
    }
    
    enum Catalog {
        static let collectionAuthor = String(localized: "catalog.collection_author")
    }
    
    enum Cart {
        static let totalToPay          = String(localized: "cart.total_to_pay")
        static let pay                 = String(localized: "cart.pay")
        static let choosePaymentMethod = String(localized: "cart.choose_payment_method")
        static let agreementText       = String(localized: "cart.agreement_text")
        static let userAgreement       = String(localized: "cart.user_agreement")
        static let successTitle        = String(localized: "cart.payment_success")
        static let backToCart          = String(localized: "cart.back_to_cart")
        static let emptyCart           = String(localized: "cart.empty")
    }
    
    enum Profile {
        static let myNFT            = String(localized: "profile.my_nft")
        static let favoriteNFT      = String(localized: "profile.favorite_nft")
        static let name             = String(localized: "profile.name")
        static let description      = String(localized: "profile.description")
        static let website          = String(localized: "profile.website")
        static let profilePhoto     = String(localized: "profile.photo")
        static let changePhoto      = String(localized: "profile.change_photo")
        static let deletePhoto      = String(localized: "profile.delete_photo")
        static let photoLink        = String(localized: "profile.photo_link")
        static let save             = String(localized: "profile.save")
        static let noNFT            = String(localized: "profile.no_nft")
        static let noFavoriteNFT    = String(localized: "profile.no_favorite_nft")
    }
    
    enum Statistics {
        static let nftCollection     = String(localized: "statistics.nft_collection")
        static let openUserWebsite   = String(localized: "statistics.open_user_website")
    }
    
    enum Alerts {
        static let paymentFailed      = String(localized: "alert.payment_failed")
        static let confirmLogout      = String(localized: "alert.confirm_logout")
        static let logout             = String(localized: "alert.logout")
        static let stay               = String(localized: "alert.stay")
        static let dataLoadFailed     = String(localized: "alert.data_load_failed")
        static let somethingWentWrong = String(localized: "alert.something_went_wrong")
        static let loginFailed        = String(localized: "alert.login_failed")
        static let okay               = String(localized: "alert.ok")
    }
    
    enum Confirmations {
        static let back                   = String(localized: "confirm.back")
        static let delete                 = String(localized: "confirm.delete")
        static let deleteFromCartMessage  = String(localized: "confirm.delete_from_cart_message")
    }
    
    enum Onboarding {
        static let explore                = String(localized: "onboarding.explore")
        static let exploreDescription     = String(localized: "onboarding.explore_description")
        static let collect                = String(localized: "onboarding.collect")
        static let collectDescription     = String(localized: "onboarding.collect_description")
        static let compete                = String(localized: "onboarding.compete")
        static let competeDescription     = String(localized: "onboarding.compete_description")
        static let whatsInside            = String(localized: "onboarding.whats_inside")
    }
    
    enum AppRating {
        static let notNow = String(localized: "rating.not_now")
        static let rate   = String(localized: "rating.rate")
    }
    
    enum Auth {
        static let login                  = String(localized: "auth.login")
        static let email                  = String(localized: "auth.email")
        static let password               = String(localized: "auth.password")
        static let signIn                 = String(localized: "auth.sign_in")
        static let forgotPassword         = String(localized: "auth.forgot_password")
        static let signUp                 = String(localized: "auth.sign_up")
        static let invalidCredentials     = String(localized: "auth.invalid_credentials")
        static let registration           = String(localized: "auth.registration")
        static let usernameTaken          = String(localized: "auth.username_taken")
        static let resetPassword          = String(localized: "auth.reset_password")
        static let resetPasswordAction    = String(localized: "auth.reset_password_action")
        static let resetPasswordSuccess   = String(localized: "auth.reset_password_success")
    }
    
    enum NFTDetails {
        static let addToCart          = String(localized: "nft.add_to_cart")
        static let openSellerWebsite  = String(localized: "nft.open_seller_website")
    }
    
    enum OldStrings {
        static let openNFT  = String(localized: "old.catalog.open_nft")
        static let network  = String(localized: "old.error.network")
        static let unknown  = String(localized: "old.error.unknown")
        static let `repeat` = String(localized: "old.error.repeat")
        static let title    = String(localized: "old.error.title")
    }
}
