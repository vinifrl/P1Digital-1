library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity debounce is
  generic (
    C_DEPTH_SELECT : integer := 4  -- 2-to-n number of clock cycles to debounce input signal
  );
  port (
    clk           : in  std_logic; -- Debounce clock should be around 10-100ns period.
    signal_in     : in  std_logic; -- Physical input signal.
    signal_out    : out std_logic -- Debounced output signal.
  );
	
end debounce;

architecture rtl of debounce is

  constant SHIFT_REG_EMPTY : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '0'); -- When shift register is empty.
  constant SHIFT_REG_FULL  : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '1'); -- When shift register is full.

  signal signal_in_reg     : std_logic_vector(C_DEPTH_SELECT downto 0) := (others => '0');  -- Registered input signal samples.

  begin

  -- Input signal debounce process.
  debounce : process (clk)
  begin 
    if rising_edge(clk) then
      signal_in_reg <= signal_in_reg(signal_in_reg'high - 1 downto signal_in_reg'low) & signal_in;
	  
	  -- Check to see if the input shift register has filled up with valid 
	  -- input samples.
	  if (signal_in_reg = SHIFT_REG_FULL) then
	    -- A valid logic high is detected, set the debounced output high.
	    signal_out <= '1';
	  else
	    -- A valid logic high has not been detected yet, set the debounced 
		-- output low.
	    signal_out <= '0';
	  end if;

    end if;
end process;

end rtl;