----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 10:19:09 AM
-- Design Name: 
-- Module Name: I_Decode - Behavioral
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

entity ID_pipeline is
      Port (instr: in std_logic_vector(25 downto 0);
            RegWr: in std_logic;
            WA: in std_logic_vector(4 downto 0);
            EN: in std_logic;
            ExtOp: in std_logic;
            WD: in std_logic_vector(31 downto 0);
            clk: in std_logic;
            RD1: out std_logic_vector(31 downto 0);
            RD2: out std_logic_vector(31 downto 0);
            Ext_Imm: out std_logic_vector(31 downto 0);
            func: out std_logic_vector(5 downto 0);
            sa: out std_logic_vector(4 downto 0);
            rt: out std_logic_vector(4 downto 0);
            rd: out std_logic_vector(4 downto 0));
      
end ID_pipeline;

architecture Behavioral of ID_pipeline is
    signal ra1, ra2: std_logic_vector(4 downto 0) := (others => '0');
    
    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : reg_array:= (
            others => X"00000000");   

begin
    ra1 <= instr(25 downto 21);
    ra2 <= instr(20 downto 16);
         
    RD1 <= reg_file(conv_integer(ra1));
    RD2 <= reg_file(conv_integer(ra2));
    
    reg_file_process: process(clk)
                      begin
                         if falling_edge(clk) then
                            if EN = '1' and RegWr = '1' then
                                reg_file(conv_integer(WA)) <= WD;
                             end if;
                         end if;
                       end process;
                         
     func <= instr(5 downto 0);
     sa <= instr(10 downto 6);
     
     Ext_Imm(15 downto 0) <= instr(15 downto 0);
     Ext_Imm(31 downto 16) <= (others => instr(15)) when ExtOp = '1' else (others => '0');
                         
     rt <= instr(20 downto 16);
     rd <= instr(15 downto 11);

end Behavioral;
