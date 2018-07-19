//
//  FirebaseLoginManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/17.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Firebase

//登入的部分
public class FirebaseLogingManager
{
    public init() {
        //FirebaseApp.configure()
    }
    
    public func checkUserId() {
        print(Auth.auth().currentUser?.uid ?? "No User ID")
    }
    
    
}
