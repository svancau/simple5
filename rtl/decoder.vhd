-- Copyright 2020 Sebastien Van Cauwenberghe <svancau@gmail.com>
--
-- Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
--
-- 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
--
-- 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
  port (
    clk : in std_logic; -- Input clock
    instr : in std_logic_vector(31 downto 0);
    op : out std_logic_vector(9 downto 0);
    imm : out std_logic_vector(31 downto 0);
    use_imm : out std_logic
  );
end entity;

architecture rtl of decoder is

begin
  process (clk)
  begin

    if rising_edge(clk) then
      op <= (others => '0');
      case instr(6 downto 0) is
        when "0110111" => -- LUI
          null;

        when "0010111" => -- AUIPC
          null;

        when "1101111" => -- JAL
          use_imm <= '1';

        when "1100111" => -- JALR
          use_imm <= '1';

        when "1100011" => -- CMP
          null;

        when "0000011" => -- Load
          null;

        when "0100011" => -- Store
          null;

        when "0110011" => -- Arith reg
          if instr(14 downto 12) = "000" and instr(30) = '0' then -- ADD
            op(0) <= '1';
          end if;

          if instr(14 downto 12) = "000" and instr(30) = '1' then -- SUB
            op(1) <= '1';
          end if;

          if instr(14 downto 12) = "001" then -- SLL
            op(2) <= '1';
          end if;

          if instr(14 downto 12) = "010" then -- SLT
            op(3) <= '1';
          end if;

          if instr(14 downto 12) = "011" then -- SLTU
            op(4) <= '1';
          end if;

          if instr(14 downto 12) = "100" then -- XOR
            op(5) <= '1';
          end if;

          if instr(14 downto 12) = "101" and instr(30) = '0' then -- SRL
            op(6) <= '1';
          end if;

          if instr(14 downto 12) = "101" and instr(30) = '1' then -- SRA
            op(7) <= '1';
          end if;

          if instr(14 downto 12) = "110" then -- OR
            op(8) <= '1';
          end if;

          if instr(14 downto 12) = "111" then -- AND
            op(9) <= '1';
          end if;

        when "0010011" => -- Arith imm
          if instr(14 downto 12) = "000" then -- ADD
            op(0) <= '1';
          end if;

          if instr(14 downto 12) = "001" then -- SLL
            op(2) <= '1';
          end if;

          if instr(14 downto 12) = "010" then -- SLT
            op(3) <= '1';
          end if;

          if instr(14 downto 12) = "011" then -- SLTU
            op(4) <= '1';
          end if;

          if instr(14 downto 12) = "100" then -- XOR
            op(5) <= '1';
          end if;

          if instr(14 downto 12) = "101" and instr(30) = '0' then -- SRL
            op(6) <= '1';
          end if;

          if instr(14 downto 12) = "101" and instr(30) = '1' then -- SRA
            op(7) <= '1';
          end if;

          if instr(14 downto 12) = "110" then -- OR
            op(8) <= '1';
          end if;

          if instr(14 downto 12) = "111" then -- AND
            op(9) <= '1';
          end if;

        when others =>
          null;
      end case;
    end if;
  end process;

end architecture;
