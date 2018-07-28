//
//  StorageManager.swift
//  FirebaseFramework
//
//  Created by 詹易衡 on 2018/7/26.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

public class FirebaseStorageManager {
    
    public func uploadImage(folder: String, filename: String, image: UIImage) -> Promise<StorageReference>{
        return Promise<StorageReference> { (seal) in
         
            guard let data = UIImageJPEGRepresentation(image, 1) else { return }
            let dataStorageRef = Storage.storage().reference().child(folder).child(filename)
            
            dataStorageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    seal.reject(error)
                }else{
                    seal.fulfill(dataStorageRef)
                }
            })
        }
    }
    
    public func getDownloadUrl(dataStorageRef: StorageReference) -> Promise<String> {
        return Promise<String> { (seal) in
            dataStorageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    seal.reject(err)
                }else{
                    guard let downloadurl = url?.absoluteString else { return }
                    seal.fulfill(downloadurl)
                }
            })
        }
    }
    
    public func downloadFile(url: String) -> Promise<UIImage> {
        return Promise<UIImage> { (seal) in
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                }else{
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    seal.fulfill(image)
                }
            }).resume()
        }
    }
    

}

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
