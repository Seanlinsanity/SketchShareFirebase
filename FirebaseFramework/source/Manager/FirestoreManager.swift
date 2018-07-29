//
//  FirestoreManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseFirestore
import PromiseKit
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
    
    public func setDocument(collection: String, id: String, data: [String : Any], parentRef: DocumentReference?) -> Promise<[String : Any]> {
        
        return Promise<[String : Any]> { (seal) in
            self.setCount = self.setCount + 1
            if let ref = parentRef {
                ref.collection(collection).document(id).setData(data, completion: { (error) in
                    if let error = error {
                        seal.reject(error)
                    }else{
                        seal.fulfill(data)
                    }
                })
            }else{
                return self.db.collection(collection).document(id).setData(data, merge: true, completion: { (err) in
                    if let err = err {
                        seal.reject(err)
                    }else{
                        seal.fulfill(data)
                    }
                })
            }
        }


    }
    
    public func getDocument(collection: String, id: String) -> Promise<[String: Any]> {
        return Promise<[String: Any]> { (seal) in
            db.collection(collection).document(id).getDocument { (snapshot, error) in
                if let error = error {
                    seal.reject(error)
                }else{
                    guard let documentData = snapshot?.data() else { return }
                    seal.fulfill(documentData)
                }
            }
        }
    }
}
