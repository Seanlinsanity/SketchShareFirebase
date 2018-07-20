//
//  FirebaseManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Firebase
import PromiseKit
/**
 * 管理firebase的api 和 realtime database 存取
 */
public class FirebaseManager {
    
    var ref: DatabaseReference!
    public let loginManager = FirebaseLogingManager()
    
    public init() {
        
    }
    
    public func configure(){
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        debugPrint(ref)
        
    }
    
    //realtime database 讀取
    public func getValue(url: String) -> Promise<NSDictionary> {
        return Promise<NSDictionary> {seal in
            
            ref.child(url).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary{
                    debugPrint("Firebase get: \(value)")
                    
                    seal.fulfill(value)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    ///寫入
    public func setValue(url: String, value: Any) {
        ref.child(url).setValue(value) { (error, ref) in
            if error != nil {
                print("Failed to set value in Firebase: ", error ?? "error")
                return
            }
            print("Successfully to set value :\(value) in Firebase")
        }
    }
    
    public func pushValue(url: String, value: Any){
        guard let updateValue = value as? [String: Any] else { return }
        ref.child(url).updateChildValues(updateValue) { (error, ref) in
            if error != nil{
                print("Failed to update value in Firebase: ", error ?? "error")
                return
            }
            print("Successfully to update value: \(value) in Firebase")
        }
    }
    
    public func deleteValue(url: String){
        ref.child(url).removeValue { (error, ref) in
            if error != nil {
                print("Failed to delete value in Firebase: ", error ?? "error")
                return
            }
            print("Successfully to delete value at \(url) in Firebase")
        }
    }
    
}
public let firebaseManager = FirebaseManager()
//REF:https://stackoverflow.com/questions/41527058/many-to-many-relationship-in-firebase

