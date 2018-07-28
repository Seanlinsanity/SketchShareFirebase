//
//  FirestoreManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseFirestore
/// firestore存取
public class FirestoreManager {
    let db:Firestore!
    var setCount:Int = 0
    init(db:Firestore) {
        self.db = db
    }
    
    //拿到參考
    func getDocumentRef(collection: String, id: String)->DocumentReference {
        return db.collection(collection).document(id)
    }
    
    /// Create new document into firestore database
    ///
    /// - Parameters:
    ///   - collection: firestore collection
    ///   - id: document id
    ///   - data: data to store in the document
    ///   - parentRef: if there is a parent collection, pass this
    /// - Returns: new document reference
    func addDocument(collection: String,id: String,data:[String:Any],parentRef:DocumentReference?)->DocumentReference{
        if((parentRef) != nil)
        {
            return db.collection(collection).addDocument(data: data)
        }
        else
        {
            return parentRef!.collection(collection).addDocument(data: data)
        }
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - collection: <#collection description#>
    ///   - id: <#id description#>
    ///   - data: <#data description#>
    ///   - parentRef: <#parentRef description#>
    func setDocument(collection: String,id: String,data: [String:Any],parentRef: DocumentReference?) {
        //TODO: promise化
        self.setCount = self.setCount+1
        if (parentRef != nil) {
            return (parentRef?
                .collection(collection)
                .document(id)
                .setData(data))!;
        } else
        {
            return self.db
                .collection(collection)
                .document(id).setData(data, merge: true);
        }
    }
    func getDocument(){
        //TODO:
    }
}
