import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var showingCamera: Bool
    @Binding var image: UIImage?
    @Binding var showImage: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.showingCamera = false
            parent.showImage = true
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showingCamera = false
        }
    }
}

