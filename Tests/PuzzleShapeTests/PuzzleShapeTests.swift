import Testing
import UIKit
@testable import PuzzleShape

struct PuzzlePiecesTests {
    let landscape = UIImage(named: "landscape", in: .module, compatibleWith: nil)!
    let portrait = UIImage(named: "portrait", in: .module, compatibleWith: nil)!

    @Test func puzzleViewModelPieces() async throws {
        let puzzleViewModel = PhotoPuzzleViewModel(image: landscape, numPieces: 5)
        #expect(puzzleViewModel.rows == 2)
        #expect(puzzleViewModel.columns == 3)
        #expect(puzzleViewModel.pieces.count == 5)
        #expect(puzzleViewModel.pieces[1].row == 1) // upper center
        #expect(puzzleViewModel.pieces[1].column == 2)
        #expect(puzzleViewModel.pieces[3].row == 2) // lower left
        #expect(puzzleViewModel.pieces[3].column == 1)

        #expect(abs(puzzleViewModel.spacing - 56.3428191) < 0.000001)
        let spacing = 56.3428191
        let piece0 = puzzleViewModel.pieces[0] // upper left
        #expect(piece0.row == 1)
        #expect(piece0.column == 1)
        #expect(abs(piece0.xOffset + spacing) < 0.000001)
        #expect(abs(piece0.yOffset + spacing * 0.5) < 0.000001)

        let piece2 = puzzleViewModel.pieces[2] // upper right
        #expect(piece2.row == 1)
        #expect(piece2.column == 3)
        #expect(abs(piece2.xOffset - spacing) < 0.000001)
        #expect(abs(piece2.yOffset + spacing * 0.5) < 0.000001)

        let piece4 = puzzleViewModel.pieces[4] // lower center
        #expect(piece4.row == 2)
        #expect(piece4.column == 2)

        #expect(abs(piece4.xOffset - 0.0) < 0.000001)
        #expect(abs(piece4.yOffset) - spacing * 0.5 < 0.000001)
    }

    @Test func puzzleRowsColumns() async throws {
        let puzzleViewModel5 = PhotoPuzzleViewModel(image: landscape, numPieces: 5)
        #expect(puzzleViewModel5.rows == 2)
        #expect(puzzleViewModel5.columns == 3)

        let puzzleViewModel2 = PhotoPuzzleViewModel(image: portrait, numPieces: 5)
        #expect(puzzleViewModel2.rows == 3)
        #expect(puzzleViewModel2.columns == 2)

        let puzzleViewModel6 = PhotoPuzzleViewModel(image: portrait, numPieces: 6)
        #expect(puzzleViewModel6.rows == 3)
        #expect(puzzleViewModel6.columns == 2)

        let puzzleViewModel7 = PhotoPuzzleViewModel(image: landscape, numPieces: 7)
        #expect(puzzleViewModel7.rows == 3)
        #expect(puzzleViewModel7.columns == 3)

        let puzzleViewModel8 = PhotoPuzzleViewModel(image: landscape, numPieces: 8)
        #expect(puzzleViewModel8.rows == 3)
        #expect(puzzleViewModel8.columns == 3)

        let puzzleViewModel9 = PhotoPuzzleViewModel(image: landscape, numPieces: 9)
        #expect(puzzleViewModel9.rows == 3)
        #expect(puzzleViewModel9.columns == 3)
    }

}
