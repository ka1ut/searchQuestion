import SwiftUI

struct ImageOK: View {
    var image: UIImage
    @Binding var showCapturedImage: Bool
    @Binding var questionText: String

    var body: some View {
        GeometryReader { geometry in
                    VStack {
                        HStack {
                            Spacer()
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2)
                            Spacer()
                        }
                        Text(questionText)
                    }
                }
        .navigationBarItems(leading: Button(action: {
            questionText = "お待ちください"
            showCapturedImage = false
        }) {
            HStack {
                Image(systemName: "arrow.backward")
                Text("戻る")
            }
        })
    }
}
