import SwiftUI

struct ImageOK: View{
    var image : UIImage
    
    var body: some View{
        VStack{
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            Text("撮影成功！")
        }
    }
}
