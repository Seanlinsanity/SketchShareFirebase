//
//  SketchShareMetalRenderer.swift
//  SketchShareFramework
//
//  Created by 詹易衡 on 2018/7/24.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import Cocoa
open class MetalRenderView:MTKView,MTKViewDelegate{
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("size change")
    }
    
 

//    var vertexBuffer: MTLBuffer!
    var objectToDraw: Node!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    public init(frame frameRect:CGRect) {
        let device = MTLCreateSystemDefaultDevice()
        super.init(frame: frameRect, device: device)
        self.device = device
        delegate = self
        initializeMetal()
    }
    
    required public init(coder: NSCoder) {
        let device = MTLCreateSystemDefaultDevice()
        super.init(coder: coder)
        self.device = device
        delegate = self
        initializeMetal()
    }
    func initializeMetal(){
       enableSetNeedsDisplay = true
//        metalLayer = CAMetalLayer()          // 1
//        metalLayer.device = device           // 2
//        metalLayer.pixelFormat = .bgra8Unorm // 3
//        metalLayer.framebufferOnly = true    // 4
//        metalLayer.frame = (view.layer.frame)  // 5
//        view.layer.addSublayer(metalLayer)   // 6
        
        //渲染的點資料
        let vertexData:[Float] = [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0]
        
//        //創建渲染的緩衝
//        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
//        vertexBuffer = device?.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2
//        objectToDraw = Triangle(device: device!)
        objectToDraw = Cube(device: device!)
        // 讀取shader著色器並建立pipeline
        // let defaultLibrary = device?.makeDefaultLibrary()!
        //將Shader code包在Framework之中：當Shader的target和執行app不同時，必須用bundle去找，將for:Class宣告在framework中
        let frameworkBundle = Bundle(for: SketchShareMetalShaderFramework.self)
        guard let defaultLibrary = try? device?.makeDefaultLibrary(bundle: frameworkBundle) else {
            fatalError("Could not load default library from specified bundle")
        }
       
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
         let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        // 2 渲染流程
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        pipelineState = try! device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        //產生GPU 指令佇列
        commandQueue = device?.makeCommandQueue()
    }
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
          objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
    }
    override open func mouseDragged(with event: NSEvent) {
        let location = event.locationInWindow
        let delta = CGPoint(x:event.deltaX, y:event.deltaY)
        event.pressure
        print("eee")
    }
    
    
}
open class SketchShareMetalShaderFramework {}
