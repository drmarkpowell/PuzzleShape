//
//  Grid.swift
//  PuzzlePieces
//
//  Created by Mark Powell on 10/20/24.
//

import SwiftUI

public struct Grid: Shape {
    public func path(in rect: CGRect) -> Path {
        Path { path in
            for y in stride(from: 0.0, to: rect.height + 1, by: rect.height / 16.0) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: rect.width, y: y))
            }
            for x in stride(from: 0.0, to: rect.width + 1, by: rect.width / 16.0) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: rect.height))
            }
        }
    }
}
