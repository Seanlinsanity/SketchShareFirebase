//
//  FirebaseManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import PromiseKit
import GoogleSignIn
/**
 * 管理firebase的api 和 realtime database 存取
 */


public class FirebaseManager {
    
    var ref: DatabaseReference!
    public let loginManager = FirebaseLogingManager()
    public var firestore: FirestoreManager!
    public init() {
        
    }
    
    public func configure(){
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        ref = Database.database().reference()
        //初始化firestore
        
        firestore = FirestoreManager(db: Firestore.firestore())
        debugPrint(ref)
    }
    
    //realtime database 讀取
    public func getValue(url: String) -> Promise<NSDictionary> {
        return Promise<NSDictionary> { seal in
            
            ref.child(url).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary{
                    debugPrint("Firebase get: \(value)")
                    
                    seal.fulfill(value)
                }
            }) { (error) in
                print(error.localizedDescription)
                seal.reject(error)
            }
        }
    }
    ///寫入
    public func setValue(url: String, value: [String: Any]) -> Promise<[String: Any]> {
        return Promise<[String: Any]> { seal in
            ref.child(url).setValue(value) { (error, ref) in
                if error != nil {
                    print("Failed to set value in Firebase")
                    guard let error = error else { return }
                    seal.reject(error)
                }
                print("Successfully to set value :\(value) in Firebase")
                seal.fulfill(value)
            }
        }
    }
    
    public func pushValue(url: String, value: [String: Any]) -> Promise<[String: Any]> {
        return Promise<[String: Any]>{ seal in
            
            ref.child(url).updateChildValues(value) { (error, ref) in
                if error != nil{
                    print("Failed to update value in Firebase")
                    guard let error = error else { return }
                    seal.reject(error)
                }
                print("Successfully to update value: \(value) in Firebase")
                seal.fulfill(value)
            }
        }

    }
    
    public func deleteValue(url: String) -> Promise<String> {
        return Promise<String> { seal in
            ref.child(url).removeValue { (error, ref) in
                if error != nil {
                    print("Failed to delete value in Firebase: ")
                    guard let error = error else { return }
                    seal.reject(error)
                }
                print("Successfully to delete value at \(url) in Firebase")
                seal.fulfill(url)
            }
        }
    }
    
}
public let firebaseManager = FirebaseManager()
//REF:https://stackoverflow.com/questions/41527058/many-to-many-relationship-in-firebase

