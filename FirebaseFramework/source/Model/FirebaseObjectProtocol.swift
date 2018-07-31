//
//  FirebaseObjectProtocol.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/18.
//  Copyright © 2018年 詹易衡. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
protocol  FirebaseObjectProtocol{
    var collection: String{get set}
    var id: String{get set}
    //firestore object才需要
    var parentRef:DocumentReference!{get set}
    func bindID(id: String);
}
