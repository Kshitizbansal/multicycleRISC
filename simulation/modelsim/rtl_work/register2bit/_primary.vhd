library verilog;
use verilog.vl_types.all;
entity register2bit is
    port(
        clk             : in     vl_logic;
        \in\            : in     vl_logic_vector(1 downto 0);
        \out\           : out    vl_logic_vector(1 downto 0)
    );
end register2bit;
