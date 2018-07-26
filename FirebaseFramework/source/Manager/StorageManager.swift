//
//  StorageManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/26.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
//
//class StorageManager {
//    init(){
//        this.storageRef = firebase.storage().ref();
//    }
//    
//    //storage的reference
//    storageRef: firebase.storage.Reference;
//    
//    //上傳圖片
//    uploadImage(folder: string, filename: string, data: string) {
//    var metadata = {
//    cacheControl: "public,max-age=3600"
//    };
//    console.log("UploadImage");
//    
//    var task = this.storageRef
//    .child(folder)
//    .child(filename)
//    .putString(data, "data_url", metadata);
//    
//    return task
//    .then(snapshot => {
//    return snapshot.downloadURL;
//    })
//    .catch(e => {
//    console.log("Upload Image Error", e);
//    });
//    }
//   
//   
//   
//    //下載檔案
//    downloadFile(url: string) {
//    return new Promise((resolve, reject) => {
//    var xhr = new XMLHttpRequest();
//    xhr.responseType = "blob";
//    
//    xhr.onload = function(event) {
//    var blob = xhr.response;
//    resolve(blob);
//    };
//    xhr.onreadystatechange = function() {
//    if (xhr.readyState === 4) {
//    //if complete
//    if (xhr.status === 200) {
//    //check if "OK" (200)
//    //success
//    } else {
//    //error
//    resolve(null);
//    }
//    }
//    };
//    xhr.open("GET", url);
//    xhr.send();
//    });
//    }
//}
