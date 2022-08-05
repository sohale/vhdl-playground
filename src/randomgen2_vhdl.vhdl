-- draft file. VHDL version does not work
-- partial conversion from .verilog to .vhdl

entity prng16 is
    port(
        reset_n: in std_logic,
        clk: in std_logic,
        set: in std_logic,
        seed : in std_logic_vector(degree-1 downto 0),
        -- output
        rnd: out std_logic_vector(15 downto 0)
    );
end entity;

generic(
    -- // max length 32, bit LFSR bits 31,30,10 are set
    constant poly : integer = 32'hC0000400;
    constant degre: integer = 32;
);

architecture rg2 of prng16 is

    -- signal reg : std_logic_vector(degree-1 downto 0) register;
begin
  process is

  begin

    -- ?
    -- reg [degree-1:0] lfsr,feedback;

    -- shared variable lfsr : std_logic_vector( degree-1 downto 0);
    -- shared variable feedback : std_logic_vector( degree-1 downto 0);

    -- signal or variable? register or ...
    signal variable lfsr : std_logic_vector( degree-1 downto 0) register;
    signal variable feedback : std_logic_vector( degree-1 downto 0) register;

    -- always @(posedge clk or negedge reset_n)
    wait until posedge(clk) or negedge(reset_n);

    if (not reset_n) then
        -- todo
        lfsr <= { {(degree/3){3'b101}},2'b10};
    else
        if set then
            -- todo
            lfsr <= seed;
        else
            -- todo
            lfsr <= feedback;
        end if;
    end if;

    -- todo
    --- integer n?

    -- todo
    -- always @( * )
    begin
        feedback[0]= lfsr[degree-1];
        n := 1;
        while (n < degree) loop

            -- todo
            feedback[n] = (poly[n] == 1'b0) ? (lfsr[n-1]) : (lfsr[n-1]^lfsr[degree-1]);

            n := n + 1
        end loop
    end

    assign rnd = {
        lfsr[27], lfsr[16], lfsr[ 6], lfsr[22],
        lfsr[20], lfsr[ 0], lfsr[18], lfsr[26],
        lfsr[10], lfsr[ 9], lfsr[25], lfsr[19],
        lfsr[11], lfsr[ 7], lfsr[28], lfsr[ 8]
    };


  end process;
end architecture;

