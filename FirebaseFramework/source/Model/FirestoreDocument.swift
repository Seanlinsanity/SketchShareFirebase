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
    var created_at = FirebaseField(val: <#T?#>)
    var created_by = FirebaseField(val: <#T?#>); //user
    init(modelName: String?) {}
    func bind(obj: FirebaseObjectProtocol) {
    self.bindObj = obj;
    var fields = self.initFields()
        for field in fields {
            field.bind(self);
        }
       
    }
    protected var bindObj: IFirebaseObject!;
    func updateField(fieldName: String, fieldValue: Any) -> Promise<Any> {
        <#code#>
    }
    
    func transactionAddValue(fieldName: String, val: Float) -> Promise<Any> {
        <#code#>
    }
    
    func getModel() -> Promise<Any> {
        <#code#>
    }
    
    func addModel() -> Promise<Any> {
        <#code#>
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
    
    createObjFromField() {
    var obj = new Object();
    this.initFields().forEach(field => {
    if (field.dirty == true) obj[field.fieldName] = field.val;
    });
    return obj;
    }
    checkAllFieldsValid() {
    this.fields.forEach(field => {
    field.startCheckValid();
    if (!field.checkValid()) return false;
    });
    return true;
    }
    get fields() {
    if (this._fields == null) this._fields = this.initFields();
    return this._fields;
    }
    private _fields: FirebaseField[];
    getModel() {
    var { collection, id, parentRef } = this.bindObj;
    return firestore.getDocument(collection, id, parentRef);
    }
    addModel(): Promise<string> {
    var obj = this.createObjFromField();
    var { collection, parentRef } = this.bindObj;
    return firestore.addDocument(collection, obj, parentRef).then(docRef => {
    this.bindObj.bindID(docRef.id);
    return docRef.id;
    });
    }
    updateModel(): Promise<any> {
    var obj = this.createObjFromField();
    var { collection, id, parentRef } = this.bindObj;
    return firestore.updateDocument(collection, id, obj, parentRef);
    }
    setModel(): Promise<any> {
    var obj = this.createObjFromField();
    var { collection, id, parentRef } = this.bindObj;
    return firestore.setDocument(collection, id, obj, parentRef);
    }
    deleteModel(): Promise<any> {
    //TODO:
    //get subcollection and delete
    var { collection, id, parentRef } = this.bindObj;
    return firestore.deleteDocument(collection, id, parentRef);
    }
    updateField(fieldName: string, fieldValue: any) {
    var { collection, id, parentRef } = this.bindObj;
    return firestore.updateField(
    collection,
    id,
    fieldName,
    fieldValue,
    parentRef
    );
    }
    transactionAddValue(fieldName, value: number) {
    //TODO: check value is number?
    var { collection, id, parentRef } = this.bindObj;
    return firestore.transactionAddValue(
    collection,
    id,
    fieldName,
    value as number,
    parentRef
    );
    }
    parseDocument(document: any) {
    for (var prop in document) {
    var fieldName = prop as string;
    var field = this[fieldName] as FirebaseField;
    if (field) {
    field.fieldName = fieldName;
    field.init(document[fieldName]);
    } else {
    var { collection, id } = this.bindObj;
    console.error("No Field firestore", collection, id, fieldName);
    }
    }
    }
}
