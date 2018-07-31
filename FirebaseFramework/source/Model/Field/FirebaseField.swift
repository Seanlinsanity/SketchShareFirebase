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
    value: T?,
    dirty: Bool?
    ) {
    
        super.init(val: value)
        if (dirty!){ self.dirty = true}
    }
    
    func bind(bindModel: FirebaseModelProtocol) {
    self.bindModel = bindModel;
    self.hasBind = true;
    }
   
    
    //TODO: ref in obj
    func update(val?: T) {
    super.update(val);
    if (self.hasBind == false) {
    // console.error("Not bind yet can't update");
        Promise
    return Promise.reject("Not bind yet can't update");
    }
    var ps = [];
    if (this.linkFields) {
    this.linkFields.forEach(field => {
    ps.push(field.update(val));
    });
    }
    ps.push(this.bindModel.updateField(this.fieldName, this.val));
    return Promise.all(ps);
    }
    set(val: T) {
    super.set(val);
    if (this.linkFields) {
    this.linkFields.forEach(field => {
    field.set(this.val);
    });
    }
    }
    
    toString() {
    return new String(this.val).toString();
    }
}

