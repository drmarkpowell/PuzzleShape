import SwiftUI


struct PuzzleShape: View {
    @State private var endAmount: CGFloat = 0

    var body: some View {
        VStack {
            PuzzlePiece()
                .trim(from: 0, to: endAmount)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 200, height: 200)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        self.endAmount = 1
                    }
                }

            Image(systemName: "globe")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()
                .background(.green)
                .clipShape(PuzzlePiece())

            PuzzlePiece()
                .fill(.green)
                .frame(width: 200, height: 200)
                .overlay {
                    Grid()
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 200, height: 200)
                }
        }
        .padding()
    }
}

#Preview {
    PuzzleShape()
}
