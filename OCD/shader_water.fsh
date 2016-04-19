//void main(void)
//{
////    vec2 uv = gl_FragCoord.xy / size.xy;
//    
////    uv.y += (cos((uv.y + (u_time * 0.08)) * 85.0) * 0.0019) +
////    (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);
////    
////    uv.x += (sin((uv.y + (u_time * 0.13)) * 55.0) * 0.0029) +
////    (sin((uv.y + (u_time * 0.1)) * 15.0) * 0.002);
//    
//    v_text_coord.x = sin(u_time)
//    
////    vec4 texColor = texture2D(customTexture,v_tex_coord);
//    gl_FragColor = texColor;
//}

//[Vertex_Shader]
//void main()
//{
//    gl_TexCoord[0] = gl_MultiTexCoord0;
//    gl_Position = ftransform();
//}
//[Pixel_Shader]
//uniform vec2 resolution; // Screen resolution
//uniform float time; // time in seconds
//uniform sampler2D tex0; // scene buffer
//void main(void)
//{
//    vec2 tc = gl_TexCoord[0].xy;
//    vec2 p = -1.0 + 2.0 * tc;
//    float len = length(p);
//    vec2 uv = tc + (p/len)*cos(len*12.0-time*4.0)*0.03;
//    vec3 col = texture2D(tex0,uv).xyz;
//    gl_FragColor = vec4(col,1.0);
//}

void main ()
{
    vec2 uv = v_tex_coord;

    uv.y += (cos((uv.y + (u_time * 0.08)) * 85.0) * 0.0019) +
    (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);
    
    uv.x += (sin((uv.y + (u_time * 0.13)) * 55.0) * 0.0029) +
    (sin((uv.y + (u_time * 0.1)) * 15.0) * 0.002);
    
    vec4 texColor = texture2D(u_texture,uv);
    gl_FragColor = texColor;
}