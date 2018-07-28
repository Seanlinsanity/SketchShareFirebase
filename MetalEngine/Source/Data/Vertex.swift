//
//  Vertex.swift
//  SketchShareMetal_macOS
//
//  Created by 詹易衡 on 2018/7/25.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
}
