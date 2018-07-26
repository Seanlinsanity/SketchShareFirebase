//
//  Float.swift
//  SwiftGL
//
//  Created by Scott Bennett on 2014-06-08.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Darwin

public let Pi = Float(Double.pi)

public func radians(degrees: Float) -> Float {return degrees * Pi / 180}
public func degrees(radians: Float) -> Float {return radians * 180 / Pi}

public func sign(value: Float) -> Float {return (value > 0 ? 1 : (value < 0 ? -1 : 0))}

// Overload some mathematical functions to make them easier to call without having to worry about as many casts
//public func sqrt(value: Float)  -> Float {return sqrtf(value);}

public func sin(radians: Float) -> Float {return sinf(radians)}
public func cos(radians: Float) -> Float {return cosf(radians)}
public func tan(radians: Float) -> Float {return tanf(radians)}



public func sin(degrees: Float) -> Float {return sinf(radians(degrees: degrees))}
public func cos(degrees: Float) -> Float {return cosf(radians(degrees: degrees))}
public func tan(degrees: Float) -> Float {return tanf(radians(degrees: degrees))}

public func clamp(value: Float, min: Float, max: Float) -> Float {return value < min ? min : (value > max ? max : value)}
public func mix(a: Float, b: Float, t: Float) -> Float {return a + (b - a) * t}
public func smoothstep(a: Float, b: Float, t: Float) -> Float {return mix(a:a, b: b, t: clamp(value: t * t * (3 - 2 * t), min: 0, max: 1))}
