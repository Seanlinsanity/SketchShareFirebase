//
//  SketchShareMetal.metal
//  SketchShareMetal
//
//  Created by 詹易衡 on 2018/7/23.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


vertex float4 basic_vertex(                           // 1
    const device packed_float3* vertex_array [[ buffer(0) ]], // 2
    unsigned int vid [[ vertex_id ]]) {                 // 3
    return float4(vertex_array[vid], 1.0);              // 4
}

fragment half4 basic_fragment() { // 1
    return half4(1.0);              // 2
}
