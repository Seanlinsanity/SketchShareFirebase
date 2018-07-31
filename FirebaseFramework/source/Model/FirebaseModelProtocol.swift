//
//  FirebaseModelProtocol.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import Promises
protocol FirebaseModelProtocol {
    
   
//    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any>
//    func getModel() -> Promise<Bool>
//    func addModel() -> Promise<String>
//    func updateModel() -> Promise<Bool>
//    func setModel() -> Promise<Bool>
//    func deleteModel() -> Promise<Bool>
     func updateField(fieldName: String, fieldValue: Any)-> Promise<Bool>;
    func properties()->[String]
}
extension FirebaseModelProtocol
{
    func properties()->[String]{
        var s = [String]()
        for c in Mirror(reflecting: self).children
        {
            if let name = c.label{
                s.append(name)
            }
        }
        return s
    }
    /// 設定field的名字，初始化此Model的所有Field
    
    func initFields()->[FirebaseField<Any>] {
        let mirror = Mirror(reflecting: self)
        var array: [FirebaseField<Any>] = [] as! [FirebaseField<Any>];
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
            if type(of: value)==FirebaseField<Any>.self
            {
                let field = value as! FirebaseField<Any>
                array.append(field)
                field.fieldName = name
            }
        }
        return array;
    }
    
    func createDataFromField()->[String:Any] {
        var data:[String:Any] = [:]
        for field in initFields(){
            if(field.val != nil&&field.dirty == true)
            {data[field.fieldName] = field.val}
        }
        return data;
    }
   
}




