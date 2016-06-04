library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
port (
    iClock  : in    std_logic;
    iReset  : in    std_logic;
    iSpeed  : in    std_logic;
    oClock  : out   std_logic

);

end clk_divider;


architecture behavioral of clk_divider is

    signal clk_counter  : integer   := 0;
    signal tmp          : std_logic := '0';

begin
    process(iClock, iReset)                                    -- Divisor de clock
    begin
        if rising_edge(iClock) then
            if (iReset = '1') then
                tmp         <= '1';
                clk_counter <= 0;
            elsif (iSpeed = '1' and clk_counter = 2) then       -- DEBUG: Testar valores entre 1 e 3
                tmp         <= not tmp;
                clk_counter <= 0;
            elsif (iSpeed = '0' and clk_counter = 125) then     -- DEBUG: Testar valores entre 60 e 200
                tmp         <= not tmp;
                clk_counter <= 0;
            else
                clk_counter <= clk_counter + 1;
            end if;

            -- elsif (iSpeed = '1') then
            --     if (clk_counter = 1) then
            --         clk_counter <= 0;
            --         tmp         <= not tmp;
            --     else
            --         clk_counter <= clk_counter + 1;
            --     end if;
            -- elsif (clk_counter = 128) then
            --     tmp         <= not tmp;
            --     clk_counter <= 0;
            -- else
            --     clk_counter <= clk_counter + 1;
            -- end if;
        end if;
    end process;

    oClock  <= tmp;

end behavioral;
