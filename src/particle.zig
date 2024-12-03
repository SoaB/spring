const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const rand = @import("rand.zig");
const vec2 = @import("vec.zig");
pub const Particle = struct {
    pos: rl.Vector2,
    vel: rl.Vector2,
    acc: rl.Vector2,
    color: rl.Color,
    locked: bool,
    mass: f32,

    pub fn init(pos: rl.Vector2) Particle {
        return Particle{
            .pos = pos,
            .vel = rl.Vector2{ .x = rand.float32() * 2 - 1, .y = rand.float32() * 2 - 1 },
            .acc = rl.Vector2{ .x = 0, .y = 0 },
            .color = rl.ColorFromHSV(rand.float32() * 360.0, 1.0, 1.0),
            .locked = if (rand.float32() < 0.1) true else false,
            .mass = 1.0,
        };
    }
    pub fn applyForce(p: *Particle, force: rl.Vector2) void {
        var f = force;
        f = vec2.scale(f, 1.0 / p.mass);
        p.acc = vec2.add(p.acc, f);
    }
    pub fn update(p: *Particle, dt: f32) void {
        _ = dt;
        if (!p.locked) {
            p.vel = vec2.scale(p.vel, 0.985);
            p.vel = vec2.add(p.vel, p.acc);
            p.pos = vec2.add(p.pos, p.vel);
            p.acc = rl.Vector2{ .x = 0, .y = 0 };
        }
    }
    pub fn draw(p: *Particle) void {
        rl.DrawCircleV(p.pos, 5, p.color);
    }
};
