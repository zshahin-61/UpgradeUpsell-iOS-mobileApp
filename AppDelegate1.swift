////
////  AppDelegate.swift
////  UpgradeUpsell
////
////  Created by zahra SHAHIN on 2023-11-20.
////
//import UIKit
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//import FirebaseCore
//
//@main
//class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
//
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Configure Firebase
//        FirebaseApp.configure()
//        
//        // Set up Firebase Cloud Messaging
//        Messaging.messaging().delegate = self
//
//        // Register for remote notifications
//        if #available(iOS 10.0, *) {
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: { _, _ in }
//            )
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//        application.registerForRemoteNotifications()
//
//        // Override point for customization after application launch.
//        return true
//    }
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        // This method will be called when the app successfully registers for remote notifications
//        // You can send this token to your server if needed
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        // This method will be called if the app fails to register for remote notifications
//        print("Failed to register for remote notifications with error: \(error.localizedDescription)")
//    }
//
//    // MARK: - Firebase Cloud Messaging Delegates
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        // This method will be called when the app successfully receives an FCM registration token
//        // You can send this token to your server if needed
//        print("FCM registration token: \(fcmToken ?? "")")
//    }
//
////    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
////        // This method will be called when a remote FCM message is received
////        print("Received data message: \(remoteMessage.appData)")
////    }
//
//    // MARK: - UNUserNotificationCenterDelegate
//
//    // If you want to handle notification interactions, implement the methods of UNUserNotificationCenterDelegate
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // Handle foreground notifications here
//        completionHandler([.alert, .badge, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Handle notification tap actions here
//        completionHandler()
//    }
//}
