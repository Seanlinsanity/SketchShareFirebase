//
//  FirebaseManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase
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
    public func getValue(url:String)->Promise<NSDictionary>{
        return Promise<NSDictionary>{seal in
            
            ref.child(url).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                debugPrint("Firebase get:\(value)")
                
                seal.fulfill(value)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    ///寫入
    public func setValue(url:String,obj:Any) {
        print("firebase Set value \(url):\(obj)")
        ref.child(url).setValue(obj)        
    }
    func pushValue(url:String,obj:Any){
        
    }
    
}
public let firebaseManager = FirebaseManager()
//REF:https://stackoverflow.com/questions/41527058/many-to-many-relationship-in-firebase

