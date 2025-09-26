----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 09:23:48 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
        Port ( MemWrite: in std_logic;
               ALUResIn: in std_logic_vector(31 downto 0);
               rd2: in std_logic_vector(31 downto 0);
               clk: in std_logic;
               en: in std_logic;
               MemData: out std_logic_vector(31 downto 0);
               ALUResOut: out std_logic_vector(31 downto 0)); 
end MEM;

architecture Behavioral of MEM is
    type mem_type is array(0 to 63) of std_logic_vector(31 downto 0);
    signal mem: mem_type := (
        X"00000002", -- X = 2    (adresa 0)
        X"0000000A", -- Y = 10   (adresa 4)
        X"00000005", -- N = 5    (adresa 8)
        X"00000000", -- aici va fi rezultatul final  (adresa 12)
        X"00000002", -- nr_1 = 2   (adresa 16)
        X"00000001", -- nr_2 = 1   (adresa 20)
        X"00000004", -- nr_3 = 4   (adresa 24)
        X"0000000A", -- nr_4 = 10  (adresa 28)
        X"0000000F", -- nr_5 = 15  (adresa 32)  
        
        others => X"00000000");
    
    signal Address: std_logic_vector(5 downto 0);

begin
    Address <= ALUResIn(7 downto 2);

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' and MemWrite = '1' then
                mem(conv_integer(Address)) <= rd2;
            end if;
         end if;
     end process;
     
     MemData <= mem(conv_integer(Address));
     
     ALUResOut <= ALUResIn;

end Behavioral;
