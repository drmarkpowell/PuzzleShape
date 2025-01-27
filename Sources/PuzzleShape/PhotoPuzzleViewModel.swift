//
//  PhotoPuzzleViewModel.swift
//  PuzzlePieces
//
//  Created by Mark Powell on 10/27/24.
//

import UIKit

@Observable
public class PhotoPuzzleViewModel {
    public var image: UIImage
    public var numPieces: Int
    public private(set) var rows = 1
    public private(set) var columns = 1
    public var aspectRatio = 1.0
    public let viewWidth = 300.0
    public private(set) var viewHeight = 0.0
    public var pieces: [LoosePiece] = []

    // landscape images clip left of center h
    public private(set) var centerXOffset = 0.0
    // portrait images clip above center
    public private(set) var centerYOffset = 0.0
    public private(set) var width = 0.0
    public private(set) var height = 0.0

    public private(set) var maxLength = 0.0
    public private(set) var scale = 1.0
    public private(set) var spacing = 0.0

    var isTall: Bool { aspectRatio < 1 }

    public init(image: UIImage, numPieces: Int) {
        self.image = image
        self.numPieces = numPieces
        setup(image, numPieces)
    }

    public func update(image: UIImage, numPieces: Int) {
        self.image = image
        self.numPieces = numPieces
        setup(image, numPieces)
    }

    private func setup(_ image: UIImage, _ numPieces: Int) {
        pieces.removeAll()
        width = image.size.width
        height = image.size.height
        let aspect = image.size.width / image.size.height
        viewHeight = viewWidth / aspect
        aspectRatio = aspect
        centerXOffset = aspect > 1 ? (viewWidth - viewHeight) * 0.5 : 0.0
        centerYOffset = aspect < 1 ? (viewHeight - viewWidth) * 0.5 : 0.0

        rows = aspect >= 1 ? Int(Double(numPieces).squareRoot().rounded()) : Int(ceil(Double(numPieces).squareRoot()))
        columns = aspect >= 1 ? Int(ceil(Double(numPieces).squareRoot())) : Int(Double(numPieces).squareRoot().rounded())
        maxLength = Double(max(rows, columns))

        scale =  1.0 / maxLength
        spacing = spacingBasedOnCubicRegressionFit(maxLength)

        var dragPositions: [CGPoint] = []
        for i in 1...numPieces {
            let halfNumPieces = ceil(Double(numPieces) * 0.5)
            let onLeft = i <= numPieces / 2
            let pieceVerticalSpacing = viewHeight / halfNumPieces
            let xPosition = (onLeft ? -viewWidth * 0.5 : viewWidth * 0.5)
            let yPosition = Double(i % Int(halfNumPieces)) * pieceVerticalSpacing - viewHeight * 0.35
            dragPositions.append(CGPoint(x: xPosition, y: yPosition))
        }
        dragPositions.shuffle()

        for i in 1...numPieces {
            let column = Int(Double(i - 1).truncatingRemainder(dividingBy: Double(columns))) + 1
            let row = Int(Double(i - 1) / Double(columns)) + 1
            let piece = LoosePiece(
                id: UUID(),
                row: row,
                column: column,
                xHomePosition: xOffset(column),
                yHomePosition: yOffset(row),
                rotationDegrees: isOdd(row + column) ? 90.0 : 0.0,
                dragPosition: CGPoint(
                    x: dragPositions[i - 1].x - xOffset(column),
                    y: dragPositions[i - 1].y - yOffset(row)
                )
            )
            pieces.append(piece)
        }
    }

    public func xOffset(_ column: Int) -> Double {
        spacing * (Double(column) - 0.5 - Double(columns) * 0.5)
    }

    public func yOffset(_ row: Int) -> Double {
        spacing * (Double(row) - 0.5 - Double(rows) * 0.5)
    }

    public func isOdd(_ val: Int) -> Bool {
        val % 2 == 1
    }

    /// used these data
    /// landscape: x: [2, 3, 4, 5, 6] y: [ 84, 56, 42, 33.5, 28]
    /// portrait x: [2, 3, 4, 5, 6] y: [ 112, 76, 56, 45, 32]
    /// x: number of puzzle pieces across, y: amount of spacing in points
    /// generated cubic regression fit using https://mycurvefit.com
    public func spacingBasedOnCubicRegressionFit(_ x: Double) -> Double {
        if isTall {
            return 271.2 - 117.4286 * x + 21.92857 * x * x - 1.5 * x * x * x
        } else {
            return 199.2 - 83.19048 * x + 14.60714 * x * x - 0.9166667 * x * x * x
        }
    }

    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }

    public func closestPieceIndex(_ location: CGPoint) -> Int {
        var minDistance = 1_000_000.0
        var closest = 0
        for i in 0..<pieces.count {
            let piecePoint = CGPoint(
                x: viewWidth * 0.5 + pieces[i].xHomePosition + pieces[i].dragPosition.x,
                y: viewHeight * 0.5 + pieces[i].yHomePosition + pieces[i].dragPosition.y
            )
            let distance = CGPointDistance(from: piecePoint, to: location)
            if distance < minDistance {
                minDistance = distance
                closest = i
            }
        }
        return closest
    }
}


public extension UIImage {
    // Return new image that is either 4:3 or 3:4, padded if necessary to the ratio
    func pad() -> UIImage {
        let idealAspectRatio = 4.0 / 3.0
        var width = size.width
        var height = size.height
        let tall = width < height
        let aspectRatio = tall ? height / width : width / height
        if tall { // a tall image
            if aspectRatio < idealAspectRatio {
                // not tall enough, pad height
                height = width * idealAspectRatio
            } else {
                // not wide enough, pad width
                width = height / idealAspectRatio
            }
        } else { // a wide image
            if aspectRatio < idealAspectRatio {
                // not wide enough, pad width
                width = height * idealAspectRatio
            } else {
                // not tall enough, pad height
                height = width / idealAspectRatio
            }
        }
        let paddedImageSize = CGSize(width: width, height: height)
        // Draw and return the resized UIImage
        print("actual aspect ratio: \(width / height)")
        let renderer = UIGraphicsImageRenderer(size: paddedImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: paddedImageSize
            ))
        }

        return scaledImage
    }
}
