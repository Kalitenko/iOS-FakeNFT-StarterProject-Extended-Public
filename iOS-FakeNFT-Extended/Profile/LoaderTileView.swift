//
//  LoaderTileView.swift
//  iOS-FakeNFT-Extended
//

import SwiftUI

struct LoaderTileView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(uiColor: .appAlertBackground))
//            AppAlertBackground

            SpinnerBarsView(
                spinnerSize: 30,
                barWidth: 4,
                barHeight: 10,
                barCornerRadius: 2
            )
        }
        .frame(width: 82, height: 82)
    }
}

private struct SpinnerBarsView: View {
    let spinnerSize: CGFloat
    let barWidth: CGFloat
    let barHeight: CGFloat
    let barCornerRadius: CGFloat

    private let barsCount: Int = 8
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            ForEach(0..<barsCount, id: \.self) { barIndex in
                RoundedRectangle(cornerRadius: barCornerRadius, style: .continuous)
                    .fill(color(for: barIndex))
                    .frame(width: barWidth, height: barHeight)
                    .offset(y: -(spinnerSize / 2) + (barHeight / 2))
                    .rotationEffect(.degrees(Double(barIndex) * (360.0 / Double(barsCount))))
            }
        }
        .frame(width: spinnerSize, height: spinnerSize)
        .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
        .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: isAnimating)
        .onAppear { isAnimating = true }
        .accessibilityIdentifier("loader.spinner")
    }

    private func color(for barIndex: Int) -> Color {
        let opacities: [Double] = [1.0, 0.78, 0.62, 0.48, 0.36, 0.26, 0.18, 0.12]
        let safeIndex = barIndex % opacities.count
        return Color.black.opacity(opacities[safeIndex])
    }
}

// MARK: - Small helper: exact Figma hex to Color
private extension Color {
    init(figmaHex: UInt32, alpha: Double = 1.0) {
        let red = Double((figmaHex >> 16) & 0xFF) / 255.0
        let green = Double((figmaHex >> 8) & 0xFF) / 255.0
        let blue = Double(figmaHex & 0xFF) / 255.0
        self = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        LoaderTileView()
    }
}
