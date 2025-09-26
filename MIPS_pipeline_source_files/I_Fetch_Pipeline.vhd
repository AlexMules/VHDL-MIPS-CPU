----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2025 10:25:55 AM
-- Design Name: 
-- Module Name: I_Fetch - Behavioral
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

entity I_Fetch_Pipeline is
  Port ( en: in std_logic;
         rst: in std_logic;
         clk: in std_logic;
         BranchAddress: in std_logic_vector(31 downto 0);
         PcSrc: in std_logic;
         JumpAddress: in std_logic_vector(31 downto 0);
         jump: in std_logic;
         PCp4: out std_logic_vector(31 downto 0);
         Instruction: out std_logic_vector(31 downto 0));
         
end I_Fetch_Pipeline;

architecture Behavioral of I_Fetch_Pipeline is
    signal addr: std_logic_vector(5 downto 0) := (others => '0');
    signal q: std_logic_vector(31 downto 0) := (others => '0');
    signal nextInstr: std_logic_vector(31 downto 0) := (others => '0');
    signal mux: std_logic_vector(31 downto 0) := (others => '0');
    signal d: std_logic_vector(31 downto 0) := (others => '0');
    
    type rom_mem is array(0 to 63) of std_logic_vector(31 downto 0);
    
    signal rom: rom_mem := (
    
   -- Anexa 7, problema 14 (putin modificata)
     -- Să se determine suma elementelor cu valori în intervalul [X, Y], 
     -- dintr-un șir de N numere stocate în memorie începând cu adresa 16. 
     -- Valorile X, Y și N se citesc din memorie de la adresele 0, 4, respectiv 8.
     -- Rezultatul se va dubla si se va scrie in memorie la adresa 12. 
    
    --inceput program
    
    B"000011_00000_00001_0000000000000000",
    -- X"0C010000", 00: LW $1, 0($0)     $1 = X (de la adresa 0 din memorie)
    
    B"000011_00000_00010_0000000000000100",
    -- X"0C020004", 01: LW $2, 4($0)     $2 = Y (de la adresa 4 din memorie)
    
    B"000011_00000_00011_0000000000001000",
    -- X"0C030008", 02: LW $3, 8($0)     $3 = N (de la adresa 8 din memorie)
    
    B"000001_00000_00100_0000000000010000",
    -- X"04040010", 03: ADDI $4, $0, 16     $4 = adresa de start a sirului(16)
    
    B"000000_00000_00000_00101_00000_100000",
    -- X"00002820", 04: ADD $5, $0, $0     $5 = suma initiala = 0
    
    B"000101_00011_00000_0000000000011011",
    -- X"1460001B", 05: BEQ $3, $0, 27     daca N == 0, am parcurs intreg sirul =>
                                                        -- => salt la instructiunea 17
                                                        
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 06: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 07: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 08: SLL $0, $0, 0 (NoOp)                                                     
    
    B"000011_00100_00110_0000000000000000",
    -- X"0C860000", 09: LW $6, 0($4)     $6 = elementul curent din sir
    
    B"000001_00100_00100_0000000000000100",
    -- X"04840004", 10: ADDI $4, $4, 4     $4 = $4 + 4 (ne deplasam catre urmatorul element 
                                                                    -- din memorie)
    
    B"000001_00011_00011_1111111111111111",
    -- X"0463FFFF", 11: ADDI $3, $3, -1     $3 = $3 - 1 (N = N - 1)
    
    B"000000_00110_00001_01000_00000_000110",
    -- X"00C14006", 12: SLT $8, $6, $1     $8 = 1 daca elementul curent < X, altfel 0
    
    B"000001_00000_01001_0000000000000001",
    -- X"04090001", 13: ADDI $9, $0, 1     $9 = 1
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 14: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 15: SLL $0, $0, 0 (NoOp)
    
    B"000101_01000_01001_0000000000001110",
    -- X"1509000E", 16: BEQ $8, $9, 14     daca $8 == 1 (elementul < x), sarim la instr. 16
                                      -- deoarece numarul nu face parte din intervalul [X, Y]
                                      
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 17: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 18: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 19: SLL $0, $0, 0 (NoOp)                                  
    
    B"000000_00110_00010_00111_00000_100010",
    -- X"00C23822", 20: SUB $7, $6, $2     $7 = elementul curent - Y
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 21: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 22: SLL $0, $0, 0 (NoOp)
    
    B"000110_00111_01000_0000000000000001",
    -- X"18E80001", 23: SLTI $8, $7, 1     $8 = 1 daca elementul curent <= Y, altfel 0
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 24: SLL $0, $0, 0 (NoOp)
    
     B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 25: SLL $0, $0, 0 (NoOp)
    
    B"000101_01000_00000_0000000000000100",
    -- X"15000004", 26: BEQ $8, $0, 4     daca $8 == 0 (elementul > Y), sarim la instr. 16
                                      -- deoarece numarul nu face parte din intervalul [X, Y]
                                      
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 27: SLL $0, $0, 0 (NoOp)
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 28: SLL $0, $0, 0 (NoOp)
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 29: SLL $0, $0, 0 (NoOp)                                  
    
    B"000000_00101_00110_00101_00000_100000",
    -- X"00A62820", 30: ADD $5, $5, $6     daca elementul este in interval, $5 = $5 + elementul
                                                        -- (suma = suma + elementul curent)                                                    
    
    B"000111_00000000000000000000000101",
    -- X"1C000005", 31: J 5     jump la instr 05 (a 6-a din program), pentru a continua bucla
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 32: SLL $0, $0, 0 (NoOp)
    
    B"000100_00000_00101_0000000000001100",
    -- X"1005000C", 33: SW $5, 12($0)     scriem suma din $5 in memorie, la adresa 12
    
    B"000011_00000_01010_0000000000001100",
    -- X"0C0A000C", 34: LW $10, 12($0)     citim suma din memorie, de la adresa 12, in $10
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 35: SLL $0, $0, 0 (NoOp)
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 36: SLL $0, $0, 0 (NoOp)
    
    B"000000_00000_01010_01010_00001_000001",
    -- X"000A5041", 37: SLL $10, $10, 1     dublam suma ($10 = $10 * 2 <=> $10 << 1)
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 38: SLL $0, $0, 0 (NoOp)
    
    B"000000_00000_00000_00000_00000_000001",
    -- X"00000001", 39: SLL $0, $0, 0 (NoOp)
    
    B"000100_00000_01010_0000000000001100",
    -- X"100A000C", 40: SW $10, 12($0)     scriem dublul sumei in memorie, la adresa 12
    
    --final program 
    
    others => X"00000000");
    
    
begin
    addr <= q(7 downto 2);
    instruction <= rom(conv_integer(addr));
    
    nextInstr <= q + 4;
    PCp4 <= nextInstr;
    
    process(nextInstr, BranchAddress, PcSrc)
    begin
        case PcSrc is
         when '0' => mux <= nextInstr;
         when '1' => mux <= BranchAddress;
        end case;
    end process;
    
    process(mux, JumpAddress, Jump)
    begin
        case Jump is
         when '0' => d <= mux;
         when '1' => d <= JumpAddress;
        end case;
    end process;
    
    PC: process(clk, rst)
        begin
            if rst = '1' then
                q <= X"00000000";
            elsif rising_edge(clk) then
                if en = '1' then 
                    q <= d;
                end if;
            end if;
        end process;

end Behavioral;
