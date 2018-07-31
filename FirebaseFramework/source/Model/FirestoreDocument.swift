//
//  FirestoreDocument.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/28.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PromiseKit
public class FirestoreDocument:FirebaseModelProtocol{
    
    
    //timestamp
    //TODO: 確認firestore timestamp格式
    var created_at = FirebaseField<Int>(value: 0)
    var created_by = FirebaseField<String>(value: ""); //user
    init(modelName: String?) {}
    func bind(obj: FirebaseObjectProtocol) {
    self.bindObj = obj;
        let fields = self.initFields()
        for field in fields {
            field.bind(bindModel: self);
        }
       
    }
    internal var bindObj: FirebaseObjectProtocol!;
    func updateField(fieldName: String, fieldValue: Any) -> Promise<Any> {
        <#code#>
    }
    
    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any> {
        <#code#>
    }
    
    func getModel() -> Promise<Any> {
//        return firebaseManager.firestore.getDocument(collection: self.bindObj.collection, id: self.bindObj.id, ref: self.bindObj.parentRef).then{result in
//                result
//            };
    }
    
    func addModel() -> Promise<Any> {
        var obj = self.createDataFromField();
        return firebaseManager.firestore.addDocument(collection: self.bindObj.collection, id: self.bindObj.id,data: self.bindObj.obj, parentRef: self.bindObj.parentRef).then{docRef in
            self.bindObj.bindID(docRef.id);
            return docRef.id;
            };
    }
    
    func updateModel(obj: Any) -> Promise<Any> {
        <#code#>
    }
    
    func setModel(model: Any) -> Promise<Any> {
        <#code#>
    }
    
    func deleteModel() -> Promise<Any> {
        <#code#>
    }
    
//    func checkAllFieldsValid()->Bool {
//        for field in self.fields {
//
//            field.startCheckValid();
//            if (!field.checkValid())
//            {return false;}
//        }
//        return true;
//    }
    var fields: [FirebaseField<Any>] {
        if (self._fields == nil){ self._fields = this.initFields();}
        return self._fields;
    }
    private var _fields: [FirebaseField<Any>]!;
   
   
}
