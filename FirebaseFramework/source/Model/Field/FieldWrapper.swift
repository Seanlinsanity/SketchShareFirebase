//
//  FieldWrapper.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/23.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

open class FieldWrapper{
    public init(val:Any?)
    {
        if(val != nil)
        {
            self._val = val
        }
    }
    private var _val:Any!

    public var val: Any! {
        get {
            return _val
        }
        set {
            self._val = newValue;
            self.dirty = true;
        }
    }
    var dirty = false;
    var isFloat:Bool {
        get{
            return type(of: self.val) == Float.self
        }
    }
    
    var isString:Bool{
        get{
            return type(of: self.val) == String.self
        }
    }
    
    
    var isEmpty:Bool{
        get{
            if(self.val==nil)
            {return true}
            else
            {
                if (self.isString) {
                    let v = self.val as! String;
                    let trimmedString = v.trimmingCharacters(in: .whitespacesAndNewlines)
                    return trimmedString.count==0
                }
                return false
            }
        }
    }
   
//    func validateEmail(email) {
//    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
//    return re.test(email);
//    }
//    validateUrl(value) {
//    return /^(?:(?:(?:https?|ftp):)?\/\/)(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:[/?#]\S*)?$/i.test(
//    value
//    );
//    }
    
//    startCheckValid() {
//    this.checkOnChange = true;
//    return this.checkValid();
//    }
//    checkValid() {
//    if (!this.checkOnChange) return;
//    if (this.isString(this.val)) {
//    var value = this.val;
//    switch (this.checkValidType) {
//    case "email":
//    this.valid = this.validateEmail(value);
//    break;
//    case "empty":
//    this.valid = value != null && value !== "";
//    break;
//    }
//    return this.valid;
//    }
//    }
//    toString() {
//    return new String(this.val).toString();
//    }
//    checkValidType: CheckValidType = "empty";
//    @observable valid: boolean;
}
