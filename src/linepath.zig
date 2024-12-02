const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const rand = @import("rand.zig");
const MAX_LINE_COUNT = 5;
const MAX_THICKNESS = 3.0;
const MAX_LIFE_SPAN = 20.0;
const MAX_LINE_LENGTH = 50.0;

pub const LinePath = struct {
    pos: rl.Vector2,
    speed: rl.Vector2,
    color: rl.Color,
    thickness: f32,
    points: [MAX_LINE_COUNT]rl.Vector2,
    count: usize,
    lifeSpan: f32,
    timer: f32,
    pub fn init(pos: rl.Vector2) LinePath {
        var lp: LinePath = undefined;
        lp.pos = pos;
        lp.speed = .{ .x = rand.float32() * 2.0 - 1.0, .y = rand.float32() * 2.0 - 1.0 };
        lp.color = rl.ColorFromHSV(rand.float32() * 360.0, 1.0, 1.0);
        lp.thickness = rand.float32() * MAX_THICKNESS + 1.0;
        lp.points[0] = lp.pos;
        for (1..MAX_LINE_COUNT) |i| {
            const x: f32 = rand.float32() * 40.0 + lp.points[i - 1].x;
            const y: f32 = rand.float32() * 40.0 + lp.points[i - 1].y;
            lp.points[i] = .{ .x = x, .y = y };
        }
        lp.count = MAX_LINE_COUNT;
        lp.lifeSpan = MAX_LIFE_SPAN * @as(f32, @floatFromInt(MAX_LINE_COUNT));
        lp.timer = 0.0;
        return lp;
    }

    pub fn draw(self: *LinePath) void {
        rl.DrawLineEx(self.pos, self.points[0], self.thickness, self.color);
        for (0..self.count - 1) |i| {
            rl.DrawLineEx(self.points[i], self.points[i + 1], self.thickness, self.color);
        }
    }
    pub fn update(self: *LinePath) void {
        self.timer += 1;
        if (self.timer < self.lifeSpan) {
            self.pos.x += self.speed.x + rand.float32() * MAX_LINE_LENGTH - 25.0;
            self.pos.y += self.speed.y + rand.float32() * MAX_LINE_LENGTH - 25.0;
            pushPoints(self, self.pos);
        } else {
            if (self.count > 1) {
                popPoints(self);
            } else {
                const pos: rl.Vector2 = .{ .x = 400.0, .y = 300.0 };
                reset(self, pos);
            }
        }
    }
    fn pushPoints(self: *LinePath, pt: rl.Vector2) void {
        if (self.count == MAX_LINE_COUNT) {
            popPoints(self);
            self.points[self.count] = pt;
            self.count = self.count + 1;
        } else {
            self.points[self.count] = pt;
            self.count = self.count + 1;
        }
    }
    fn popPoints(self: *LinePath) void {
        for (0..self.count - 1) |i| {
            self.points[i] = self.points[i + 1];
        }
        self.count = self.count - 1;
    }
    fn reset(self: *LinePath, pos: rl.Vector2) void {
        self.timer = 0.0;
        self.pos = pos;
        self.speed = .{ .x = rand.float32() * 2.0 - 1.0, .y = rand.float32() * 2.0 - 1.0 };
        self.color = rl.ColorFromHSV(rand.float32() * 360.0, 1.0, 1.0);
        self.thickness = rand.float32() * MAX_THICKNESS + 1.0;
        self.points[0] = self.pos;
        for (1..MAX_LINE_COUNT) |i| {
            const x: f32 = rand.float32() * 40.0 + self.points[i - 1].x;
            const y: f32 = rand.float32() * 40.0 + self.points[i - 1].y;
            self.points[i] = .{ .x = x, .y = y };
        }
        self.count = MAX_LINE_COUNT;
        self.lifeSpan = MAX_LIFE_SPAN * @as(f32, @floatFromInt(MAX_LINE_COUNT));
    }
};
