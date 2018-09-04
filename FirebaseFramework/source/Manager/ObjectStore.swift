//
//  ObjectStore.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/9/4.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
open class ObjectStore<FirestoreObject>{
    init() {
        
    }
    var currentObject:FirestoreObject!
    var objs:[FirestoreObject] = []
    var objMap:[String:FirestoreObject] = [:]
    func getObject(id:String){
        return
    }
    //TODO: Loader
    func loadObjs(){
        
    }
}
