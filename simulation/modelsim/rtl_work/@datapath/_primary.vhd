library verilog;
use verilog.vl_types.all;
entity Datapath is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        memAddr         : out    vl_logic_vector(15 downto 0);
        memWrData       : out    vl_logic_vector(15 downto 0);
        R_pc            : in     vl_logic_vector(1 downto 0);
        ccr_update      : in     vl_logic;
        memDataOut      : in     vl_logic_vector(15 downto 0);
        aluSrca         : in     vl_logic;
        aluScrb         : in     vl_logic_vector(1 downto 0);
        RegDst          : in     vl_logic_vector(1 downto 0);
        RegWrite        : in     vl_logic;
        B_C             : in     vl_logic_vector(1 downto 0);
        MemtoReg        : in     vl_logic_vector(1 downto 0);
        IorD            : in     vl_logic;
        IrWrite         : in     vl_logic;
        Aluop           : in     vl_logic_vector(1 downto 0);
        instr           : out    vl_logic_vector(15 downto 0);
        zero            : out    vl_logic;
        overflow        : out    vl_logic;
        flagreg         : out    vl_logic_vector(1 downto 0);
        aluout          : out    vl_logic_vector(15 downto 0);
        aluRegOut       : out    vl_logic_vector(15 downto 0);
        irOut           : out    vl_logic_vector(15 downto 0);
        enbl            : in     vl_logic;
        C_add           : out    vl_logic_vector(2 downto 0)
    );
end Datapath;
