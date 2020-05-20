library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_small5 is
  generic (runner_cfg : string);
end entity;

architecture tb of tb_small5 is
  constant INSTR_ADDR_SIZE : natural := 32;
  constant DATA_ADDR_SIZE : natural := 32;

  signal clk          : std_logic;
  signal instr_addr   : std_logic_vector(INSTR_ADDR_SIZE-1 downto 0);
  signal instr_read   : std_logic;
  signal instr_rdy    : std_logic;
  signal instr_rddata : std_logic_vector(31 downto 0);
  signal data_addr    : std_logic_vector(DATA_ADDR_SIZE-1 downto 0);
  signal data_write   : std_logic;
  signal data_read    : std_logic;
  signal data_rdy     : std_logic;
  signal data_rddata  : std_logic_vector(31 downto 0);
  signal data_wrdata  : std_logic_vector(31 downto 0);

begin

  process
  begin
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    wait for 10 ns;
  end process;

  small5_i : entity work.small5
  generic map (
    INSTR_ADDR_SIZE => INSTR_ADDR_SIZE,
    DATA_ADDR_SIZE  => DATA_ADDR_SIZE
  )
  port map (
    clk          => clk,
    instr_addr   => instr_addr,
    instr_read   => instr_read,
    instr_rdy    => instr_rdy,
    instr_rddata => instr_rddata,
    data_addr    => data_addr,
    data_write   => data_write,
    data_read    => data_read,
    data_rdy     => data_rdy,
    data_rddata  => data_rddata,
    data_wrdata  => data_wrdata
  );


  main : process
    variable counter_val : natural := 0;
  begin
    test_runner_setup(runner, runner_cfg);
    instr_rddata <= X"00000033";

    wait for 1 ms;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;
end architecture;
