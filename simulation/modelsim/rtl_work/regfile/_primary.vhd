library verilog;
use verilog.vl_types.all;
entity regfile is
    port(
        clk             : in     vl_logic;
        rdAddrA         : in     vl_logic_vector(2 downto 0);
        rdDataA         : out    vl_logic_vector(15 downto 0);
        rdDataB         : out    vl_logic_vector(15 downto 0);
        rdAddrB         : in     vl_logic_vector(2 downto 0);
        wrenbl          : in     vl_logic;
        wrAddr          : in     vl_logic_vector(2 downto 0);
        wrData          : in     vl_logic_vector(15 downto 0)
    );
end regfile;
