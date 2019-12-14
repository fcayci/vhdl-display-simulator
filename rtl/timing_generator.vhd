-- author: Furkan Cayci, 2018
-- description: video timing generator
--      choose between hd1080p, hd720p, svga, and vga

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.vga_timing_pkg.all;

entity timing_generator is
    generic (
        RESOLUTION   : string  := "HD720P"; -- hd1080p, hd720p, svga, vga
        GEN_PIX_LOC  : boolean := true;
        OBJECT_SIZE  : natural := 16
    );
    port(
        clk           : in  std_logic;
        hsync, vsync  : out std_logic;
        video_active  : out std_logic;
        pixel_x       : out std_logic_vector(OBJECT_SIZE-1 downto 0);
        pixel_y       : out std_logic_vector(OBJECT_SIZE-1 downto 0)
    );
end timing_generator;

architecture rtl of timing_generator is

    -- horizontal and vertical counters
    signal hcount : unsigned(OBJECT_SIZE-1 downto 0) := (others => '0');
    signal vcount : unsigned(OBJECT_SIZE-1 downto 0) := (others => '0');
    signal timings : video_timing_type := HD720P_TIMING;

begin

    timings <= HD1080P_TIMING when RESOLUTION = "HD1080P" else
               HD720P_TIMING when RESOLUTION = "HD720P" else
               SVGA_TIMING   when RESOLUTION = "SVGA"   else
               VGA_TIMING    when RESOLUTION = "VGA";

    -- pixel counters
    process (clk) is
    begin
        if rising_edge(clk) then
            if (hcount = timings.H_TOTAL) then
                hcount <= (others => '0');
                if (vcount = timings.V_TOTAL) then
                    vcount <= (others => '0');
                else
                    vcount <= vcount + 1;
                end if;
            else
                hcount <= hcount + 1;
            end if;
        end if;
    end process;

    -- generate video_active, hsync, and vsync signals based on the counters
    video_active <= timings.ACTIVE when (hcount < timings.H_VIDEO) and (vcount < timings.V_VIDEO ) else not timings.ACTIVE;
    hsync <= timings.H_POL when (hcount >= timings.H_VIDEO + timings.H_FP) and (hcount < timings.H_TOTAL - timings.H_BP) else not timings.H_POL;
    vsync <= timings.V_POL when (vcount >= timings.V_VIDEO + timings.V_FP) and (vcount < timings.V_TOTAL - timings.V_BP) else not timings.V_POL;

    g0: if GEN_PIX_LOC = true generate
    begin
        -- send pixel locations
        pixel_x <= std_logic_vector(hcount) when hcount < timings.H_VIDEO else (others => '0');
        pixel_y <= std_logic_vector(vcount) when vcount < timings.V_VIDEO else (others => '0');
    end generate;

    g1: if GEN_PIX_LOC = false generate
    begin
        -- send pixel locations
        pixel_x <= (others => '0');
        pixel_y <= (others => '0');
    end generate;
end rtl;
