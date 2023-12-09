import SwiftUI

struct ContentView: View {
    @State private var showingCamera = false
    @State private var image: UIImage?
    @State var showCapturedImage = false

    var body: some View {
        NavigationView {
            VStack {
                if showCapturedImage, let image = image {
                                ImageOK(image: image)
                }else{
                    Button(action : {
                        showingCamera = true
                    }){
                        Text("カメラを起動")
                    }
                    .sheet(isPresented: $showingCamera, onDismiss: checkImage ,content: {
                        CameraView(showingCamera: $showingCamera, image: $image)
                    })
                }
                
            }
        }
    }
    func checkImage() {
        if image != nil {
            showCapturedImage = true
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
