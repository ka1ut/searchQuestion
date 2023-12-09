import SwiftUI

struct PhotoView: View{
    var image: UIImage?
    
    var body: some View{
        VStack{
            if let image = image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }else{
                Text("写真がありません")
            }
        }
    }
}
