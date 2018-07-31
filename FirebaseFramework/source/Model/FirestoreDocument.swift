//
//  FirestoreDocument.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/28.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Promises
public class FirestoreDocument:FirebaseModelBase, FirebaseModelProtocol{

    
    //timestamp
    //TODO: 確認firestore timestamp格式
    var created_at = FirebaseField<Int>(value: 0)
    var created_by = FirebaseField<String>(value: ""); //user
    init(modelName: String?) {
        
    }
    
    func bind(obj: FirebaseObjectProtocol) {
    self.bindObj = obj;
        let fields = self.initFields()
        for field in fields {
            field.bind(bindModel: self);
        }
       
    }
    internal var bindObj: FirebaseObjectProtocol!;

    
    func getModel() -> Promise<Bool> {
        return firebaseManager.firestore.getDocument(collection: self.bindObj.collection, id: self.bindObj.id, ref: self.bindObj.parentRef).then{result in
            self.parseDocument(document: result)
            return Promise(true)
            };
    }
    func updateField(fieldName: String, fieldValue: Any) -> Promise<Bool> {
        //,self.bindObj.parentRef
        return firebaseManager.firestore.updateField(collection: self.bindObj.collection, id: self.bindObj.id, fieldName: fieldName, fieldValue: fieldValue,parentRef: self.bindObj.parentRef)
    }


    //將firebase下載的[String:Any轉換成model的fields]
    func parseDocument(document: [String:Any]) {
        for prop in document{
            
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
    
    
    func addModel() -> Promise<String> {
        let obj = self.createDataFromField();
        let docRef = firebaseManager.firestore.addDocument(collection: self.bindObj.collection, id: self.bindObj.id,data: obj, parentRef: self.bindObj.parentRef)
        self.bindObj.bindID(id: docRef.documentID)
        return Promise(docRef.documentID)
        
    }
    
   
    
    func setModel() -> Promise<Bool> {
        let obj = self.createDataFromField();
        return firebaseManager.firestore.setDocument(collection: self.bindObj.collection, id: self.bindObj.id, data: obj, parentRef: self.bindObj.parentRef)
    }
//    func updateModel() -> Promise<Bool> {
//        let obj = self.createDataFromField();
//        return firebaseManager.firestore.updateDocument()
//
//    }
//    func deleteModel() -> Promise<Bool> {
//        return firebaseManager.firestore.deleteDocument()
//    }
    
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
        if (self._fields == nil){ self._fields = self.initFields();}
        return self._fields;
    }
    private var _fields: [FirebaseField<Any>]!;
   
   
}
