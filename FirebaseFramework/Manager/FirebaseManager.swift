//
//  FirebaseManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseDatabase

/**
 * 管理firebase的api 和 realtime database 存取
 */
public class FirebaseManager {
    public let loginManager = FirebaseLogingManager()
    public init() {

    }
    //realtime database 讀取/寫入
    func setValue(url:String,obj:Any) {
        
    }
    func pushValue(url:String,obj:Any){
        
    }
    
}

//REF:https://stackoverflow.com/questions/41527058/many-to-many-relationship-in-firebase
let firebaseManager = FirebaseManager()
