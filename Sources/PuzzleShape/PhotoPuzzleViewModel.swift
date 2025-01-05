//
//  PhotoPuzzleViewModel.swift
//  PuzzlePieces
//
//  Created by Mark Powell on 10/27/24.
//

import UIKit

@Observable
public class PhotoPuzzleViewModel {
    public let image: UIImage
    public let numPieces: Int
    public let rows: Int
    public let columns: Int
    public var aspectRatio: Double
    public let viewWidth = 300.0
    public let viewHeight: Double
    public var pieces: [LoosePiece] = []

    // landspace images clip left of center
    public let centerXOffset: Double
    // portrait images clip above center
    public let centerYOffset: Double
    public let width: Double
    public let height: Double

    public let maxLength: Double
    public let scale: Double
    public let spacing: Double

    public init(image: UIImage, numPieces: Int) {
        self.image = image
        self.numPieces = numPieces
        width = image.size.width
        height = image.size.height
        let aspect = width / height
        viewHeight = viewWidth / aspect
        aspectRatio = aspect
        centerXOffset = aspect > 1 ? (viewWidth - viewHeight) * 0.5 : 0.0
        centerYOffset = aspect < 1 ? (viewHeight - viewWidth) * 0.5 : 0.0

        rows = aspect >= 1 ? Int(Double(numPieces).squareRoot().rounded()) : Int(ceil(Double(numPieces).squareRoot()))
        columns = aspect >= 1 ? Int(ceil(Double(numPieces).squareRoot())) : Int(Double(numPieces).squareRoot().rounded())
        maxLength = Double(max(rows, columns))

        scale =  1.0 / maxLength
        spacing = 199.2 - 83.19048 * maxLength + 14.60714 * maxLength * maxLength - 0.9166667 * maxLength * maxLength * maxLength

        for i in 1...numPieces {
            let column = Int(Double(i - 1).truncatingRemainder(dividingBy: Double(columns))) + 1
            let row = Int(Double(i - 1) / Double(columns)) + 1
//            let onLeft = i <= numPieces / 2
//            let pieceVerticalSpacing = viewHeight / Double(numPieces / 2)
//            let yPosition = Double((i - 1) % (numPieces / 2)) + pieceVerticalSpacing + centerYOffset
            let piece = LoosePiece(
                id: UUID(),
                row: row,
                column: column,
                xHomePosition: xOffset(column),
                yHomePosition: yOffset(row),
                rotationDegrees: isOdd(row + column) ? 90.0 : 0.0
//                ,dragPosition: CGPoint(x: onLeft ? -viewWidth * 0.5 : viewWidth * 0.5, y: yPosition)
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

    /// used these data  x: [2, 3, 4, 5, 6] y: [ 84, 56, 42, 33.5, 28]
    /// x: number of puzzle pieces across, y: amount of spacing in points
    /// generated cubic regression fit using https://mycurvefit.com
    public func spacingBasedOnCubicRegressionFit(_ x: Double) -> Double {
        return 199.2 - 83.19048 * x + 14.60714 * x * x - 0.9166667 * x * x * x
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


