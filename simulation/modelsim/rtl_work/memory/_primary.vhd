library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        clk             : in     vl_logic;
        address         : in     vl_logic_vector(15 downto 0);
        wrdata          : in     vl_logic_vector(15 downto 0);
        dataout         : out    vl_logic_vector(15 downto 0);
        mem_write       : in     vl_logic;
        mem_read        : in     vl_logic
    );
end memory;
