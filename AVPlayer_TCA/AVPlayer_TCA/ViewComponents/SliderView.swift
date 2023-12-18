//
//  SliderView.swift
//  AVPlayer_TCA
//
//  Created by Vladislav Kliutko on 15.12.2023.
//

import SwiftUI

private enum Constants {

    enum Diminsions {
        static let sliderHandleDiameter: CGFloat = 16
        static let lineHeight: CGFloat = 4
    }
}

struct SliderView: View {
    /// The diameter of the movable point
    private let sliderHandleDiameter: CGFloat = Constants.Diminsions.sliderHandleDiameter
    private let lineHeight: CGFloat = Constants.Diminsions.lineHeight
    /// - Note: The height must not be less than the height of the highest element
    private var viewHeight: CGFloat {
        return max(sliderHandleDiameter, lineHeight)
    }

    private let maxValue: Double

    @State private var dragValue: Double = 0.0
    @Binding var value: Double

    var currentPointValue: Double {
        guard dragValue > 0 else { return value }
        return dragValue
    }

    init(maxValue: Double, value: Binding<Double>) {
        self.maxValue = maxValue
        _value = value
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Group {
                    RoundedRectangle(cornerRadius: lineHeight/2, style: .continuous)
                        .foregroundColor(ColorPalette.secondary)
                    let width = calculateLineWidth(with: proxy.size.width)
                    if width > 0 {
                        RoundedRectangle(cornerRadius: lineHeight/2, style: .continuous)
                            .frame(width: width)
                    }
                }
                .frame(height: lineHeight)

                Circle()
                    .frame(width: sliderHandleDiameter)
                    .offset(x: calculatePointOffset(with: proxy.size.width, pointDiameter: sliderHandleDiameter))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragValue = calculateSelectedValue(with: proxy.size.width, for: value.location.x)
                            }
                            .onEnded { value in
                                self.value = dragValue
                                dragValue = 0
                            }
                    )
            }
        }
        .frame(height: viewHeight)
    }
}

// MARK: - Private

private extension SliderView {

    // MARK: Calculation

    func calculateSelectedValue(with proxyWidth: CGFloat, for xCoordinate: Double) -> CGFloat {
        let percentage = Double(xCoordinate / proxyWidth)
        let value = max(.zero, percentage * maxValue)
        let roundedValue = round(value)

        return min(roundedValue, maxValue)
    }

    func calculatePointOffset(with proxyWidth: CGFloat, pointDiameter: CGFloat) -> CGFloat {
        let pointOffset = pointDiameter/2
        let maxOffset = proxyWidth - pointOffset
        let pointCenterHorizonalOffset = proxyWidth * CGFloat(currentPointValue / maxValue)
        let pointHorizonalOffset = pointCenterHorizonalOffset - pointOffset

        return min(max(pointHorizonalOffset, -pointOffset), maxOffset)
    }

    func calculateLineWidth(with proxyWidth: CGFloat) -> CGFloat {
        let step = proxyWidth/maxValue

        return max(min(step * currentPointValue, proxyWidth), .zero)
    }
}

#Preview {
    SliderView(maxValue: 90, value: .constant(12))
}
