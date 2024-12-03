const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const particle = @import("particle.zig").Particle;
const vec2 = @import("vec.zig");

pub const Spring = struct {
    k: f32,
    a: *particle,
    b: *particle,
    length: f32,

    pub fn init(k: f32, a: *particle, b: *particle, length: f32) Spring {
        return Spring{
            .k = k,
            .a = a,
            .b = b,
            .length = length,
        };
    }
    pub fn update(self: *Spring) void {
        var force = vec2.sub(self.b.pos, self.a.pos);
        const x = vec2.magnitude(force) - self.length;
        force = vec2.normalize(force);
        force = vec2.scale(force, self.k * x);
        self.a.applyForce(force);
        self.b.applyForce(vec2.scale(force, -1));
    }
    pub fn draw(self: *Spring) void {
        rl.DrawLineV(self.a.pos, self.b.pos, rl.RED);
    }
};
