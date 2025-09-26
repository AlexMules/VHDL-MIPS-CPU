----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2025 06:30:36 PM
-- Design Name: 
-- Module Name: mips - Behavioral
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

entity mips is
   Port ( clk : in STD_LOGIC;
          btn : in STD_LOGIC_VECTOR (4 downto 0);
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end mips;


architecture Behavioral of mips is

    component MPG is
        Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
    end component;
    
    component SSD is
        Port ( clk : in STD_LOGIC;
           digits : in STD_LOGIC_VECTOR(31 downto 0);
           an : out STD_LOGIC_VECTOR(7 downto 0);
           cat : out STD_LOGIC_VECTOR(6 downto 0));
     end component;
     
     component I_Fetch is
        Port ( en: in std_logic;
               rst: in std_logic;
               clk: in std_logic;
               BranchAddress: in std_logic_vector(31 downto 0);
               PcSrc: in std_logic;
               JumpAddress: in std_logic_vector(31 downto 0);
               jump: in std_logic;
               PCp4: out std_logic_vector(31 downto 0);
               Instruction: out std_logic_vector(31 downto 0));
      end component;
      
      component I_Decode is
         Port (instr: in std_logic_vector(25 downto 0);
               RegWr: in std_logic;
               RegDst: in std_logic;
               EN: in std_logic;
               ExtOp: in std_logic;
               WD: in std_logic_vector(31 downto 0);
               clk: in std_logic;
               RD1: out std_logic_vector(31 downto 0);
               RD2: out std_logic_vector(31 downto 0);
               Ext_Imm: out std_logic_vector(31 downto 0);
               func: out std_logic_vector(5 downto 0);
               sa: out std_logic_vector(4 downto 0));      
     end component;
     
     component UC is
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
     end component;
     
     component EX is
        Port ( rd1: in std_logic_vector(31 downto 0);
               ALUSrc: in std_logic;
               rd2: in std_logic_vector(31 downto 0);
               Ext_Imm: in std_logic_vector(31 downto 0);
               sa: in std_logic_vector(4 downto 0);
               func: in std_logic_vector(5 downto 0);
               ALUOp: in std_logic_vector(2 downto 0);
               PCp4: in std_logic_vector(31 downto 0);
               zero: out std_logic;
               ALURes: out std_logic_vector(31 downto 0);
               BranchAddress: out std_logic_vector(31 downto 0));
    end component;
    
    component MEM is
        Port ( MemWrite: in std_logic;
               ALUResIn: in std_logic_vector(31 downto 0);
               rd2: in std_logic_vector(31 downto 0);
               clk: in std_logic;
               en: in std_logic;
               MemData: out std_logic_vector(31 downto 0);
               ALUResOut: out std_logic_vector(31 downto 0));
     end component;
     
     signal enable: std_logic := '0';
     signal instruction, PCp4: std_logic_vector(31 downto 0) := (others => '0');
     
     signal digits: std_logic_vector(31 downto 0) := (others => '0');
     
     signal RegWr: std_logic := '0';
     signal RegDst: std_logic := '0';
     signal ExtOp: std_logic := '0';
     signal ALUSrc: std_logic := '0';
     signal Branch: std_logic := '0';
     signal Jump: std_logic := '0';
     signal MemWrite: std_logic := '0';
     signal MemToReg: std_logic := '0';
     
     signal PCSrc: std_logic := '0';
     
     signal ALUOp: std_logic_vector(2 downto 0) := (others => '0');
     signal ALURes: std_logic_vector(31 downto 0) := (others => '0');
     
     signal zero: std_logic := '0';
     
     signal BranchAddress, JumpAddress: std_logic_vector(31 downto 0) := (others => '0');
     
     signal WD: std_logic_vector(31 downto 0) := (others => '0');
     
     signal MemData: std_logic_vector(31 downto 0) := (others => '0');
     signal ALUResOut: std_logic_vector(31 downto 0):= (others => '0');
     
     signal rd1, rd2: std_logic_vector(31 downto 0) := (others => '0');
     
     signal Ext_Imm: std_logic_vector(31 downto 0) := (others => '0');
     
     signal func: std_logic_vector(5 downto 0) := (others => '0');
     signal sa: std_logic_vector(4 downto 0) := (others => '0');

begin
        
     C1: MPG port map(enable => enable, btn => btn(0), clk => clk);
           
     C2: SSD port map (clk => clk, digits => digits, an => an, cat => cat);                       
     
     C3: I_Fetch port map (en => enable, 
                           rst => btn(1), 
                           clk => clk,
                           BranchAddress => BranchAddress,
                           PcSrc => PCSrc,
                           JumpAddress => JumpAddress,
                           jump => Jump,
                           PCp4 => PCp4, 
                           Instruction => instruction);                    
                           
      C4: I_Decode port map (instr => instruction(25 downto 0),
                             RegWr => RegWr,
                             RegDst => RegDst,
                             EN => enable,
                             ExtOp => ExtOp,
                             WD => WD,
                             clk => clk,
                             RD1 => rd1,
                             RD2 => rd2,
                             Ext_Imm => Ext_Imm,
                             func => func,
                             sa => sa);
    
    C5: UC port map(instr => instruction(31 downto 26), 
                    RegDst => RegDst,
                    ExtOp => ExtOp,
                    ALUSrc => ALUSrc,
                    Branch => Branch,
                    Jump => Jump,
                    ALUOp => ALUOp,
                    MemWrite => MemWrite,
                    MemToReg => MemToReg,
                    RegWrite => RegWr);
                                  
      led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemToReg & RegWr;                                       
            
      C6: EX port map (rd1 => rd1,
                       ALUSrc => ALUSrc,
                       rd2 => rd2,
                       Ext_Imm => Ext_Imm,
                       sa => sa,
                       func => func,
                       ALUOp => ALUOp,
                       PCp4 => PCp4,
                       zero => zero,
                       ALURes => ALURes,
                       BranchAddress => BranchAddress);
                       
      C7: MEM port map(MemWrite => MemWrite,
                       ALUResIn => ALURes,
                       rd2 => rd2,
                       clk => clk,
                       en => enable,
                       MemData => MemData,
                       ALUResOut => ALUResOut);
                       
      muxWriteBack: process(ALUResOut, MemData, MemToReg)
      begin
          case MemToReg is
              when '0' => WD <= ALUResOut;
              when '1' => WD <= MemData;
          end case;
      end process;
      
      PCSrc <= Branch and zero;
      
      JumpAddress <= PCp4(31 downto 28) & instruction(25 downto 0) & "00";
      
      muxDigits: process(instruction, PCp4, rd1, rd2, Ext_Imm, ALURes, MemData, WD, sw(7 downto 5))
      begin
          case sw(7 downto 5) is
            when "000" => digits <= instruction;
            when "001" => digits <= PCp4;
            when "010" => digits <= rd1;
            when "011" => digits <= rd2;
            when "100" => digits <= Ext_Imm;
            when "101" => digits <= ALURes;
            when "110" => digits <= MemData;
            when "111" => digits <= WD;
         end case;
      end process;                                                                              

end Behavioral;
