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
                seal.fulfill(user.uid)
            }else {
                seal.reject(FirebaseAuthError.invalidUser)
            }
        }
    }
    
    public func signInFirebaseWithFB() -> Promise<String> {
        return Promise<String> { (seal) in
            let accessToken = FBSDKAccessToken.current()
            guard let accessTokenString = accessToken?.tokenString else { return }
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
                if let error = error {
                    print("Failed to sign in Firebase with Facebook")
                    seal.reject(error)
                }else{
                    print("Successfully logged in Firebase with facebook...")
                    guard let user = result?.user else { return }
                    seal.fulfill(user.uid)
                }
            }
        }
    }
    
    public func getFacebookUserInfo() -> Promise<[String: Any]>{
        return Promise<[String: Any]> { (seal) in
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
                if let err = err {
                    print("Failed to start graph request")
                    seal.reject(err)
                }else{
                    guard let result = result as? [String: Any] else { return }
                    guard let email = result["email"] else { return }
                    print("user email: ", email)
                    seal.fulfill(result)
                }
            }
        }
    }
    
    public func signInFirebaseWithGoogle(user: GIDGoogleUser) -> Promise<String> {
        return Promise<String> { (seal) in
            guard let idToken = user.authentication.idToken else { return }
            guard let accessToken = user.authentication.accessToken else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (result, error) in
                if let error = error {
                    print("Failed to sign in Firebase with Google")
                    seal.reject(error)
                }else{
                    print("Successfully logged in Firebase with Google...")
                    guard let user = result?.user else { return }
                    seal.fulfill(user.uid)
                }
            }
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
