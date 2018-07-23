//
//  FirebaseModelProtocol.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import PromiseKit
protocol FirebaseModelProtocol {
    
    func updateField(fieldName: String, fieldValue: Any)-> Promise<Any>;
    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any>
    func getModel() -> Promise<Any>
    func addModel() -> Promise<Any>
    func updateModel(obj: Any) -> Promise<Any>
    func setModel(model: Any) -> Promise<Any>
    func deleteModel() -> Promise<Any>
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
}




