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
import Promises
import GoogleSignIn
/**
 * 管理firebase的api 和 realtime database 存取
 */


public class FirebaseManager {
    
    var ref: DatabaseReference!
    public let loginManager = FirebaseLogingManager()
    public let storageManager = FirebaseStorageManager()
    public var firestore: FirestoreManager!
    public init() {
        
    }
    public func configure(){
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        ref = Database.database().reference()
        
        //初始化firestore
        firestore = FirestoreManager(db: Firestore.firestore())
        
    }
    
    //realtime database 讀取
    public func getValue(url: String) -> Promise< [String: Any]> {
        return Promise< [String: Any]> { (fulfill,reject) in
            self.ref.child(url).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as?  [String: Any]{
                    debugPrint("Firebase get: \(value)")
                    
                    fulfill(value)
                }
            }) { (error) in
                print(error.localizedDescription)
                reject(error)
            }
        }
    }
    /// 把資料寫入
    /// - Parameters:
    ///   - url:
    ///   - value:
    /// - Returns: 成功
    public func setValue(url: String, value: [String: Any]) -> Promise<Bool> {
        return Promise<Bool> { (fulfill,reject) in
            self.ref.child(url).setValue(value) { (error, ref) in
                if error != nil {
                    print("Failed to set value in Firebase")
                    guard let error = error else { return }
                    reject(error)
                }
                print("Successfully to set value :\(value) in Firebase")
                fulfill(true)
            }
        }
    }
    public func pushValue(url: String, value: [String: Any]) -> Promise<String> {
         return Promise<String> { (fulfill,reject) in
            self.ref.child(url).childByAutoId().setValue(value) { (error, ref) in
                if error != nil {
                    print("Failed to push value in Firebase")
                    guard let error = error else { return }
                    reject(error)
                }
                print("Successfully to push value :\(value) in Firebase")
                fulfill(ref.key)
            }
        }
    }
    
    public func updateValue(url: String, value: [String: Any]) -> Promise<Bool> {
        return Promise<Bool>{ (fulfill,reject) in
            
            self.ref.child(url).updateChildValues(value) { (error, ref) in
                if error != nil{
                    print("Failed to update value in Firebase")
                    guard let error = error else { return }
                    reject(error)
                }
                print("Successfully to update value: \(value) in Firebase")
                fulfill(true)
            }
        }

    }
    
    public func deleteValue(url: String) -> Promise<Bool> {
        return Promise<Bool> { (fulfill,reject) in
            self.ref.child(url).removeValue { (error, ref) in
                if error != nil {
                    print("Failed to delete value in Firebase: ")
                    guard let error = error else { return }
                    reject(error)
                }
                print("Successfully to delete value at \(url) in Firebase")
                fulfill(true)
            }
        }
    }
    
}
public let firebaseManager = FirebaseManager()
//REF:https://stackoverflow.com/questions/41527058/many-to-many-relationship-in-firebase

