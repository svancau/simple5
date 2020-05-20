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

entity small5 is
  generic(
    INSTR_ADDR_SIZE : natural := 32;
    DATA_ADDR_SIZE : natural := 32
  );
  port (
    clk : in std_logic; -- Input clock
    instr_addr : out std_logic_vector(INSTR_ADDR_SIZE-1 downto 0);
    instr_read : out std_logic;
    instr_rdy : in std_logic;
    instr_rddata : in std_logic_vector(31 downto 0);
    data_addr : out std_logic_vector(DATA_ADDR_SIZE-1 downto 0);
    data_write : out std_logic;
    data_read : out std_logic;
    data_rdy : in std_logic;
    data_rddata : in std_logic_vector(31 downto 0);
    data_wrdata : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of small5 is
  signal instr_read_i : std_logic;
  signal operation : std_logic_vector(9 downto 0);
  signal immediate : std_logic_vector(31 downto 0);
  signal pc : std_logic_vector(31 downto 0);
  signal pc_out : std_logic_vector(31 downto 0);
  signal write_pc : std_logic;
  signal use_imm : std_logic;
  signal r1_out : std_logic_vector(31 downto 0);
  signal r2_out : std_logic_vector(31 downto 0);
  signal r3_addr : std_logic_vector(4 downto 0);
  signal r3_in : std_logic_vector(31 downto 0);
  signal r3_write : std_logic;
begin

  instr_addr <= pc;
  instr_read <= instr_read_i;

  data_wrdata <= r3_in;

pc_counter_i : entity work.pc_counter
  port map (
    clk         => clk,
    load_value  => pc_out,
    load        => write_pc,
    enable      => instr_read_i,
    counter_out => pc
  );

  sequencer_i : entity work.sequencer
  port map (
    clk        => clk,
    instr_read => instr_read_i
  );

  decoder_i : entity work.decoder
  port map (
    clk   => clk,
    instr => instr_rddata,
    op    => operation,
    imm   => immediate,
    use_imm => use_imm
  );

  execute_i : entity work.execute
  port map (
    clk => clk,
    op  => operation,
    r1  => r1_out,
    r2  => r2_out,
    imm => immediate,
    use_imm => use_imm,
    pc  => pc,
    pc_out => pc_out,
    write_pc => write_pc,
    r3_addr => r3_addr,
    r3_in => r3_in,
    r3_write => r3_write
  );

  regfile_i : entity work.regfile
  port map (
    clk      => clk,
    r1_addr  => instr_rddata(19 downto 15),
    r2_addr  => instr_rddata(24 downto 20),
    rden     => '1',
    r1_out   => r1_out,
    r2_out   => r2_out,
    r3_addr  => instr_rddata(11 downto 7),
    r3_in    => r3_in,
    r3_write => r3_write
  );

end architecture;
