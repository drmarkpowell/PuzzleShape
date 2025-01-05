//
//  LoosePiece.swift
//  Worthwhile
//
//  Created by Mark Powell on 1/5/25.
//
import Foundation

public struct LoosePiece: Identifiable, Hashable {
    public var id = UUID()
    public let row: Int
    public let column: Int
    public let xHomePosition: Double
    public let yHomePosition: Double
    public let rotationDegrees: Double
    public var dragPosition: CGPoint = .zero

    public func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }

    public static func == (lhs: LoosePiece, rhs: LoosePiece) -> Bool {
        lhs.row == rhs.row && lhs.column == rhs.column
    }
}
