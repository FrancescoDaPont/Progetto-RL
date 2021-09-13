
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;

entity project_reti_logiche is
port (
i_clk : in std_logic;
i_rst : in std_logic;
i_start : in std_logic;
i_data : in std_logic_vector(7 downto 0); --pixel da attualizzare
o_address : out std_logic_vector(15 downto 0); --indirizzo di memoria in cui mettere pixel attualizzato
o_done : out std_logic;
o_en : out std_logic;
o_we : out std_logic;
o_data : out std_logic_vector (7 downto 0) --pixel attualizzato
);
end project_reti_logiche;


architecture Behavioral of project_reti_logiche is
signal n_tot_addr_load : std_logic; --loads e sels dei due fogli
signal tot_addr_sel : std_logic;
signal cost_reg_load : std_logic;
signal n_row_reg_load : std_logic;
signal n_row_sel : std_logic;
signal zero_row_sel : std_logic;
signal stop_adding_sel : std_logic;
signal first_two_pixels_sel : std_logic;
signal result_reg_load : std_logic;
signal reset_result_sel : std_logic;
signal o_addr_load : std_logic;
signal first_sel : std_logic;
signal second_or_default_sel : std_logic;
signal end_multiply : std_logic;
signal addr_to_look_load : std_logic;
signal min_sel : std_logic;
signal max_sel : std_logic;
signal decr_sel : std_logic;
signal decrement : std_logic;
signal curr_addr_load : std_logic;
signal delta_sel : std_logic;
signal delta_load : std_logic;
signal num_reg_load : std_logic;
signal two_power_of_zero : std_logic;
signal exp_load : std_logic;
signal end_sum : std_logic;
signal counter_load : std_logic;
signal curr_pixel_load : std_logic;
signal shift_load : std_logic;
signal done : std_logic;
signal temp_sel : std_logic;
signal min_reg_load : std_logic;
signal max_reg_load : std_logic;
signal end_sum_sel : std_logic;
signal sum_counter_load : std_logic;
signal stop_sel : std_logic;
--signal computed_min_and_shift : std_logic;
signal second_time : std_logic;
type S is (S0,S1,S2,S3,S4_1,S4_2,S5,S6,S7,S8,S9,S10,S11,S12,S16,S17,S18); --(,S13,S14,S15,)
signal cur_state, next_state : S;

signal o_n_row_reg : std_logic_vector(7 downto 0); --output/mux primo foglio
signal o_result_reg : std_logic_vector(15 downto 0);
signal o_cost_reg : std_logic_vector(7 downto 0);
signal o_n_tot_addr_reg : std_logic_vector(15 downto 0);
signal o_addr_to_look_reg : std_logic_vector(15 downto 0);
signal o_curr_addr_reg : std_logic_vector(15 downto 0);
signal o_o_addr_reg : std_logic_vector(15 downto 0);
signal first_two_pixels_demux : std_logic_vector(7 downto 0);
signal n_row_mux : std_logic_vector(7 downto 0);
signal reset_result_mux : std_logic_vector(15 downto 0);
signal stop_adding_mux : std_logic_vector(7 downto 0);
signal tot_addr_mux : std_logic_vector(15 downto 0);
signal zero_row_mux : std_logic_vector(15 downto 0);
signal decr_mux : std_logic_vector(15 downto 0);
signal second_or_def_mux : std_logic_vector(15 downto 0);
signal stop_mux : std_logic_vector(15 downto 0);
signal first_sel_mux : std_logic_vector(15 downto 0);

signal o_min_reg : std_logic_vector(7 downto 0); --output/mux secondo foglio
signal o_max_reg : std_logic_vector(7 downto 0);
signal o_curr_pixel_reg : std_logic_vector(7 downto 0);
signal o_delta_reg : std_logic_vector(15 downto 0);
signal o_num_reg : std_logic_vector(15 downto 0);
signal o_exp_reg : std_logic_vector(15 downto 0);
signal o_sum_counter_reg : std_logic_vector(7 downto 0);
signal min_mux : std_logic_vector(7 downto 0);
signal max_mux : std_logic_vector(7 downto 0);
signal temp_mux : std_logic_vector(7 downto 0);
signal two_power_of_zero_mux : std_logic_vector(15 downto 0);
signal end_sum_mux : std_logic_vector(7 downto 0);

signal tot_addr_sum : std_logic_vector(15 downto 0); --somme/sottr. primo foglio
signal result_sum : std_logic_vector(15 downto 0);
signal n_row_sub : std_logic_vector(7 downto 0);
signal addr_to_look_sub : std_logic_vector(15 downto 0);
signal curr_addr_sum : std_logic_vector(15 downto 0);
signal done_sum : std_logic_vector(15 downto 0);
signal o_addr_sum : std_logic_vector(15 downto 0);

signal curr_pixel_sub : std_logic_vector(7 downto 0); --somme/sottr. secondo foglio
signal max_minus_min : std_logic_vector(7 downto 0);
signal delta_sum : std_logic_vector(15 downto 0);
signal exp_sum : std_logic_vector(15 downto 0);
signal counter_sum : std_logic_vector(7 downto 0);
begin
  process(i_clk, i_rst)
  begin
      if(i_rst = '1') then
          cur_state <= S0;
      elsif i_clk'event and i_clk = '1' then
          cur_state <= next_state;
      end if;
  end process;

  process(cur_state, i_start, end_multiply, decrement, end_sum, done)
    begin
      next_state <= cur_state;
      case cur_state is
        when S0 =>
            if i_start = '1' then
              next_state <= S1;
            end if;
        when S1 =>
            if end_multiply = '1' then
              next_state <= S4_2;
            else next_state <= S2;
            end if;
        when S2 =>
            next_state <= S3;
        when S3 =>
            if end_multiply = '1' then
              next_state <= S4_1;
            end if;
        when S4_1 =>
            if decrement = '0' then
              next_state <= S6;
            else next_state <= S5;
            end if;
        when S4_2 =>
            next_state <= S16;
        when S5 =>
            if decrement = '0' then
              next_state <= S6;
            end if;
        when S6 =>
            next_state <= S7;
        when S7 =>
            next_state <= S8;
        when S8 =>
            next_state <= S9;
        when S9 =>
            if end_sum = '1' then
              next_state <= S10;
            end if;
        when S10 =>
            next_state <= S11;
        when S11 =>
            next_state <= S12;
        when S12 =>
            if done = '1' then
              next_state <= S16;
            else next_state <= S10;
            end if;
        --when S13 =>
            --next_state <= S14;
        --when S14 =>
            --next_state <= S15;
        --when S15 =>
            --if done = '1' then
              --next_state <= S16;
            --else next_state <= S13;
            --end if;
        when S16 =>
            if i_start = '0' then
              next_state <= S17;
            end if;
        when S17 =>
            if i_start = '1' then
              next_state <= S18;
            end if;
        when S18 =>
            next_state <= S2;
        when others =>
      end case;
    end process;

    process(cur_state)
    begin
        o_address <= "0000000000000000";
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        first_two_pixels_sel <= '1';
        n_row_reg_load <= '0';
        result_reg_load <= '0';
        cost_reg_load <= '0';
        n_tot_addr_load <= '0';
        n_row_sel <= '0';
        reset_result_sel <= '0';
        tot_addr_sel <= '0';
        zero_row_sel <= '0';
        stop_adding_sel <= '1';
        second_or_default_sel <= '0';
        first_sel <= '0';
        decr_sel <= '0';
        end_multiply <= '0';
        min_sel <= '0';
        max_sel <= '0';
        min_reg_load <= '1';
        max_reg_load <= '1';
        curr_addr_load <= '0';
        delta_load <= '0';
        two_power_of_zero <= '1';
        num_reg_load <= '0';
        exp_load <= '0';
        end_sum_sel <= '1';
        sum_counter_load <= '0';
        curr_pixel_load <= '0';
        stop_sel <= '0';

        case cur_state is
            when S0 =>
            when S1 =>
                o_en <= '1';
                n_tot_addr_load <= '1';
                cost_reg_load <= '1';
                first_sel <= '0';
                result_reg_load <= '1';

                --o_cost_reg <= i_data; --i_data messo nei primi 3 reg/mux
                --reset_result_mux <= i_data;
                --tot_addr_mux <= i_data;
            when S2 =>
                n_tot_addr_load <= '0';
                cost_reg_load <= '0';
                result_reg_load <= '0';
                first_sel <= '1';
                n_row_reg_load <= '1';
            when S3 =>
                o_en <= '0';
                n_row_sel <= '1';
                n_tot_addr_load <= '1';
                result_reg_load <= '1';
                reset_result_sel <= '1';
                tot_addr_sel <= '1';
                first_two_pixels_sel <= '0';
            when S4_1 =>
                o_en <= '1';
                n_tot_addr_load <= '0';
                stop_adding_sel <= '1';
                addr_to_look_load <= '1';
                decr_sel <= '1';
            when S4_2 =>
                zero_row_sel <= '1';
            when S5 =>
            when S6 =>
                zero_row_sel <= '1';
                --first_sel <= '0';
            when S7 =>
                delta_load <= '1';
            when S8 =>
                num_reg_load <= '1';
                exp_load <= '1';
            when S9 =>
                two_power_of_zero <= '1';
                end_sum_sel <= '0'; --forse va messo in S8
                sum_counter_load <= '1';
            when S10 =>
                curr_pixel_load <= '1';
                curr_addr_load <= '1';
                second_or_default_sel <= '1';
                first_sel <= '0';
                end_sum_sel <= '1';
                stop_sel <= '1';
            when S11 =>
            when S12 =>
                o_we <= '1';
                stop_sel <= '0';
            when S16 =>
                o_done <= '1';
            when S17 => --ritorno a stato di default
                o_address <= "0000000000000000";
                o_en <= '0';
                o_we <= '0';
                o_done <= '0';
                first_two_pixels_sel <= '1';
                n_row_reg_load <= '0';
                result_reg_load <= '0';
                cost_reg_load <= '0';
                n_tot_addr_load <= '0';
                n_row_sel <= '0';
                reset_result_sel <= '0';
                tot_addr_sel <= '0';
                zero_row_sel <= '0';
                stop_adding_sel <= '1';
                second_or_default_sel <= '0';
                first_sel <= '0';
                decr_sel <= '0';
                end_multiply <= '0';
                min_sel <= '0';
                max_sel <= '0';
                min_reg_load <= '1';
                max_reg_load <= '1';
                curr_addr_load <= '0';
                delta_load <= '0';
                two_power_of_zero <= '1';
                num_reg_load <= '0';
                exp_load <= '0';
                end_sum_sel <= '1';
                sum_counter_load <= '0';
                curr_pixel_load <= '0';
                stop_sel <= '0';
            when S18 =>
                o_en <= '1';
                n_tot_addr_load <= '0';
                cost_reg_load <= '1';
                first_sel <= '0';
                result_reg_load <= '0';
        end case;
    end process;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_cost_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(cost_reg_load = '1') then
                o_cost_reg <= i_data;
            end if;
        end if;
    end process;

    with tot_addr_sel select
        tot_addr_mux <= ("00000000" & i_data) when '0',
                    tot_addr_sum when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_n_tot_addr_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(n_tot_addr_load = '1') then
                o_n_tot_addr_reg <= tot_addr_mux;
            end if;
        end if;
    end process;

    with stop_adding_sel select
        stop_adding_mux <= ("00000000" & o_cost_reg) when '0',
                    "0000000000000000" when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    tot_addr_sum <= stop_adding_mux + o_n_tot_addr_reg;

    with reset_result_sel select
        reset_result_mux <= ("00000000" & i_data) when '0',
                    result_sum when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    result_sum <= o_result_reg + stop_adding_mux;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_result_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(result_reg_load = '1') then
                o_result_reg <= reset_result_mux;
            end if;
        end if;
    end process;

    with n_row_sel select
        n_row_mux <= first_two_pixels_demux when '0',
                     n_row_sub when '1',
                    "XXXXXXXX" when others;

    with first_two_pixels_sel select --ricontrolla, forse inutile
        first_two_pixels_demux <= i_data when '0',
                     i_data when '1',
                    "XXXXXXXX" when others;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_n_row_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(n_row_reg_load = '1') then
                o_n_row_reg <= n_row_mux;
            end if;
        end if;
    end process;

    with decr_sel select
        decr_mux <= zero_row_mux when '0',
                     addr_to_look_sub when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    addr_to_look_sub <= o_addr_to_look_reg - "0000000000000001";

    with zero_row_sel select
        zero_row_mux <= o_n_tot_addr_reg when '0',
                     "0000000000000000" when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_addr_to_look_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(addr_to_look_load = '1') then
                o_addr_to_look_reg <= decr_mux;
            end if;
        end if;
    end process;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_curr_addr_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(curr_addr_load = '1') then
                o_curr_addr_reg <= curr_addr_sum;
            end if;
        end if;
    end process;

    curr_addr_sum <= o_n_tot_addr_reg + "0000000000000001";

    with first_sel select
        first_sel_mux <= second_or_def_mux when '0',
                     o_addr_sum when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_o_addr_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(o_addr_load = '1') then
                o_o_addr_reg <= first_sel_mux;
            end if;
        end if;
    end process;

    with stop_sel select
        stop_mux <= "0000000000000001" when '0',
                     "0000000000000000" when '1',
                    "XXXXXXXXXXXXXXXX" when others;

    done_sum <= o_result_reg + o_n_tot_addr_reg;

    o_addr_sum <= o_o_addr_reg + stop_mux;

    n_row_sub <= o_n_row_reg - "00000001";

    end_multiply <= '1' when ((o_n_row_reg = "00000000") or (o_cost_reg = "00000000")) else '0';

end Behavioral;

        o_min_reg <= "00000000";
        o_max_reg <= "00000000";
        o_curr_pixel_reg <= "00000000";
        o_delta_reg <= "0000000000000000";
        o_num_reg <= "0000000000000000";
        o_exp_reg <= "0000000000000000";
        o_sum_counter_reg <= "00000000";
        min_mux <= "11111111"; --255 valore iniziale min
        max_mux <= "00000000"; --0 valore iniziale max
