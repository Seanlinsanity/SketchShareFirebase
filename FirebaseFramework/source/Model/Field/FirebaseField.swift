//
//  FirebaseField.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import PromiseKit
//type FirebaseFieldType =
//    | string
//    | number
//    | boolean
//    | Date
//    | Array<string>
//    | Array<number>
//    | Array<boolean>
//    | any;

class FirebaseField<T>:FieldWrapper<T> {
    
    var hasBind:Bool = false;
    var bindModel: FirebaseModelProtocol;
    var fieldName: String;
    //將doc和brief同步資料連結用
    var linkFields: [FirebaseField<T>]!;
   init(
    value: T? = nil,
    dirty: Bool? = nil
    ) {
    
        super.init(val: value)
        if (dirty!){ self.dirty = true}
    }
    
    func bind(bindModel: FirebaseModelProtocol) {
    self.bindModel = bindModel;
    self.hasBind = true;
    }
   
    
    //TODO: ref in obj
    func update(val: T?)->Promise<Any> {
        if (self.hasBind == false) {
        // console.error("Not bind yet can't update");
            
            return Promise(error: "Not bind yet can't update" as! Error);
        }
            var ps:[Promise<Any>] = [] as! [Promise];
            if ((self.linkFields) != nil)
            {
                for field in self.linkFields
                {
                    ps.append(field.update(val: val));
                }
            }
            ps.append(self.bindModel.updateField(fieldName: self.fieldName, fieldValue: self.val))
        return  when(fulfilled: ps).then({results in
                return Promise(
            })
    }
    func set(val: T) {
        self.val = val
        if ((self.linkFields) != nil) {
            for field in self.linkFields
            {
                field.set(val: val)
            }
        }
    }
    var toString: String {
        return String(self.val)
    }
}

