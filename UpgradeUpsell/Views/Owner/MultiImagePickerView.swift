////
////  MultiImagePickerView.swift
////  UpgradeUpsell
////
////  Created by zahra SHAHIN on 2023-10-30.
////

////
////struct MultiImagePickerView: View {
////    @Binding var selectedImages: [UIImage]
////    @State private var isImagePickerPresented = false
////
////    var body: some View {
////        VStack {
////            Button(action: {
////                isImagePickerPresented.toggle()
////            }) {
////                Text("Select Images")
////            }
////            .sheet(isPresented: $isImagePickerPresented) {
////                PhotoPicker(selectedImages: $selectedImages)
////            }
////
////            if !selectedImages.isEmpty {
////                ScrollView(.horizontal, showsIndicators: false) {
////                    HStack {
////                        ForEach(0..<selectedImages.count, id: \.self) { index in
////                            Image(uiImage: selectedImages[index])
////                                .resizable()
////                                .frame(width: 100, height: 100)
////                                .cornerRadius(10)
////                        }
////                    }
////                }
////            }
////        }
////    }
////}
////
////struct MultiImagePickerView_Previews: PreviewProvider {
////    static var previews: some View {
////        MultiImagePickerView(selectedImages: .constant([]))
////    }
////}
////
////struct PhotoPicker: UIViewControllerRepresentable {
////    @Binding var selectedImages: [UIImage]
////
////    func makeUIViewController(context: Context) -> PHPickerViewController {
////        var configuration = PHPickerConfiguration()
////        configuration.filter = .images
////
////        let picker = PHPickerViewController(configuration: configuration)
////        picker.delegate = context.coordinator
////        return picker
////    }
////
////    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
////
////    func makeCoordinator() -> Coordinator {
////        Coordinator(self)
////    }
////
////    class Coordinator: NSObject, PHPickerViewControllerDelegate {
////        var parent: PhotoPicker
////
////        init(_ parent: PhotoPicker) {
////            self.parent = parent
////        }
////
////        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
////            var selectedImages: [UIImage] = []
////            let group = DispatchGroup()
////
////            for result in results {
////                group.enter()
////                let itemProvider = result.itemProvider
////                if itemProvider.canLoadObject(ofClass: UIImage.self) {
////                    itemProvider.loadObject(ofClass: UIImage.self) { image, error in
////                        if let image = image as? UIImage {
////                            selectedImages.append(image)
////                        }
////                        group.leave()
////                    }
////                } else {
////                    group.leave()
////                }
////            }
////
////            group.notify(queue: .main) {
////                self.parent.selectedImages = selectedImages
////            }
////        }
////    }
////}
//
//newpicmulti >>
//struct MultiImagePickerView: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType
//    var onImagesPicked: ([UIImage]) -> Void
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        var parent: MultiImagePickerView
//
//        init(_ parent: MultiImagePickerView) {
//            self.parent = parent
//        }
//
//        func imagePickerController(
//            _ picker: UIImagePickerController,
//            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
//        ) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.onImagesPicked([uiImage])
//            } else {
//                parent.onImagesPicked([])
//            }
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.onImagesPicked([])
//        }
//    }
//}
///end
import SwiftUI
import UniformTypeIdentifiers


struct MultiImagePickerView: View {
    @Binding var selectedImages: [UIImage?]
    @State var selectedImageURL: URL?
    @State private var isDocumentPickerPresented = false

    var body: some View {
        VStack {
            if let selectedImageURL = selectedImageURL {
                Image(uiImage: UIImage(contentsOfFile: selectedImageURL.path) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
            } else {
                Text("Select an image from a file")
            }

            Button("Select Image") {
                isDocumentPickerPresented.toggle()
            }
            .sheet(isPresented: $isDocumentPickerPresented) {
                DocumentPickerViewController(selectedImageURL: $selectedImageURL, coordinator: DocumentPickerCoordinator(self))
            }
        }
    }
}

struct DocumentPickerViewController: UIViewControllerRepresentable {
    @Binding var selectedImageURL: URL?
    let coordinator: DocumentPickerCoordinator

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image], asCopy: true)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = coordinator
        return documentPicker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    var parent: MultiImagePickerView

    init(_ parent: MultiImagePickerView) {
        self.parent = parent
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let selectedImageURL = urls.first {
            self.parent.selectedImageURL = selectedImageURL
            // Convert the selected file into an image if it's an image file
            if let image = UIImage(contentsOfFile: selectedImageURL.path) {
                self.parent.selectedImages.append(image)
            }
        }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle document picker cancellation, if necessary
    }
}

