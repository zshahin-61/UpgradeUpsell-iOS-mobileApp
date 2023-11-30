//
//  CameraView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-29.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) {
                parent.didCaptureImage?(capturedImage)
            }
        }
    }

    var didCaptureImage: ((UIImage) -> Void)?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return viewController }

        if (captureSession.canAddInput(input)) {
            captureSession.addInput(input)
        }

        let photoOutput = AVCapturePhotoOutput()
        if (captureSession.canAddOutput(photoOutput)) {
            captureSession.addOutput(photoOutput)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill

        let uiView = UIView(frame: UIScreen.main.bounds)
        uiView.layer.addSublayer(previewLayer)

        viewController.view.addSubview(uiView)

        captureSession.startRunning()

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CameraView>) {
        // Nothing to do here
    }
}


//import SwiftUI
//
//struct CameraView: View {
//    let onCapture: (UIImage) -> Void
//
//    var body: some View {
//        VStack {
//            Text("Camera View Placeholder")
//                .foregroundColor(.white)
//                .padding()
//                .background(Color.gray)
//                .cornerRadius(10)
//
//            Button("Capture Photo") {
//                // Simulate capturing a photo for demonstration purposes
//                let capturedImage = UIImage(systemName: "photo")!
//                onCapture(capturedImage)
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//        }
//    }
//}

