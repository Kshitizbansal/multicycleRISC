library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        r1              : in     vl_logic_vector(15 downto 0);
        r2              : in     vl_logic_vector(15 downto 0);
        op              : in     vl_logic_vector(1 downto 0);
        carry           : out    vl_logic;
        zf              : out    vl_logic;
        out1            : out    vl_logic_vector(15 downto 0)
    );
end alu;
