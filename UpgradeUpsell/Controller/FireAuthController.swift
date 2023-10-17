//
//  FireAuthController.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseAuth

class FireAuthController : ObservableObject{
    
    //using inbuilt User object provided by FirebaseAuth
    @Published var user : User?{
        didSet{
            objectWillChange.send()
        }
    }
    
    @Published var isLoginSuccessful = false
    
    func listenToAuthState(){
        Auth.auth().addStateDidChangeListener{ [weak self] _, user in
            guard let self = self else{
                //no change in user's auth state
                return
            }
            
            //user's auth state has changed ; update the user object
            self.user = user
        }
    }
    
    
    func signUp(email: String, password : String, withCompletion completion: @escaping (Bool) -> Void){
        Auth.auth().createUser(withEmail : email, password: password){ authResult, error in
            
            guard let result = authResult else{
                print(#function, "Error while signing up user : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch(authResult){
            case .none:
                print(#function, "Unable to create account")
                DispatchQueue.main.async {
                    self.isLoginSuccessful = false
                    completion(self.isLoginSuccessful)
                }
            case .some(_):
                print(#function, "Successfully created user account")
                
                self.user = authResult?.user
                //save the email in the UserDefaults
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_ID")
                
                DispatchQueue.main.async {
                    self.isLoginSuccessful = true
                    completion(self.isLoginSuccessful)
                }
            }
            
        }
        
    }
    
//    func signIn(email: String, password : String, withCompletion completion: @escaping (Bool) -> Void){
//
//        Auth.auth().signIn(withEmail: email, password: password){authResult, error in
//            guard let result = authResult else{
//                print(#function, "Error while signing in user : \(error)")
//                return
//            }
//
//            print(#function, "AuthResult : \(result)")
//
//            switch(authResult){
//            case .none:
//                print(#function, "Unable to find user account")
//
//                DispatchQueue.main.async {
//                    self.isLoginSuccessful = false
//                    completion(self.isLoginSuccessful)
//                }
//
//            case .some(_):
//                print(#function, "Login Successful")
//
//                self.user = authResult?.user
//                //save the email in the UserDefaults
//                UserDefaults.standard.set(self.user?.uid, forKey: "KEY_ID")
//
//                print(#function, "user email : \(self.user?.email)")
//                print(#function, "user displayName : \(self.user?.displayName)")
//                print(#function, "user isEmailVerified : \(self.user?.isEmailVerified)")
//                print(#function, "user phoneNumber : \(self.user?.phoneNumber)")
//
//                DispatchQueue.main.async {
//                    self.isLoginSuccessful = true
//                    completion(self.isLoginSuccessful)
//                }
//            }
//        }
//
//    }
    
    func signIn(email: String, password: String, withCompletion completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(#function, "Error while signing in user: \(error)")
                DispatchQueue.main.async {
                    self.isLoginSuccessful = false
                    completion(false)
                }
            } else if let user = authResult?.user {
                print(#function, "Login Successful")
                // Save the email in UserDefaults
                UserDefaults.standard.set(user.uid, forKey: "KEY_ID")
                
                print(#function, "user email: \(user.email ?? "N/A")")
                print(#function, "user displayName: \(user.displayName ?? "N/A")")
                print(#function, "user isEmailVerified: \(user.isEmailVerified)")
                print(#function, "user phoneNumber: \(user.phoneNumber ?? "N/A")")
                
                DispatchQueue.main.async {
                    self.isLoginSuccessful = true
                    completion(true)
                }
            }
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
        }catch let err as NSError{
            print(#function, "Unable to sign out : \(err)")
        }
    }
    
    func deleteAccountFromAuth(withCompletion completion: @escaping (Bool) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            currentUser.delete { error in
                if let error = error {
                    print("Error deleting user account from Firebase Authentication: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                } else {
                    print("User account deleted from Firebase Authentication successfully.")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            }
        }
    }

    
    
}

