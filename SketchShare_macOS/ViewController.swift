//
//  ViewController.swift
//  SketchShare_macOS
//
//  Created by 詹易衡 on 2018/7/24.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Cocoa
import SketchShareMetal_macOS
import Metal
import MetalKit
class ViewController: NSViewController {
    
    override func viewWillAppear() {
        view.addSubview(MetalRenderView(frame: view.frame))
    }
    override func touchesMoved(with event: NSEvent) {
        print("touch",event)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        initializeMetal()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

