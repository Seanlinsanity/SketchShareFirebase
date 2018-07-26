//
//  Texture.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-15.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
import OpenGL
#else
import OpenGLES
import ImageIO
import UIKit
#endif

public class Texture {
    public var id: GLuint
    public var width: GLsizei
    public var height: GLsizei
    public var filename:String!
    
    public init() {
        id = 0
        width = 0
        height = 0
        glGenTextures(1, &id)
        
        
    }
    public func check()->Bool
    {
        if glIsTexture(id) == GL_FALSE        {
            glGenTextures(1, &id)
            if filename != nil
            {
                load(filename: filename)
            }
            return false
        }
        return true
    }
    public convenience init(filename: String) {
        self.init()
        self.filename = filename
        print("load texture")
        if(load(filename: filename)){
        print("init texture success \(filename)")
        }
        else{
            print("init texture fail")
        }
        
    }
    public convenience init(image:UIImage)
    {
        self.init()
        glBindTexture(GL_TEXTURE_2D, id)
        load(image: image, antialias: true, flipVertical: true)
        
    }
    public convenience init(w:GLsizei,h:GLsizei)
    {
        self.init()
        
        self.width = w
        self.height = h
        
        setTextureParameter()
        
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE,nil);
    }
    
    deinit {
    //    print("deinit texture \(id)")
        glDeleteTextures(1, &id)
    }
    
    public func load(filename: String) -> Bool {
        return load(filename: filename, antialias: false, flipVertical: true)
    }
    
    public func load(filename: String, antialias: Bool) -> Bool {
        return load(filename: filename, antialias: antialias, flipVertical: true)
    }
    
    public func load(filename: String, flipVertical: Bool) -> Bool {
        return load(filename: filename, antialias: false, flipVertical: flipVertical)
    }
    
    /// @return true on success
    public func load(image:UIImage, antialias: Bool, flipVertical: Bool)->Bool
    {
        

        let cgImage = image.cgImage
        var	brushContext:CGContext
        // Get the width and height of the image
        
        var brushData:UnsafeMutableRawPointer
        // Make sure the image exists
        if(cgImage != nil) {
            width = GLsizei(cgImage!.width)
            height = GLsizei(cgImage!.width)
            // Allocate  memory needed for the bitmap context
            brushData = calloc(Int(width * height * 4),MemoryLayout<GLubyte>.size)
            // Use  the bitmatp creation function provided by the Core Graphics framework.
            
            brushContext = CGContext(data: brushData, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: Int(width * 4),space: CGColorSpaceCreateDeviceRGB() ,bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
            
            // After you create the context, you can draw the  image to the context.
            if flipVertical {
                brushContext.translateBy(x: 0, y: CGFloat.init(Int(height)))
                brushContext.scaleBy(x: 1, y:-1 )
            }
            
            brushContext.draw(cgImage!, in: CGRect.init(x:0.0,y: 0.0,width:CGFloat(width), height:CGFloat(height)))
            // You don't need the context at this point, so you need to release it to avoid memory leaks.
            
            // Bind the texture name.
            setTextureParameter()
            
            //glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
            // Specify a 2D texture image, providing the a pointer to the image data in memory
            
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE, brushData);
            
            // Release  the image data; it's no longer needed
            free(brushData);
            return true
        }
        return false
    }
    public func bind()
    {
        glBindTexture(GL_TEXTURE_2D, id);
    }
    public func empty()
    {
        glBindTexture(GL_TEXTURE_2D, id);
        
        //setTextureParameter()
        
        let pixel = calloc(Int(width * height * 4),MemoryLayout<GLubyte>.size)
        glTexSubImage2D(SwiftGL.GL_TEXTURE_2D, 0, 0, 0, width, height, GLenum(GL_RGBA), SwiftGL.GL_UNSIGNED_BYTE, pixel)
        
        free(pixel)
        
    }
    private func setTextureParameter()
    {
        glBindTexture(GL_TEXTURE_2D, id);
        // Set the texture parameters to use a minifying filter and a linear filer (weighted average)
        
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR);
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR);
        

        
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE);
        glTexParameteri(SwiftGL.GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE);
    }
    public func load(filename: String, antialias: Bool, flipVertical: Bool) -> Bool {
        
        if(load(image:UIImage(named: filename)!,antialias: antialias,flipVertical:flipVertical))
        {
            return true
        }
        
        /*
        /////
        let imageData = Texture.Load(filename: filename, width: &width, height: &height, flipVertical: flipVertical)
        
        glBindTexture(GL_TEXTURE_2D, id)
        
        if antialias {
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR_MIPMAP_LINEAR)
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        } else {
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MIN_FILTER), GL_NEAREST)
            glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_MAG_FILTER), GL_NEAREST)
        }
        
        glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GL_TEXTURE_2D, GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        
        #if os(OSX)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GLenum(GL_BGRA), GLenum(GL_UNSIGNED_INT_8_8_8_8_REV), UnsafePointer(imageData))
        #else
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GLenum(GL_RGBA), GL_UNSIGNED_BYTE, UnsafePointer(imageData))
        #endif
        
        
        
        if antialias {
            glGenerateMipmap(GL_TEXTURE_2D)
        }
        
        free(imageData)
        return false
        
*/
        return false
    }
    
    private class func Load(filename: String,  width:inout  GLsizei, height: inout GLsizei, flipVertical: Bool) -> UnsafeMutableRawPointer {
        let url = CFBundleCopyResourceURL(CFBundleGetMainBundle(), filename as NSString, "" as CFString, nil)
        
        let imageSource = CGImageSourceCreateWithURL(url!, nil)
        let image = CGImageSourceCreateImageAtIndex(imageSource!, 0, nil)
        
        width  = GLsizei(image!.width)
        height = GLsizei(image!.height)
        
        let zero: CGFloat = 0
        
        let rect = CGRect(zero, zero, CGFloat(Int(width)), CGFloat(Int(height)))
        let colourSpace = CGColorSpaceCreateDeviceRGB()
        
        let imageData: UnsafeMutableRawPointer = malloc(Int(width * height * 4))
        
        
        let ctx = CGContext(data: imageData, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: Int(width * 4), space: colourSpace,bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        
        if flipVertical {
            CGContextTranslateCTM(ctx!, zero, CGFloat(Int(height)))
            CGContextScaleCTM(ctx!, 1, -1)
        }
        ctx!.setBlendMode(CGBlendMode.copy)
        CGContextDrawImage(ctx, rect, image)
        // The caller is required to free the imageData buffer
        return imageData
    }
}
