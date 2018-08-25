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
import Promises

enum FirebaseAuthError: Error {
    case invalidUser
}

public class FirebaseLogingManager {
    
    public init() {

    }
    
    public func checkUserId() -> Promise<String> {
        return Promise<String> {(fulfill,reject) in
            if let user = Auth.auth().currentUser {
                fulfill(user.uid)
            }else {
                 reject(FirebaseAuthError.invalidUser)
            }
        }
    }
    
    public func signInFirebaseWithFB() -> Promise<String> {
        return Promise<String> {(fulfill,reject) in
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
                if let error = error {
                    print("Failed to sign in Firebase with Facebook")
                    reject(error)
                }else{
                    print("Successfully logged in Firebase with facebook...")
                    guard let user = result?.user else { return }
                    fulfill(user.uid)
                }
            }
        }
    }
    
    public func getFacebookUserInfo() -> Promise<[String: Any]>{
        return Promise<[String: Any]> { (fulfill,reject) in
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if let err = err {
                    print("Failed to start graph request")
                    reject(err)
                }else{
                    guard let result = result as? [String: Any] else { return }
                    guard let email = result["email"] else { return }
                    print("user email: ", email)
                    fulfill(result)
                }
            }
        }
    }
    
    public func signInFirebaseWithGoogle(user: GIDGoogleUser) -> Promise<User> {
        return Promise<User> {  (fulfill,reject) in
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
                if let error = error {
                    print("Failed to sign in Firebase with Google")
                    reject(error)
                }else{
                    print("Successfully logged in Firebase with Google...")
                    guard let user = result?.user else { return }
                    fulfill(user)
                }
            }
        }
    }
    
    public func signOut() -> Promise<Bool>{
        return Promise<Bool>{ (fulfill,reject) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("sign out successfully")
                fulfill(true)
            } catch let signOutError as NSError {
                reject(signOutError)
            }
        }
    }
    
}
