//
//  FirebaseLoginManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import PromiseKit

enum FirebaseAuthError: Error {
    case invalidUser
}

public class FirebaseLogingManager {
    
    public init() {

    }
    
    public func checkUserId() -> Promise<String> {
        return Promise<String> {(seal) in
            if let user = Auth.auth().currentUser {
                seal.fulfill("uid: \(user.uid), name: \(user.displayName ?? "invalid username")")
            }else {
                seal.reject(FirebaseAuthError.invalidUser)
            }
        }
    }
    
    public func signInFirebaseWithFB(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
            if error != nil {
                print("Failed to sign in Firebase by FB: ", error ?? "error")
                return
            }
            print("Successfully logged in Firebase with facebook...")
            print(result?.user.uid ?? "no uid")
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print("Failed to start graph request: ", err ?? "error")
                return
            }
            guard let result = result as? [String: Any] else { return }
            guard let email = result["email"] else { return }
            print("user email: ", email)
        }
    }
    
    public func signInFirebaseWithGoogle(user: GIDGoogleUser){
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            print(user.profile.email ?? "user email error")
        }
    }
    
    public func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("sign out successfully")
        } catch let signOutError as NSError {
            print ("Error signing out: ", signOutError)
        }
    }
    
}
