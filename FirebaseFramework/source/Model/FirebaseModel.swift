//
//  FirebaseModel.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import PromiseKit
open class FirebaseModel: FirebaseModelProtocol
{
    init(){
        
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
    //將firebase下載的[String:Any轉換成model的fields]
    func parseModel(model: [String:Any], modelName: String?) {
        if ((modelName) != nil){ self.modelName = modelName;}
        
        for prop in model{
            var fieldName = prop
            var field = self[fieldName] as FirebaseField;
            if (field) {
                field.fieldName = fieldName;
                field.val = model[fieldName];
            }
        }
        self.loaded = true;
    }
    var loaded = false
   //TODO: 待捕
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
    
    //TODO:
    func getModel() -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
    func setModel(model: Any) -> Promise<Any>
    {
        let obj = self.createDataFromField();
        return firebaseManager.setValue(url: self.databaseURL, value: obj)
        
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
    
    
    func deleteModel() -> Promise<Any> {
        return Promise { seal in
            seal.fulfill("TODO")
        }
        
    }
}
