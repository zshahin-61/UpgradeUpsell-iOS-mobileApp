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

class PhotoLibraryManager: NSObject, ObservableObject {
    @Published var isAuthorized = false
    @Published var authStatus: String = ""
    
    override init() {
        super.init()
        checkPermission()
    }
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            // Photo library access is granted
            self.authStatus = "authorized"
        case .denied, .restricted:
            // Photo library access is denied or restricted
            self.authStatus = "denied"
            // You can show an alert or update UI to inform the user
            print("Photo library access denied.")
        case .notDetermined:
            // User has not yet made a choice
            self.authStatus = "notDetermined"
            print("Photo library access not determined.")
        @unknown default:
            break
        }
        isAuthorized = status == .authorized
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.isAuthorized = status == .authorized
            }
        }
    }
}
