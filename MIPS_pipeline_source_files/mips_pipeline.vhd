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

entity mips_pipeline is
   Port ( clk : in STD_LOGIC;
          btn : in STD_LOGIC_VECTOR (4 downto 0);
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end mips_pipeline;


architecture Behavioral of mips_pipeline is

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
     
     component I_Fetch_Pipeline is
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
      
      component ID_pipeline is
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
     
     component EX_pipeline is
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
     signal rt, rd : std_logic_vector(4 downto 0) := (others => '0');
     
     signal rWA: std_logic_vector(4 downto 0) := (others => '0');
     
     -- IF_ID
     signal Instruction_IF_ID, PCp4_IF_ID: std_logic_vector(31 downto 0) := (others => '0');
     
     -- ID_EX
     signal RegDst_ID_EX, ALUSrc_ID_EX, Branch_ID_EX, MemWrite_ID_EX, MemToReg_ID_EX, RegWrite_ID_EX: std_logic := '0';
     signal ALUOp_ID_EX: std_logic_vector(2 downto 0) := (others => '0');
     signal RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, PCp4_ID_EX: std_logic_vector(31 downto 0) := (others => '0');
     signal func_ID_EX: std_logic_vector(5 downto 0) := (others => '0');
     signal sa_ID_EX, rd_ID_EX, rt_ID_EX: std_logic_vector(4 downto 0) := (others => '0');
     
     -- EX_MEM
     signal Branch_EX_MEM, MemWrite_EX_MEM, MemToReg_EX_MEM, RegWrite_EX_MEM, Zero_EX_MEM : std_logic := '0';
     signal BranchAddress_EX_MEM, ALURes_EX_MEM, RD2_EX_MEM : std_logic_vector(31 downto 0) := (others => '0');
     signal WA_EX_MEM: std_logic_vector(4 downto 0) := (others => '0');
     
     -- MEM_WB
     signal MemToReg_MEM_WB, RegWrite_MEM_WB: std_logic := '0';
     signal ALURes_MEM_WB, MemData_MEM_WB: std_logic_vector(31 downto 0) := (others => '0');
     signal WA_MEM_WB : std_logic_vector(4 downto 0) := (others => '0');
     
begin
        
     C1: MPG port map(enable => enable, btn => btn(0), clk => clk);
           
     C2: SSD port map (clk => clk, digits => digits, an => an, cat => cat);                       
     
     C3: I_Fetch_Pipeline port map (en => enable, 
                                    rst => btn(1), 
                                    clk => clk,
                                    BranchAddress => BranchAddress_EX_MEM,
                                    PcSrc => PCSrc,
                                    JumpAddress => JumpAddress,
                                    jump => Jump,
                                    PCp4 => PCp4, 
                                    Instruction => instruction);                    
                             
     C4: ID_pipeline port map (instr => Instruction_IF_ID(25 downto 0),
                               RegWr => RegWrite_MEM_WB,
                               WA => WA_MEM_WB,
                               EN => enable,
                               ExtOp => ExtOp,
                               WD => WD,
                               clk => clk,
                               RD1 => rd1,
                               RD2 => rd2,
                               Ext_Imm => Ext_Imm,
                               func => func,
                               sa => sa,
                               rt => rt,
                               rd => rd);                        
    
    C5: UC port map(instr => Instruction_IF_ID(31 downto 26),  
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
            
      C6: EX_pipeline port map(rt => rt_ID_EX,
                               rd => rd_ID_EX,
                               RegDst => RegDst_ID_EX,
                               rd1 => RD1_ID_EX,
                               ALUSrc => ALUSrc_ID_EX,
                               rd2 => RD2_ID_EX,
                               Ext_Imm => Ext_Imm_ID_EX,
                               sa => sa_ID_EX,
                               func => func_ID_EX,
                               ALUOp => ALUOp_ID_EX,
                               PCp4 => PCp4_ID_EX,
                               zero => zero,
                               ALURes => ALURes,
                               BranchAddress => BranchAddress,
                               rWA => rWA);
                       
      C7: MEM port map(MemWrite => MemWrite_EX_MEM,
                       ALUResIn => ALURes_EX_MEM,
                       rd2 => RD2_EX_MEM,
                       clk => clk,
                       en => enable,
                       MemData => MemData,
                       ALUResOut => ALUResOut);
                       
      muxWriteBack: process(ALURes_MEM_WB, MemData_MEM_WB, MemToReg_MEM_WB)
      begin
          case MemToReg_MEM_WB is
              when '0' => WD <= ALURes_MEM_WB;
              when '1' => WD <= MemData_MEM_WB;
          end case;
      end process;
      
      PCSrc <= Branch_EX_MEM and Zero_EX_MEM;
      
      JumpAddress <= PCp4_IF_ID(31 downto 28) & Instruction_IF_ID(25 downto 0) & "00";
      
      muxDigits: process(instruction, PCp4, RD1_ID_EX, RD2_ID_EX, Ext_Imm_ID_EX, ALURes, MemData, WD, sw(7 downto 5))
      begin
          case sw(7 downto 5) is
            when "000" => digits <= instruction;
            when "001" => digits <= PCp4;
            when "010" => digits <= RD1_ID_EX;
            when "011" => digits <= RD2_ID_EX;
            when "100" => digits <= Ext_Imm_ID_EX;
            when "101" => digits <= ALURes;
            when "110" => digits <= MemData;
            when "111" => digits <= WD;
         end case;
      end process;
      
      registers: process(clk)
                 begin
                    if rising_edge(clk) then
                        if enable = '1' then
                            -- IF/ID
                            Instruction_IF_ID <= instruction;
                            PCp4_IF_ID <= PCp4;
                            
                            -- ID/EX
                            RegDst_ID_EX <= RegDst;
                            ALUSrc_ID_EX <= ALUSrc;
                            Branch_ID_EX <= Branch;
                            ALUOp_ID_EX <= ALUOP;
                            MemWrite_ID_EX <= MemWrite;
                            MemToReg_ID_EX <= MemToReg;
                            RegWrite_ID_EX <= RegWr;
                            RD1_ID_EX <= rd1;
                            RD2_ID_EX <= rd2;
                            Ext_Imm_ID_EX <= Ext_Imm;
                            func_ID_EX <= func;
                            sa_ID_EX <= sa;
                            rd_ID_EX <= rd;
                            rt_ID_EX <= rt;
                            PCp4_ID_EX <= PCp4_IF_ID;
                            
                            -- EX/MEM
                            Branch_EX_MEM <= Branch_ID_EX;
                            MemWrite_EX_MEM <= MemWrite_ID_EX;
                            MemToReg_EX_MEM <= MemToReg_ID_EX;
                            RegWrite_EX_MEM <= RegWrite_ID_EX;
                            Zero_EX_MEM <= zero;
                            BranchAddress_EX_MEM <= BranchAddress;
                            ALURes_EX_MEM <= ALURes;
                            WA_EX_MEM <= rWA;
                            RD2_EX_MEM <= RD2_ID_EX;
                            
                            -- MEM/WB
                            MemToReg_MEM_WB <= MemToReg_EX_MEM;
                            RegWrite_MEM_WB <= RegWrite_EX_MEM;
                            ALURes_MEM_WB <= ALUResOut;
                            MemData_MEM_WB <= MemData;
                            WA_MEM_WB <= WA_EX_MEM;
                        end if;
                     end if;
                  end process;                                                                            

end Behavioral;
