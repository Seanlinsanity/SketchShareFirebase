//
//  FirebaseModel.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import PromiseKit
public class FirebaseModel: FirebaseModelProtocol{
    
    /// 設定firebase field的名字，得到此Model的所有Field
    func initFields()->[FirebaseField] {
        let mirror = Mirror(reflecting: self)
        var array: [FirebaseField] = [];
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
            if type(of: value)==FirebaseField.self
            {
                let field = value as! FirebaseField
                array.append(field)
                field.fieldName = name
            }
        }
        return array;
    }
        
    
    var hasBind = false
    var bindObj:FirebaseObjectProtocol!
    var modelName:String!
    
    
    /// 獲取model在firebase的路徑位置
    var databaseURL: String {
        let id = self.bindObj!.id
        let collection = self.bindObj!.collection
        if self.hasBind==false
        {
            debugPrint("model not bind yet\(String(describing: collection)) \(String(describing: self.modelName))")
        }
        let url = "\(collection)/\(self.modelName)/\(String(describing: id))";
        return url
    }
    func fetch() -> Promise<String> {
        return Promise { seal in
            seal.fulfill("")
        }
    }    //TODO: 待捕
    func updateField(fieldName: String, fieldValue: Any) -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
       
    }
    
   
    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    
    func getModel() -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    
    func addModel() -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    
    func updateModel(obj: Any) -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    
    func setModel(model: Any) -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    
    func deleteModel() -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
}
