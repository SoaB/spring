const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const rand = @import("rand.zig");
const spring = @import("spring.zig").Spring;
const particle = @import("particle.zig").Particle;
const vec2 = @import("vec.zig");

// ------------------------------------------------
const MAX_PARTICLES = 1000;
const MAX_SPRINGS = 1000;
pub const SpringEffector = struct {
    var springs: [MAX_SPRINGS]spring = undefined;
    var particles: [MAX_PARTICLES]particle = undefined;
    var k: f32 = 0.1;
    var gravity: rl.Vector2 = rl.Vector2{ 0, -9.81 };
    var w: f32 = 800;
    var h: f32 = 600;
    var visibleSpringsLine: bool = true;
    pub fn init(width: u32, height: u32) void {
        w = @as(f32, @floatFromInt(width));
        h = @as(f32, @floatFromInt(height));
        for (0..MAX_PARTICLES) |i| {
            const x = rand.float32() * w;
            const y = rand.float32() * h;
            const pos: rl.Vector2 = rl.Vector2{ .x = x, .y = y };
            particles[i] = particle.init(pos);
        }
        for (0..MAX_SPRINGS) |i| {
            var b = rand.uint32() % MAX_PARTICLES;
            while (b == i) {
                b = rand.uint32() % MAX_PARTICLES;
            }
            const length = rand.float32() * 50 + 50;
            springs[i] = spring.init(k, &particles[i], &particles[b], length);
        }
    }
    pub fn update(dt: f32) void {
        if (rl.IsKeyPressed(rl.KEY_R)) {
            reset();
        }
        if (rl.IsKeyPressed(rl.KEY_SPACE)) {
            visibleSpringsLine = !visibleSpringsLine;
        }
        for (0..MAX_SPRINGS) |i| {
            springs[i].update();
        }
        for (0..MAX_PARTICLES) |i| {
            particles[i].update(dt);
        }
    }
    pub fn draw() void {
        if (visibleSpringsLine) {
            for (0..MAX_SPRINGS) |i| {
                springs[i].draw();
            }
        }
        for (0..MAX_PARTICLES) |i| {
            particles[i].draw();
        }
    }
    pub fn reset() void {
        for (0..MAX_PARTICLES) |i| {
            const x = rand.float32() * w;
            const y = rand.float32() * h;
            const pos: rl.Vector2 = rl.Vector2{ .x = x, .y = y };
            particles[i] = particle.init(pos);
        }
        for (0..MAX_SPRINGS) |i| {
            var b = rand.uint32() % MAX_PARTICLES;
            while (b == i) {
                b = rand.uint32() % MAX_PARTICLES;
            }
            const length = rand.float32() * 50 + 50;
            springs[i] = spring.init(k, &particles[i], &particles[b], length);
        }
    }
};
