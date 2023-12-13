import SwiftUI


struct ContentView: View {
    @State private var showingCamera = false
    @State private var image: UIImage?
    @State var showCapturedImage = false
    @State var questionText = "お待ちください"
    
    var body: some View {
        NavigationView {
            VStack {
                if showCapturedImage, let image = image {
                    ImageOK(image: image, showCapturedImage: $showCapturedImage, questionText: $questionText)
                    Button("問いを作成する"){
                        questionText = "作成しています"
                        Task {
                            //APIからの戻り値をquestionTextに設定する
                            questionText = await VisionApiRequest(image: image)
                        }
                    }
                    
                }else{
                    Button(action : {
                        showingCamera = true
                    }){
                        
                        Text("カメラを起動")
                    }
                    .sheet(isPresented: $showingCamera,content: {
                        CameraView(showingCamera: $showingCamera, image: $image, showImage: $showCapturedImage)
                    })
                }
                
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
