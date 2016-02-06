library verilog;
use verilog.vl_types.all;
entity mux4_to_1 is
    port(
        input_a         : in     vl_logic_vector(15 downto 0);
        input_b         : in     vl_logic_vector(15 downto 0);
        input_c         : in     vl_logic_vector(15 downto 0);
        input_d         : in     vl_logic_vector(15 downto 0);
        sel             : in     vl_logic_vector(1 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end mux4_to_1;
