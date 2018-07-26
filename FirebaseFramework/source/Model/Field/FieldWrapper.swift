//
//  FieldWrapper.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/23.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

class FieldWrapper<T>{
    init(val:T?)
    {
        if(val != nil)
        {
            self._val = val
        }
    }
    private var _val:T?
    var val: T? {
        return _val
    }
}
