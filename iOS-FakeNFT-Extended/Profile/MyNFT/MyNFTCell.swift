import SwiftUI

struct MyNFTCell: View {
    let nft: NftDTOCart
    
    private enum Layout {
        static let rowHeight: CGFloat = 140
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 16
        
        static let imageSize: CGFloat = 108
        static let imageCornerRadius: CGFloat = 12
        
        static let contentWidth: CGFloat = 320
        static let priceBlockWidth: CGFloat = 75
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: Layout.spacing) {
                
                ZStack {
                    nftImage
                }
                .overlay(alignment: .topTrailing) {
                    Image("favorites.inactive")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.appWhite)
                        .frame(width: 42, height: 42)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(nft.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                        .frame(height: 22, alignment: .top)
                    
                    StarRatingView(rating: nft.rating)
                    
                    Text(String(format: L10n.Catalog.collectionAuthor, nft.author ?? "Unknown"))
                        .font(.system(size: 13))
                        .kerning(-0.08)
                        .frame(height: 20, alignment: .top)
                        .foregroundStyle(Color(uiColor: .appTextPrimary))
                }
                
                Spacer(minLength: 0)
                
                VStack(alignment: .leading, spacing: 4) {
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
        .padding(.vertical, 16)
        .frame(height: Layout.rowHeight)
    }
    
    @ViewBuilder
    private var nftImage: some View {
        if let imageURL = nft.images.first {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                case .failure:
                    Color.gray.opacity(0.2)
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                @unknown default:
                    Color.gray.opacity(0.2)
                        .frame(width: Layout.imageSize, height: Layout.imageSize)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous))
        } else {
            Color.gray.opacity(0.2)
                .frame(width: Layout.imageSize, height: Layout.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius, style: .continuous))
        }
    }
}

private extension Double {
    var formattedPrice: String {
        formatted(
            .number
                .precision(.fractionLength(2))
                .locale(Locale(identifier: "ru_RU"))
        )
    }
}
