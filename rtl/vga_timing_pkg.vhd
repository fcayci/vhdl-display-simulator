-- author: Furkan Cayci, 2019
-- description: holds timing information

library ieee;
use ieee.std_logic_1164.all;

package vga_timing_pkg is

    type video_timing_type is record
        H_VIDEO : integer;
        H_FP    : integer;
        H_SYNC  : integer;
        H_BP    : integer;
        H_TOTAL : integer;
        V_VIDEO : integer;
        V_FP    : integer;
        V_SYNC  : integer;
        V_BP    : integer;
        V_TOTAL : integer;
        H_POL   : std_logic;
        V_POL   : std_logic;
        ACTIVE  : std_logic;
    end record;

-- HD1080p timing
--      screen area 1920x1080 @60 Hz
--      horizontal : 1920 visible + 88 front porch (fp) + 44 hsync + 148 back porch = 2200 pixels
--      vertical   : 1080 visible +  4 front porch (fp) +  5 vsync +  36 back porch = 1125 pixels
--      Total area 2200x1125
--      clk input should be 148.5 MHz signal (2200 * 1125 * 60)
--      hsync and vsync are positive polarity

    constant HD1080P_TIMING : video_timing_type := (
        H_VIDEO => 1920,
        H_FP    =>   88,
        H_SYNC  =>   44,
        H_BP    =>  148,
        H_TOTAL => 2200,
        V_VIDEO => 1080,
        V_FP    =>    4,
        V_SYNC  =>    5,
        V_BP    =>   36,
        V_TOTAL => 1125,
        H_POL   =>  '1',
        V_POL   =>  '1',
        ACTIVE  =>  '1'
    );

-- HD720p timing
--      screen area 1280x720 @60 Hz
--      horizontal : 1280 visible + 72 front porch (fp) + 80 hsync + 216 back porch = 1648 pixels
--      vertical   :  720 visible +  3 front porch (fp) +  5 vsync +  22 back porch =  750 pixels
--      Total area 1648x750
--      clk input should be 74.25 MHz signal (1650 * 750 * 60)
--      hsync and vsync are positive polarity

    constant HD720P_TIMING : video_timing_type := (
        H_VIDEO => 1280,
        H_FP    =>   72,
        H_SYNC  =>   80,
        H_BP    =>  216,
        H_TOTAL => 1648,
        V_VIDEO =>  720,
        V_FP    =>    3,
        V_SYNC  =>    5,
        V_BP    =>   22,
        V_TOTAL =>  750,
        H_POL   =>  '1',
        V_POL   =>  '1',
        ACTIVE  =>  '1'
    );

-- SVGA timing
--      screen area 800x600 @60 Hz
--      horizontal : 800 visible + 40 front porch (fp) + 128 hsync + 88 back porch = 1056 pixels
--      vertical   : 600 visible +  1 front porch (fp) +   4 vsync + 23 back porch =  628 pixels
--      Total area 1056x628
--      clk input should be 40 MHz signal (1056 * 628 * 60)
--      hsync and vsync are positive polarity

    constant SVGA_TIMING : video_timing_type := (
        H_VIDEO =>  800,
        H_FP    =>   40,
        H_SYNC  =>  128,
        H_BP    =>   88,
        H_TOTAL => 1056,
        V_VIDEO =>  600,
        V_FP    =>    1,
        V_SYNC  =>    4,
        V_BP    =>   23,
        V_TOTAL =>  628,
        H_POL   =>  '1',
        V_POL   =>  '1',
        ACTIVE  =>  '1'
    );

-- VGA timing
--      screen area 640x480 @60 Hz
--      horizontal : 640 visible + 16 front porch (fp) + 96 hsync + 48 back porch = 800 pixels
--      vertical   : 480 visible + 10 front porch (fp) +  2 vsync + 33 back porch = 525 pixels
--      Total area 800x525
--      clk input should be 25 MHz signal (800 * 525 * 60)
--      hsync and vsync are negative polarity

    constant VGA_TIMING : video_timing_type := (
        H_VIDEO =>  640,
        H_FP    =>   16,
        H_SYNC  =>   96,
        H_BP    =>   48,
        H_TOTAL =>  800,
        V_VIDEO =>  480,
        V_FP    =>   10,
        V_SYNC  =>    2,
        V_BP    =>   33,
        V_TOTAL =>  525,
        H_POL   =>  '0',
        V_POL   =>  '0',
        ACTIVE  =>  '1'
    );

end package vga_timing_pkg;

package body vga_timing_pkg is
end package body vga_timing_pkg;
