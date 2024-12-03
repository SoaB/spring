const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;

pub fn add(a: rl.Vector2, b: rl.Vector2) rl.Vector2 {
    return rl.Vector2{
        .x = a.x + b.x,
        .y = a.y + b.y,
    };
}

pub fn sub(a: rl.Vector2, b: rl.Vector2) rl.Vector2 {
    return rl.Vector2{
        .x = a.x - b.x,
        .y = a.y - b.y,
    };
}

pub fn scale(a: rl.Vector2, scalar: f32) rl.Vector2 {
    return rl.Vector2{
        .x = a.x * scalar,
        .y = a.y * scalar,
    };
}

pub fn dotProduct(a: rl.Vector2, b: rl.Vector2) f32 {
    return a.x * b.x + a.y * b.y;
}

pub fn magnitude(a: rl.Vector2) f32 {
    return math.sqrt(a.x * a.x + a.y * a.y);
}

pub fn normalize(a: rl.Vector2) rl.Vector2 {
    const mag = magnitude(a);
    return rl.Vector2{
        .x = a.x / mag,
        .y = a.y / mag,
    };
}
