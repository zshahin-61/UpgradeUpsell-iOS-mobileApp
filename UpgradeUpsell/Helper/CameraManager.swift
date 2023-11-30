//
//  CameraManager.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-30.
//

//
//  PhotoLibraryManager.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-21.
//

import Foundation
import AVFoundation
import Photos
import Combine

class CameraManager: NSObject, ObservableObject {
    
    @Published var isCameraAuthorized = false
    @Published var cameraAuthSatus: String = ""
    
    override init() {
        super.init()
        checkCameraPermission()
    }
    
    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Camera access is granted
            self.isCameraAuthorized = true
            self.cameraAuthSatus = "authorized"
        case .denied, .restricted:
            // Camera access is denied or restricted
            self.isCameraAuthorized = false
            self.cameraAuthSatus = "denied"
            // You can show an alert or update UI to inform the user
            print("Camera access denied.")
        case .notDetermined:
            self.isCameraAuthorized = false
            self.cameraAuthSatus = "notDetermined"
        @unknown default:
            break
        }
    }
    
    
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isCameraAuthorized = granted
                
            }
        }
    }
}

