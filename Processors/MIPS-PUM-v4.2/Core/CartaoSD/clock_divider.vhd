library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
port (
    iCLK    : in    std_logic;
    iRst    : in    std_logic;
    iSpeed  : in    std_logic;
    oCLK    : out   std_logic

);

end clk_divider;


architecture behavioral of clk_divider is

    signal clk_counter  : integer   := 0;
    signal tmp          : std_logic := '1';

begin
    process(iCLK, iRst)                                    -- Divisor de clock
    begin
        if rising_edge(iCLK) then
            if (iRst = '1') then
                tmp         <= '1';
                clk_counter <= 0;
            elsif (iSpeed = '1') then
                tmp         <= not tmp;
            elsif (clk_counter = 65) then
                tmp         <= not tmp;
                clk_counter <= 0;
            else
                clk_counter <= clk_counter + 1;
            end if;
        end if;
        oCLK    <= tmp;
    end process;
end behavioral;
