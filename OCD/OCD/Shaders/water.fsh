void main ()
{
    vec2 uv = v_tex_coord;

    float dy = (cos((uv.y + (u_time * 0.08)) * 85.0) * 0.0019) + (cos((uv.y + (u_time * 0.1)) * 10.0) * 0.002);
    float dx = (sin((uv.y + (u_time * 0.13)) * 55.0) * 0.0029) + (sin((uv.y + (u_time * 0.1)) * 15.0) * 0.002);

    uv.y += dy * 0.25;
    uv.x += dx * 0.25;

    vec4 texColor = texture2D(u_texture,uv);
    gl_FragColor = texColor;
}
