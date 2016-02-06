library verilog;
use verilog.vl_types.all;
entity risc is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        st2             : out    vl_logic_vector(15 downto 0);
        o3              : out    vl_logic_vector(15 downto 0);
        alu             : out    vl_logic_vector(15 downto 0);
        irO             : out    vl_logic_vector(15 downto 0);
        memDataOut      : out    vl_logic_vector(15 downto 0)
    );
end risc;
