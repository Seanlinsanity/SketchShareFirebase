//
//  FirestoreObject.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseFirestore
open class FirestoreObject<T:FirestoreDocument>:FirebaseObjectProtocol{
    var collection: String = ""
    var _id: String = ""
    var id:String {
        return self._id;
    }
    
    public init(collection: String?, id: String?) {
        if(id != nil)
        {self._id = id!;}
        if ((collection) != nil) {
            self.collection = collection!;
            self.bind();
        }
    }
   
    var parentRef: DocumentReference!
    
    public func bindID(id: String) {
        self._id = id
    }
    
 
    public func bind(){
        if((self.brief) != nil)
        {
            self.brief.bindObj = self
        }
    }
    public var brief:FirebaseModel!
}
//
///**
// * 繼承FirestoreObject之前必須先做幾件事
// * @export
// * @class FirestoreObject
// * @template T
// */
//class FirestoreObject<T:FirestoreDocument>:FirebaseObjectBase
//implements IFirebaseObject {
//    indexInLoader: number;
//    constructor(collection?: string, id?: string) {
//        super(collection, id);
//        if (collection) {
//            this.bind();
//        }
//    }
//
//    /**
//     * 連接物件的document id
//     *
//     * @param {string} val
//     * @memberof FirestoreObject
//     */
//    bindID(val: string) {
//        this._id = val;
//        this.bind();
//    }
//    /**
//     *
//     * 存放在firestore中的FirestoreDocument，作為query用
//     * @type {T}
//     * @memberof FirestoreObject
//     */
//    doc?: T; //store in "FireStore"
//
//    /**
//     *
//     * 基本的資料
//     * store in realtime database
//     * @type {FirebaseModel}
//     * @memberof FirestoreObject
//     */
//    brief?: FirebaseModel;
//
//    /**
//     * 細節資料，顯示物件頁面
//     * store in realtime database
//     * @type {FirebaseModel}
//     * @memberof FirestoreObject
//     */
//    detail?: FirebaseModel; //store in realtime database
//    @observable createdUser?: UserObject;
//    belongObj?: FirestoreObject<FirestoreDocument>;
//    bind() {
//        if (this.doc) this.doc.bind(this);
//        if (this.brief) this.brief.bind(this);
//        if (this.detail) this.detail.bind(this);
//    }
//    get root(): FirestoreObject {
//        if (this.belongObj.belongObj) {
//            return this.belongObj.root;
//        }
//        return this.belongObj;
//    }
//
//    get dbRef(): firebase.firestore.DocumentReference {
//        if (this.belongObj)
//        return this.belongObj.dbRef.collection(this.collection).doc(this.id);
//        return firestore.getDocumentRef(this.collection, this.id);
//    }
//    prepareObject() {
//        return this.findCreatedUser();
//    }
//    get parentRef() {
//        if (this.belongObj) return this.belongObj.dbRef;
//        else return undefined;
//    }
//
//    initDetail() {}
//    loadBrief() {
//        if (this.brief.loaded) return Promise.resolve(true);
//        else {
//            this.brief.bind(this);
//            return this.brief.getModel().then(success => {
//                if (success) this.prepareObject();
//                return success;
//                });
//        }
//    }
//    loadDetail() {
//        if (this.detail && this.detail.loaded) {
//            return Promise.resolve(true);
//        } else {
//            this.initDetail();
//            return this.detail.getModel();
//        }
//    }
//
//    findCreatedUser() {
//        //TODO:有些object沒有brief(relationObj，可能可以改)
//        if (this.collection == FirestoreCollection.User)
//        return PromiseUtility.nullPromise();
//        if (this.doc && !this.doc.created_by.isEmpty()) {
//            return userPool
//                .checkUserInUserPool(this.doc.created_by.val)
//                .then(user => {
//                    this.createdUser = user;
//                    return user;
//                    });
//        } else if (this.brief && !this.brief.created_by.isEmpty()) {
//            return userPool
//                .checkUserInUserPool(this.brief.created_by.val)
//                .then(user => {
//                    this.createdUser = user;
//                    return user;
//                    });
//        } else {
//            console.log("Can't get user...");
//            return PromiseUtility.nullPromise();
//        }
//    }
//
//    /**
//     *
//     * sugar function
//     * 快速地取得創造者名稱
//     * @returns
//     * @memberof FirebaseObject
//     */
//    @computed
//    get createdUserName() {
//        var userName = "匿名";
//        if (this.createdUser && this.createdUser.brief) {
//            userName = this.createdUser.brief.nick_name.val;
//        }
//        return userName;
//    }
//
//
//
//    //   if (this.belongObj) var ref = this.belongObj.dbRef;
//    get created_time_from_doc() {
//        var n = this.doc.created_at.val.toDate();
//        return moment(n).fromNow();
//    }
//    get created_time_string() {
//        var n = this.brief.created_at.val;
//        return moment(n).fromNow(); //n.toLocaleTimeString();
//        // var y = n.getFullYear();
//        // var m = n.getMonth() + 1;
//        // var d = n.getDate();
//        // return m + "/" + d + "/" + y;
//    }
//    delete() {
//        var p = [];
//
//        console.log("[FireStore Object] delete");
//        if (this.belongObj) {
//            p.push(this.dbRef.delete());
//            console.log("[FireStore Object] delete dbRef", this.dbRef.path);
//        } else {
//            if (this.doc) p.push(this.doc.deleteModel());
//        }
//
//        // if (this.brief) {
//        //   p.push(this.brief.deleteModel());
//        // }
//        // if (this.detail) {
//        //   p.push(this.detail.deleteModel());
//        // }
//        return Promise.all(p);
//    }
//    //TODO: static method?
//    deleteChildren(
//        ref: firebase.firestore.DocumentReference,
//        child_collection: string
//    ) {
//        var collection = ref.collection(child_collection);
//        console.log("[FireStore Object] deleteChildren", ref.path);
//        if (collection.id) {
//            console.log("[FireStore Object] collection", collection.id);
//            collection.get().then(query => {
//                query.docs.forEach(doc => {
//                    this.deleteChildren(doc.ref, child_collection);
//                    doc.ref.delete();
//                    });
//                });
//        }
//    }
//
//    static removeItemFromArray(
//    array: FirestoreObject[],
//    target: FirestoreObject
//    ) {
//        var index = array.findIndex(item => {
//            return item.id == target.id;
//            });
//        array.splice(index, 1);
//    }
//}
