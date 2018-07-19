//
//  ViewController.swift
//  SketchShareFirebase
//
//  Created by SEAN on 2018/7/11.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit
import FirebaseFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        firebaseManager.setValue(url: "test", obj: ["name": "Sean", "email": "sean@gmail.com"])
//        firebaseManager.configure()
//        firebaseManager.setValue(url: "test", obj: "test")

        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

