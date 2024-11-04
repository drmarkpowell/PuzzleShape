//
//  PhotoPuzzle.swift
//  PuzzlePieces
//
//  Created by Mark Powell on 10/27/24.
//

import SwiftUI

public struct PhotoPuzzle: View {
    @State var image: UIImage?
    @State var viewModel: PhotoPuzzleViewModel?

    public var body: some View {
        VStack {
            if let image, let viewModel {
                PhotoPuzzleBoard(image: image, viewModel: viewModel)
                Text("Caption")
            } else {
                ProgressView()
            }
        }
        .task {
            image = UIImage(named: "landscape", in: .module, compatibleWith: nil)
            if let image {
                viewModel = PhotoPuzzleViewModel(image: image, numPieces: 5)
            }
        }
    }
}

#Preview {
    PhotoPuzzle()
}

public struct PhotoPuzzleBoard: View {
    @State private var showWholeImage = false
    let image: UIImage
    let viewModel: PhotoPuzzleViewModel

    public var body: some View {

        ZStack {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: viewModel.viewWidth, height: viewModel.viewHeight)

                ForEach(viewModel.pieces, id: \.self) { piece in
                        PuzzlePiece()
                        //center the shape within the rectangular image
                            .offset(
                                x: viewModel.centerXOffset,
                                y: viewModel.centerYOffset
                            )
                            .scale(viewModel.scale)
                        //rotate every other piece to fit the pieces together
                            .rotation(
                                Angle(degrees: piece.rotationDegrees),
                                anchor: .center
                            )
                        //position each piece where it belongs
                            .offset(x: piece.xOffset, y: piece.yOffset)

                }
                .frame(width: viewModel.viewWidth, height: viewModel.viewHeight)
                .blendMode(.destinationOut)
            }
            .compositingGroup()

            ForEach(viewModel.pieces, id: \.self) { piece in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: viewModel.viewWidth, height: viewModel.viewHeight)
                    .clipShape(
                        PuzzlePiece()
                        //center the shape within the rectangular image
                            .offset(
                                x: viewModel.centerXOffset,
                                y: viewModel.centerYOffset
                            )
                            .scale(viewModel.scale)
                        //rotate every other piece to fit the pieces together
                            .rotation(
                                Angle(degrees: piece.rotationDegrees),
                                anchor: .center
                            )
                        //position each piece where it belongs
                            .offset(x: piece.xOffset, y: piece.yOffset)
                    )
            }
        }
    }
}
