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
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    

    func initializeMetal(){
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = (view.layer?.frame)!  // 5
        view.layer?.addSublayer(metalLayer)   // 6
        
        //渲染的點資料
        let vertexData:[Float] = [
            0.0, 1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0]
        
        //創建渲染的緩衝
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        vertexBuffer = device?.makeBuffer(bytes: vertexData, length: dataSize, options: []) // 2
        
        // 讀取shader著色器並建立pipeline
        let defaultLibrary = device?.makeDefaultLibrary()!
        //        let frameworkBundle = Bundle(for: SketchShareMetalShaderFramework.self)
        //        guard let defaultLibrary = try? device.makeDefaultLibrary(bundle: frameworkBundle) else {
        //            fatalError("Could not load default library from specified bundle")
        //        }
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        
        // 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 3
        pipelineState = try! device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        //GPU 指令佇列
        commandQueue = device?.makeCommandQueue()
        draw()
    }
    
    public func draw() {
        print("draw")
        // TODO
        //guard let drawable = metalLayer?.nextDrawable() else { return }
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
            
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
            let commandBuffer = commandQueue.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder?.setRenderPipelineState(pipelineState)
            renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
            renderEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        
        
    }
    

}

