----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2025 10:46:15 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
     Port (instr: in std_logic_vector(5 downto 0);
           RegDst: out std_logic;
           ExtOp: out std_logic;
           ALUSrc: out std_logic;
           Branch: out std_logic;
           Jump: out std_logic;
           ALUOp: out std_logic_vector(2 downto 0);
           MemWrite: out std_logic;
           MemToReg: out std_logic;
           RegWrite: out std_logic);
end UC;

architecture Behavioral of UC is

begin
    process(instr)
    begin
        RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0';
        Branch <= '0'; Jump <= '0'; ALUOp <= "000";
        MemWrite <= '0'; MemToReg <= '0'; RegWrite <= '0';
    
        case instr is
            -- type R
            when "000000" => RegDst <= '1'; RegWrite <= '1'; ALUOp <= "000";
            
            -- ADDI
            when "000001" => ExtOp <= '1'; ALUSrc <= '1'; RegWrite <= '1'; 
                             ALUOp <= "001";
                             
            -- LW                 
            when "000011" => ExtOp <= '1'; ALUSrc <= '1'; MemToReg <= '1'; RegWrite <= '1';
                             ALUOp <= "001";
                             
            -- SW                 
            when "000100" => ExtOp <= '1'; ALUSrc <= '1'; MemWrite <= '1'; 
                             ALUOp <= "001";
                             
            -- BEQ                 
            when "000101" => ExtOp <= '1'; Branch <= '1';
                              ALUOp <= "011";
                              
            -- SLTI                  
            when "000110" => ExtOp <= '1'; ALUSrc <= '1'; RegWrite <= '1';
                             ALUOp <= "100";
                             
            -- ANDI                 
            when "000010" => ALUSrc <= '1'; RegWrite <= '1';
                             ALUOp <= "010";
                               
            -- J                 
            when "000111" => Jump <= '1';
            
            when others => ALUOp <= "000";
         end case;
      end process;                                 

end Behavioral;
