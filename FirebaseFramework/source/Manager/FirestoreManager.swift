//
//  FirestoreManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Promises
/// firestore存取
public class FirestoreManager {
    let db: Firestore!
    var setCount: Int = 0
    
    public init(db:Firestore) {
        self.db = db
    }
    
    //拿到參考
    public func getDocumentRef(collection: String, id: String) -> DocumentReference {
        return db.collection(collection).document(id)
    }
    
    public func addDocument(collection: String, id: String, data: [String:Any], parentRef: DocumentReference?) -> DocumentReference {
        if let ref = parentRef {
            return ref.collection(collection).addDocument(data: data)
        }else{
            return db.collection(collection).addDocument(data: data)
        }
    }
    
    public func setDocument(collection: String, id: String, data: [String : Any], parentRef: DocumentReference? = nil) -> Promise<Bool> {
        
        return Promise<Bool> { (fulfill,reject) in
            self.setCount = self.setCount + 1
            if let ref = parentRef {
                ref.collection(collection).document(id).setData(data, completion: { (error) in
                    if let error = error {
                        reject(error)
                    }else{
                        fulfill(true)
                    }
                })
            }else{
                return self.db.collection(collection).document(id).setData(data, merge: true, completion: { (err) in
                    if let err = err {
                        reject(err)
                    }else{
                        fulfill(true)
                    }
                })
            }
        }


    }
    
    public func getDocument(collection: String, id: String,ref:DocumentReference?) -> Promise<[String: Any]> {
        return Promise<[String: Any]> { (fulfill,reject)in
            //有parent collection的情況
            if(ref != nil)
            {
                ref?.collection(collection).document(id).getDocument { (snapshot, error) in
                    if let error = error {
                        reject(error)
                    }else{
                        guard let documentData = snapshot?.data() else { return }
                        fulfill(documentData)
                    }
                }
            }
            self.db.collection(collection).document(id).getDocument { (snapshot, error) in
                if let error = error {
                    reject(error)
                }else{
                    guard let documentData = snapshot?.data() else { return }
                    fulfill(documentData)
                }
            }
        }
    }
    public func updateField(
        collection: String,
        id: String,
        fieldName: String,
        fieldValue: Any,
        parentRef:DocumentReference? = nil
        )->Promise<Bool> {
        return Promise<Bool>{(fulfill,reject) in
            self.setCount = self.setCount + 1;
            if (parentRef != nil)
            {
                parentRef?
                    .collection(collection).document(id).updateData([fieldName: fieldValue], completion: { (error) in
                        fulfill(true)
                    })
            }
            else
            {
                
            self.db
                .collection(collection).document(id).updateData([fieldName: fieldValue], completion: { (error) in
                    fulfill(true)
                })
              
            }
        }
    }
    public func updateDocument(){
        //TODO:
    }
    public func deleteDocument(){
        //TODO:
    }
 
   
}

    
//    queryDocuments(
//    collection: string,
//    filters?: FireStoreFilter[],
//    orderby?: FireStoreOrderby,
//    lastSnapShot?: firebase.firestore.DocumentSnapshot,
//    defaultLoadAmount: number = 10,
//    parentRef?: firebase.firestore.DocumentReference
//    ) {
//    LoaderStore.isLoading = true;
//    console.log(
//    "[Firestore] queryDocument",
//    collection,
//    filters,
//    orderby,
//    lastSnapShot,
//    defaultLoadAmount
//    );
//    this.queryCount++;
//    if (defaultLoadAmount == null) {
//    defaultLoadAmount = 100000;
//    }
//    if (parentRef) var collectionRef = parentRef.collection(collection);
//    else collectionRef = this.db.collection(collection);
//    var query = collectionRef.limit(defaultLoadAmount);
//    //orderby
//    if (orderby) query = orderby.applyTo(query);
//    //filters, one range and equals
//    if (filters && filters.length > 0) {
//    for (var i = 0; i < filters.length; i++) {
//    query = filters[i].applyTo(query);
//    }
//    }
//    //pagination
//    if (lastSnapShot) query = query.startAfter(lastSnapShot);
//
//    return query.get().then(snapshot => {
//    LoaderStore.isLoading = false;
//    return snapshot;
//    });
//    }

