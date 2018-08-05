//
//  UserObject.swift
//  SketchShareFramework
//
//  Created by 詹易衡 on 2018/7/26.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

//import Foundation
import FirebaseFramework
public class UserObject : FirestoreObject<FirestoreDocument>
{
    private override init(collection: String?, id: String?) {
        super.init(collection: collection,id:id)
        self.brief = UserBrief()
        self.bind()
    }
    public convenience init() {
        self.init(collection: "users", id: nil)
        
    }
    public convenience init(id:String?) {
        self.init(collection: "users", id: id)
    }
    var userBrief: UserBrief {
        return self.brief as! UserBrief
    }
    
}
