import SwiftUI

struct MyNFTCell: View {
    let nft: NftDTOCart
    
    private enum Layout {
        static let rowHeight: CGFloat = 140
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let imageSize: CGFloat = 108
        static let imageCornerRadius: CGFloat = 12
        static let heartSize: CGFloat = 42
        
        static let contentWidth: CGFloat = 320
        static let priceBlockWidth: CGFloat = 95
        
        static let titleHeight: CGFloat = 22
        static let authorHeight: CGFloat = 20
        static let textSpacing: CGFloat = 4
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: Layout.spacing) {
                nftImage
                    .overlay(alignment: .topTrailing) {
                        Image(.favoritesInactive)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.appWhite)
                            .frame(width: Layout.heartSize, height: Layout.heartSize)
                    }
                
                VStack(alignment: .leading, spacing: Layout.textSpacing) {
                    Text(nft.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                        .frame(height: Layout.titleHeight, alignment: .top)
                    
                    StarRatingView(rating: nft.rating)
                    
                    Text(String(format: L10n.Catalog.collectionAuthor, nft.author ?? "Unknown"))
                        .font(.system(size: 13))
                        .kerning(-0.08)
                        .frame(height: Layout.authorHeight, alignment: .top)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: Layout.textSpacing) {
                    Text(L10n.Common.price)
                        .font(.system(size: 13))
                        .kerning(-0.08)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                    
                    Text("\(nft.price.formattedPrice) ETH")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
                .frame(width: Layout.priceBlockWidth, alignment: .leading)
            }
            .frame(width: Layout.contentWidth, alignment: .leading)
            
            Spacer()
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.verticalPadding)
        .frame(height: Layout.rowHeight)
    }
    
    @ViewBuilder
    private var nftImage: some View {
        NftPreviewImageView(
            imageURL: nft.images.first,
            size: Layout.imageSize,
            cornerRadius: Layout.imageCornerRadius
        )
    }
    
    private var loadingPlaceholder: some View {
        ProgressView()
            .frame(width: Layout.imageSize, height: Layout.imageSize)
    }
    
    private var imagePlaceholder: some View {
        Color.gray.opacity(0.2)
            .frame(width: Layout.imageSize, height: Layout.imageSize)
    }
}

private extension Double {
    var formattedPrice: String {
        formatted(
            .number
                .precision(.fractionLength(2))
        )
    }
}
