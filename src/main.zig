const rl = @cImport({
    @cDefine("SUPPORT_GIF_RECORDING", "1");
    @cInclude("Raylib.h");
});

const std = @import("std");
const math = std.math;
const print = std.debug.print;
const springEff = @import("effspring.zig").SpringEffector;
const rand = @import("rand.zig");

const scrWidth = 800;
const scrHeight = 600;

pub fn main() !void {
    rand.init();
    rl.InitWindow(scrWidth, scrHeight, "Noise for FUN");
    rl.SetTargetFPS(60);
    springEff.init(scrWidth, scrHeight);
    const dt = 1.0 / 60.0;
    while (!rl.WindowShouldClose()) {
        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);
        rl.BeginBlendMode(rl.BLEND_ADDITIVE);
        springEff.draw();
        springEff.update(dt);
        rl.EndBlendMode();
        rl.EndDrawing();
    }
    rl.CloseWindow();
}
