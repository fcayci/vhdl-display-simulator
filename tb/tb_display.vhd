-- author: Furkan Cayci, 2018
-- description: display testbench
--   generates a txt file to display on html canvas
--   only supports 24-bit RGB values

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_display is
end tb_display;

architecture rtl of tb_display is

    constant RESOLUTION : string := "HD720P"; -- HD720P, SVGA, VGA
    constant GEN_PIX_LOC : boolean := true;
    constant OBJECT_SIZE : natural := 16;
    constant PIXEL_SIZE : natural := 24;
    constant clk_period : time := 8 ns;
    constant reset_time : time := 204 ns;
    constant frame_time : time := 9.6 ms;

    signal clk          : std_logic;
    signal hsync, vsync : std_logic;
    signal video_active : std_logic;
    signal rgb          : std_logic_vector(PIXEL_SIZE-1 downto 0);
    signal pixel_x      : std_logic_vector(OBJECT_SIZE-1 downto 0);
    signal pixel_y      : std_logic_vector(OBJECT_SIZE-1 downto 0);

    -- change the object locations
    signal object1x : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(500, OBJECT_SIZE));
    signal object1y : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(140, OBJECT_SIZE));
    signal object2x : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(240, OBJECT_SIZE));
    signal object2y : std_logic_vector(OBJECT_SIZE-1 downto 0) := std_logic_vector(to_unsigned(340, OBJECT_SIZE));
    signal backgrnd_rgb : std_logic_vector(PIXEL_SIZE-1 downto 0) := x"FFFF00"; -- yellow

begin

    -- timing generator
    u_t : entity work.timing_generator(rtl)
        generic map (RESOLUTION=>RESOLUTION, GEN_PIX_LOC=>GEN_PIX_LOC,
                     OBJECT_SIZE=>OBJECT_SIZE)
        port map (clk=>clk, hsync=>hsync, vsync=>vsync, video_active=>video_active,
                  pixel_x=>pixel_x, pixel_y=>pixel_y);

    -- connect pattern generator
    -- uut0 : entity work.pattern_generator(rtl)
    --     port map(clk=>clk, video_active=>video_active, rgb=>rgb);

    -- connect object buffer
    uut0 : entity work.objectbuffer(rtl)
        generic map (OBJECT_SIZE=>OBJECT_SIZE, PIXEL_SIZE=>PIXEL_SIZE)
        port map (video_active=>video_active, pixel_x=>pixel_x, pixel_y=>pixel_y,
                  object1x=>object1x, object1y=>object1y,
                  object2x=>object2x, object2y=>object2y,
                  backgrnd_rgb=>backgrnd_rgb, rgb=>rgb);

    -- generate clock
    clk_generate:
    process
    begin
        for i in 0 to frame_time / clk_period loop
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
            clk <= '0';
        end loop;
        wait;
    end process;

    -- record values
    process(clk) is
        file     DISP_FILE : text open write_mode is "rgb.txt";
        variable DISP_LINE : line;
        variable h : std_logic := '0';
    begin
        if rising_edge(clk) then
            if video_active = '1' then
                write(DISP_LINE, to_integer(unsigned(rgb)));
                write(DISP_LINE, ',');
                h := '1';
            end if;

            -- Note that in VGA hsync polarity should be reversed
            if hsync = '1' and h = '1' then
                h := '0';
                writeline(DISP_FILE, DISP_LINE);
            end if;

            -- Note that in VGA vsync polarity should be reversed
            if vsync = '1' then
                assert false report "completed...ignore following error messages" severity FAILURE;
            end if;
        end if;
    end process;

end rtl;