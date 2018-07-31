//
//  FirebaseModel.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Promises
open class FirebaseModel: FirebaseModelBase, FirebaseModelProtocol
{

   
    
    override init(){
        
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
        let url = "\(collection)/\(self.modelName)/\(id))";
        return url
    }
    //將firebase下載的[String:Any轉換成model的fields]
    func parseModel(model: [String:Any], modelName: String? = nil) {
        if ((modelName) != nil){ self.modelName = modelName;}
        
        for prop in model{
            
            let fieldName = prop.key
            let mirror = Mirror(reflecting: self)
            for child in mirror.children
            {
                if child.label==fieldName
                {
                    let field = child.value as! FirebaseField<Any>
                    field.fieldName = fieldName
                    field.val = prop.value
                }
            }
            
        }
        self.loaded = true;
    }
   //TODO: 待捕
    func updateField(fieldName: String, fieldValue: Any) -> Promise<Bool> {
        return firebaseManager.updateValue(url: "\(self.bindObj.collection)\(self.modelName)\(self.bindObj.id)\(fieldName)", value: fieldValue as! [String : Any])
        
    }
    
//
//   
//    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any> {
//        return Promise<Any> { (fulfill,reject) in
//            seal.fulfill("TODO")
//        }
//        
//    }
    
    //TODO:
    func getModel() -> Promise<Bool> {
        return firebaseManager.getValue(url: self.databaseURL).then{model in
            self.parseModel(model: model)
            return Promise(true)
        }
    }
    func setModel() -> Promise<Bool>
    {
        let obj = self.createDataFromField();
        return firebaseManager.setValue(url: self.databaseURL, value: obj)
        
    }
    
    
    func addModel() -> Promise<String> {
         let obj = self.createDataFromField();
        return firebaseManager.pushValue(url: "\(self.bindObj.collection)/\(self.modelName)", value: obj ).then{url in
            return Promise(url)
        }
        
    }
    
    func updateModel() -> Promise<Bool> {
         let obj = self.createDataFromField();
        return firebaseManager.updateValue(url: self.databaseURL, value: obj )
        
    }
    
    
    func deleteModel() -> Promise<Bool> {
        return firebaseManager.deleteValue(url: self.databaseURL)
        
    }
    
}
