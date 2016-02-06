library verilog;
use verilog.vl_types.all;
entity Add_cnt is
    port(
        clk             : in     vl_logic;
        enbl            : in     vl_logic;
        C_add           : out    vl_logic_vector(2 downto 0)
    );
end Add_cnt;
