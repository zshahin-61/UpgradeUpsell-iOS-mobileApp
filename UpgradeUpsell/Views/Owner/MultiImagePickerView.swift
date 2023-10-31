//
//  MultiImagePickerView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-30.
//

import SwiftUI

struct MultiImagePickerView: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagesPicked: ([UIImage]) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: MultiImagePickerView

        init(_ parent: MultiImagePickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.onImagesPicked([uiImage])
            } else {
                parent.onImagesPicked([])
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImagesPicked([])
        }
    }
}
