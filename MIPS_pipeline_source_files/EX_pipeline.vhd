----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 08:36:38 AM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX_pipeline is
    Port ( rt: in std_logic_vector(4 downto 0);
           rd: in std_logic_vector(4 downto 0);
           RegDst: in std_logic;
           rd1: in std_logic_vector(31 downto 0);
           ALUSrc: in std_logic;
           rd2: in std_logic_vector(31 downto 0);
           Ext_Imm: in std_logic_vector(31 downto 0);
           sa: in std_logic_vector(4 downto 0);
           func: in std_logic_vector(5 downto 0);
           ALUOp: in std_logic_vector(2 downto 0);
           PCp4: in std_logic_vector(31 downto 0);
           zero: out std_logic;
           ALURes: out std_logic_vector(31 downto 0);
           BranchAddress: out std_logic_vector(31 downto 0);
           rWA: out std_logic_vector(4 downto 0));
end EX_pipeline;

architecture Behavioral of EX_pipeline is
    signal B, Ext_Imm_Shift, C: std_logic_vector(31 downto 0) := (others => '0');
    signal ALUCtrl: std_logic_vector(2 downto 0) := (others => '0');
begin
    ALUControl: process(ALUOp, func)
    begin
        case ALUOp is
            -- tip R
            when "000" =>
                case func is
                    when "100000" => ALUCtrl <= "001"; -- adunare
                    when "100010" => ALUCtrl <= "011"; -- scadere
                    when "000001" => ALUCtrl <= "101"; -- shift left logical
                    when "000010" => ALUCtrl <= "110"; -- shift right logical
                    when "000011" => ALUCtrl <= "010"; -- and 
                    when "000100" => ALUCtrl <= "111"; -- or
                    when "000101" => ALUCtrl <= "000"; -- xor
                    when "000110" => ALUCtrl <= "100"; -- comparatie
                    when others => ALUCtrl <= (others => 'X');
                end case;
            
            when "001" => ALUCtrl <= "001"; -- adunare
            when "010" => ALUCtrl <= "010"; -- and
            when "011" => ALUCtrl <= "011"; -- scadere
            when "100" => ALUCtrl <= "100"; -- comparatie
            when others => ALUCtrl <= (others => 'X');
         end case;
     end process;
      
     ALU: process(rd1, B, sa, ALUCtrl)
     begin
        case ALUCtrl is
            when "001" => C <= rd1 + B;
            when "011" => C <= rd1 - B;
            when "101" => C <= to_stdlogicvector(to_bitvector(B) sll conv_integer(sa));
            when "110" => C <= to_stdlogicvector(to_bitvector(B) srl conv_integer(sa));
            when "010" => C <= rd1 and B;
            when "111" => C <= rd1 or B;
            when "000" => C <= rd1 xor B;
            when "100" =>
                if signed(rd1) < signed(B) then C <= X"00000001";
                                           else C <= X"00000000";
                end if;
            when others => C <= (others => 'X');
        end case;
     end process;
     
     zero <= '1' when C = X"00000000" else '0';
     ALURes <= C;
     
     mux: process(rd2, Ext_Imm, ALUSrc)
     begin
        case ALUSrc is
            when '0' => B <= rd2;
            when '1' => B <= Ext_Imm;
        end case;
     end process; 
     
     Ext_Imm_Shift <= Ext_Imm(29 downto 0) & "00";
     
     BranchAddress <= Ext_Imm_Shift + PCp4;
     
     mux_rWA: process(rt, rd, RegDst)
              begin
                 case RegDst is
                    when '0' => rWA <= rt;
                    when '1' => rWA <= rd;
                  end case;
              end process;

end Behavioral;
