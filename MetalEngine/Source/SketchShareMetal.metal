//
//  SketchShareMetal.metal
//  SketchShareMetal
//
//  Created by 詹易衡 on 2018/7/23.
//  Copyright © 2018年 com.sketchshare. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


//vertex float4 basic_vertex(                           // 1
//    const device packed_float3* vertex_array [[ buffer(0) ]], // 2
//    unsigned int vid [[ vertex_id ]]) {                 // 3
//    return float4(vertex_array[vid], 1.0);              // 4
//}

//fragment half4 basic_fragment() { // 1
//    return half4(1.0);              // 2
//}


struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];  //1
    float4 color;
};

vertex VertexOut basic_vertex(                           // 1
  const device VertexIn* vertex_array [[ buffer(0) ]],   // 2
  unsigned int vid [[ vertex_id ]]) {

    VertexIn vIn = vertex_array[vid];                 // 3

    VertexOut vo;
    vo.position = float4(vIn.position,1);
    vo.color = vIn.color;                       // 4

    return vo;
}

fragment half4 basic_fragment(VertexOut interpolated [[stage_in]]) {  //1
    return half4(interpolated.color[2], interpolated.color[1], interpolated.color[2], interpolated.color[3]); //2
}
