//
//  LoosePiece.swift
//  Worthwhile
//
//  Created by Mark Powell on 1/5/25.
//
import Foundation

public struct LoosePiece: Identifiable, Hashable, Equatable {
    public var id = UUID()
    public let row: Int
    public let column: Int
    public let xHomePosition: Double
    public let yHomePosition: Double
    public let rotationDegrees: Double
    public var dragPosition: CGPoint = .zero
    public var closeToHome = false
    public var inPlace = false

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: LoosePiece, rhs: LoosePiece) -> Bool {
        lhs.id == rhs.id
    }
}
