library verilog;
use verilog.vl_types.all;
entity mux2_to_1_3bit is
    port(
        input_a         : in     vl_logic_vector(2 downto 0);
        input_b         : in     vl_logic_vector(2 downto 0);
        sel             : in     vl_logic;
        result          : out    vl_logic_vector(2 downto 0)
    );
end mux2_to_1_3bit;
