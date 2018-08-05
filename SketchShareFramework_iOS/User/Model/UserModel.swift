//
//  UserModel.swift
//  SketchShareFirebase
//
//  Created by 詹易衡 on 2018/7/23.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
import FirebaseFramework

public class UserBrief : FirebaseBriefModel
{
    public let nick_name = FirebaseField()
    public let email = FirebaseField()
    public let avatar_url = FirebaseField()
}
