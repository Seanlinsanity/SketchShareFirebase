//
//  FirebaseModel.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Promises
open class FirebaseModel: FirebaseModelProtocol
{
    public init(modelName:String?)
    {
        self.modelName = modelName
    }
    
    var loaded = false
    var hasBind = false
    var bindObj:FirebaseObjectProtocol!
    var modelName:String!
    
    /// 獲取model在firebase的路徑位置
    var databaseURL: String {
        let id = self.bindObj!.id
        let collection = self.bindObj!.collection
        if self.hasBind==false
        {
            debugPrint("model not bind yet\(self)\(String(describing: collection)) \(String(describing: self.modelName))")
        }
        let url = "\(collection)/\(self.modelName!)/\(id)";
        return url
    }
    func initFields()->[FirebaseField] {
        let mirror = Mirror(reflecting: self)
        var array:[FirebaseField] = []
        debugPrint(mirror, mirror.children)
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
//            if type(of: value)==FirebaseField<Any>.self
//            {
                let field =  value as! FirebaseField
            field.fieldName = name
                array.append(field)
//            }
        }
        return array;
    }
    
    func createDataFromField()->[String:Any] {
        var data:[String:Any] = [:]
        for field in initFields(){
            if(field.val != nil && field.dirty == true)
            {data[field.fieldName] = field.val}
        }
        return data;
    }
    //將firebase下載的[String:Any轉換成model的fields]
    public func parseModel(model: [String:Any], modelName: String? = nil) {
        if ((modelName) != nil){ self.modelName = modelName;}
        
        for prop in model{
            
            let fieldName = prop.key
            let mirror = Mirror(reflecting: self)
            for child in mirror.children
            {
                if child.label==fieldName
                {
                    let field = child.value as! FirebaseField
                    field.fieldName = fieldName
                    field.val = prop.value as AnyObject
                }
            }
            
        }
        self.loaded = true;
    }
   //TODO: 待捕
    public func updateField(fieldName: String, fieldValue: Any) -> Promise<Bool> {
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
    public func getModel() -> Promise<Bool> {
        return firebaseManager.getValue(url: self.databaseURL).then{model in
            if model.count == 0 { return Promise(false) }
            self.parseModel(model: model)
            return Promise(true)
        }
    }
    public func setModel() -> Promise<Bool>
    {
        let obj = self.createDataFromField();
        return firebaseManager.setValue(url: self.databaseURL, value: obj)
        
    }
    
    
    public func addModel() -> Promise<String> {
        let obj = self.createDataFromField();
        let url = "\(self.bindObj.collection)/\(self.modelName!)"
        debugPrint("addModel:",url,obj)
        return firebaseManager.pushValue(url: url, value: obj ).then{id in
            //TODO:
            self.bindObj.bindID(id: id)
        }
        
    }
    
   public func updateModel() -> Promise<Bool> {
         let obj = self.createDataFromField();
        return firebaseManager.updateValue(url: self.databaseURL, value: obj )
        
    }
    
    
   public func deleteModel() -> Promise<Bool> {
        return firebaseManager.deleteValue(url: self.databaseURL)
        
    }
    
}
open class FirebaseBriefModel:FirebaseModel{
    public convenience init() {
        self.init(modelName: "brief")
    }
}
