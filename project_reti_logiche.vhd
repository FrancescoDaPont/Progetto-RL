
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
signal result_reg_load : std_logic;
signal reset_result_sel : std_logic;
signal o_addr_load : std_logic;
signal first_sel : std_logic;
signal second_or_default_sel : std_logic;
signal end_multiply : std_logic;
signal addr_to_look_load : std_logic;
signal decr_sel : std_logic;
signal decrement : std_logic;
signal sub_or_sum_sel : std_logic;
signal delta_load : std_logic;
signal num_reg_load : std_logic;
signal two_power_of_zero : std_logic;
signal exp_load : std_logic;
signal curr_pixel_load : std_logic;
signal shift_load : std_logic;
signal done : std_logic;
signal min_reg_load : std_logic;
signal max_reg_load : std_logic;
signal sum_counter_load : std_logic;
signal new_pix_load : std_logic;
signal stop_sel : std_logic;
signal concat_reg_load : std_logic;
signal end_shift : std_logic;
signal shift_once : std_logic;
signal conc_sel : std_logic;
signal curr_conc_sel : std_logic;
signal shift_sel : std_logic;
signal gen_comp_one : std_logic;
signal gen_comp_two : std_logic;
signal gen_comp_three : std_logic;
signal gen_comp_four : std_logic;
signal comp_four_sel : std_logic;
signal reset_regs : std_logic;
signal address_two : std_logic;
signal confront_load : std_logic;
signal dont_shift : std_logic;
signal shift_by_one : std_logic;
signal shift_by_two : std_logic;
signal shift_by_three : std_logic;
signal shift_by_four : std_logic;
signal shift_by_five : std_logic;
signal shift_by_six : std_logic;
signal shift_by_seven : std_logic;
type S is (S0,S1,S1_1,S2_1,S2_2,S3,S3_1,S3_2,S4_1,S4_2,S5_1,S5_15,S5_2A,S5_2B,S6,S7,S8,S9_A,S9_B,S9_C,S10,S10_1,S11_A,S11_B,S11_C,S11_12,S11_15,S12_A_1,S12_A_2,S12_A_1_B,S12_B_1,S12_B_2,S12_B_3,S16); --(,S11_2,S13,S14,S15,S17,S18)
signal cur_state, next_state : S; --34 stati

signal o_n_row_reg : std_logic_vector(7 downto 0); --output/mux primo foglio
signal o_result_reg : std_logic_vector(15 downto 0);
signal o_cost_reg : std_logic_vector(7 downto 0);
signal o_n_tot_addr_reg : std_logic_vector(15 downto 0);
signal o_addr_to_look_reg : std_logic_vector(15 downto 0);
signal o_o_addr_reg : std_logic_vector(15 downto 0);
signal n_row_mux : std_logic_vector(7 downto 0);
signal reset_result_mux : std_logic_vector(15 downto 0);
signal stop_adding_mux : std_logic_vector(15 downto 0);
signal tot_addr_mux : std_logic_vector(15 downto 0);
signal zero_row_mux : std_logic_vector(15 downto 0);
signal decr_mux : std_logic_vector(15 downto 0);
signal second_or_def_mux : std_logic_vector(15 downto 0);
signal stop_mux : std_logic_vector(15 downto 0);
signal first_sel_mux : std_logic_vector(15 downto 0);
signal sub_or_sum_mux : std_logic_vector(15 downto 0);

signal o_min_reg : std_logic_vector(7 downto 0); --output/mux secondo foglio
signal o_max_reg : std_logic_vector(7 downto 0);
signal o_curr_pixel_reg : std_logic_vector(15 downto 0);
signal o_delta_reg : std_logic_vector(15 downto 0);
signal o_num_reg : std_logic_vector(15 downto 0);
signal o_exp_reg : std_logic_vector(15 downto 0);
signal o_sum_counter_reg : std_logic_vector(7 downto 0);
signal o_concat_reg : std_logic_vector(15 downto 0);
signal o_shift_reg : std_logic_vector(7 downto 0);
signal o_new_pix_reg : std_logic_vector(7 downto 0);
signal min_mux : std_logic_vector(7 downto 0);
signal max_mux : std_logic_vector(7 downto 0);
signal shift_mux : std_logic_vector(7 downto 0);
signal temp_mux : std_logic_vector(7 downto 0);
signal two_power_of_zero_mux : std_logic_vector(15 downto 0);
signal end_sum_mux : std_logic_vector(7 downto 0);
signal mux_shift_reg : std_logic_vector(7 downto 0);
signal confront_with_ff_reg : std_logic_vector(15 downto 0);
signal curr_concat_mux : std_logic_vector(15 downto 0);
signal conc_mux : std_logic_vector(15 downto 0);
signal comp_four_mux : std_logic;

signal tot_addr_sum : std_logic_vector(15 downto 0); --somme/sottr. primo foglio
signal result_sum : std_logic_vector(15 downto 0);
signal n_row_sub : std_logic_vector(7 downto 0);
signal addr_to_look_sub : std_logic_vector(15 downto 0);
signal curr_addr_sum : std_logic_vector(15 downto 0);
signal done_sum : std_logic_vector(15 downto 0);
signal o_addr_sum : std_logic_vector(15 downto 0);
signal addr_minus_cost : std_logic_vector(15 downto 0);
signal addr_two_or_minus_cost : std_logic_vector(15 downto 0);
signal addr_plus_cost : std_logic_vector(15 downto 0);

signal curr_pixel_sub : std_logic_vector(15 downto 0); --somme/sottr. secondo foglio
signal max_minus_min : std_logic_vector(15 downto 0);
signal delta_sum : std_logic_vector(15 downto 0);
signal exp_sum : std_logic_vector(15 downto 0);
signal counter_sum : std_logic_vector(7 downto 0);
signal sum_counter_sub : std_logic_vector(7 downto 0);
signal shift_sub : std_logic_vector(7 downto 0);
signal shift_decr_sub : std_logic_vector(7 downto 0);
begin
  process(i_clk, i_rst)
  begin
      if(i_rst = '1') then
          cur_state <= S0;
      elsif i_clk'event and i_clk = '1' then
          cur_state <= next_state;
      end if;
  end process;

  process(cur_state, i_start, end_multiply, decrement, done, end_shift, dont_shift, shift_by_one, shift_by_two, shift_by_three, shift_by_four, shift_by_five, shift_by_six, shift_by_seven, o_n_row_reg, gen_comp_three)
    begin
      next_state <= cur_state;
      case cur_state is
        when S0 =>
            if i_start = '1' then
              next_state <= S1;
            end if;
        when S1 =>
            next_state <= S1_1;
        when S1_1 =>
            next_state <= S2_1;
        when S2_1 =>
            if end_multiply = '1' then
              next_state <= S4_2;
            else next_state <= S2_2;
            end if;
        when S2_2 =>
            next_state <= S3;
        when S3 =>
            next_state <= S3_1;
        when S3_1 =>
            next_state <= S3_2;
        when S3_2 =>
            if o_n_row_reg = "00000000" then
              next_state <= S4_1;
            end if;
        when S4_1 =>
            if decrement = '0' then
              next_state <= S6;
            else next_state <= S5_1;
            end if;
        when S4_2 =>
            next_state <= S16;
        when S5_1 =>
            next_state <= S5_15;
        when S5_15 =>
            next_state <= S5_2A;
        when S5_2A =>
            if decrement = '0' then
              next_state <= S6;
            else next_state <= S5_2B;
            end if;
        when S5_2B =>
            if decrement = '0' then
              next_state <= S6;
            else next_state <= S5_2A;
            end if;
        when S6 =>
            next_state <= S7;
        when S7 =>
            next_state <= S8;
        when S8 =>
            next_state <= S9_A;
        when S9_A =>
            if gen_comp_three = '1' then
              next_state <= S9_C;
            else next_state <= S9_B;
            end if;
        when S9_B =>
            if gen_comp_three = '1' then
              next_state <= S9_C;
            else next_state <= S9_A;
            end if;
        when S9_C =>
            next_state <= S10_1;
        when S10 =>
            next_state <= S10_1;
        when S10_1 =>
            next_state <= S11_12;
        when S11_12 =>
            next_state <= S11_15;
        when S11_15 =>
            if end_shift = '1' and (dont_shift = '0') then
            next_state <= S12_A_1;
            elsif (dont_shift = '1') then
            next_state <= S12_B_1;
            else next_state <= S11_A;
            end if;
        when S11_A =>
            if end_shift = '1' and (dont_shift = '0') then
            next_state <= S11_C;
            else next_state <= S11_B;
            end if;
        when S11_B =>
            if end_shift = '1' and (dont_shift = '0') then
            next_state <= S11_C;
            else next_state <= S11_A;
            end if;
        when S11_C =>
            if shift_by_one = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_two = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_three = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_four = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_five = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_six = '1' then
            next_state <= S12_A_1_B;
            elsif shift_by_seven = '1' then
            next_state <= S12_A_1_B;
            else next_state <= S12_A_1;
            end if;
            --next_state <= S12_A_1;
        when S12_A_1 =>
            next_state <= S12_A_2;
        when S12_A_1_B =>
            next_state <= S12_A_2;
        when S12_A_2 =>
            if done = '1' then
              next_state <= S16;
            else next_state <= S10;
            end if;
        when S12_B_1 =>
            next_state <= S12_B_2;
        when S12_B_2 =>
            next_state <= S12_B_3;
        when S12_B_3 =>
            if done = '1' then
              next_state <= S16;
            else next_state <= S10;
            end if;
        when S16 =>
            if i_start = '1' then
              next_state <= S0;
            end if;
        when others =>
      end case;  
    end process;
    
    process(cur_state, o_o_addr_reg)
    begin
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        n_row_reg_load <= '0';
        result_reg_load <= '0';
        cost_reg_load <= '0';
        n_tot_addr_load <= '0';
        addr_to_look_load <= '0';
        o_addr_load <= '0';
        concat_reg_load <= '0';
        n_row_sel <= '0';
        reset_result_sel <= '0';
        tot_addr_sel <= '0';
        zero_row_sel <= '0';
        stop_adding_sel <= '1';
        second_or_default_sel <= '0';
        first_sel <= '0';
        decr_sel <= '0';
        sub_or_sum_sel <= '0';
        min_reg_load <= '0';
        max_reg_load <= '0';
        delta_load <= '0';
        two_power_of_zero <= '1';
        num_reg_load <= '0';
        sum_counter_load <= '0';
        curr_pixel_load <= '0';
        stop_sel <= '0';
        curr_conc_sel <= '0';
        shift_load <= '0';
        shift_once <= '1';
        conc_sel <= '1';
        shift_sel <= '0';
        reset_regs <= '0';
        address_two <= '0';
        new_pix_load <= '0';
        comp_four_sel <= '1';
        confront_load <= '0';
        exp_load <= '1'; --effettivamente era undefined, ritornaci se ci sono problemi
        o_address <= o_o_addr_reg;
        case cur_state is
            when S0 =>
                o_en <= '1';
            when S1 =>
                o_en <= '1';
                cost_reg_load <= '1';
                result_reg_load <= '1';
            when S1_1 => --fin qua indirizzo 0
                o_en <= '1';
                n_tot_addr_load <= '1';
                cost_reg_load <= '1';
                result_reg_load <= '1';
                
                o_addr_load <= '1';
                first_sel <= '1';
            when S2_1 => --indirizzo 1
                n_tot_addr_load <= '0';
                cost_reg_load <= '0';
                result_reg_load <= '0';
                --n_row_reg_load <= '1';
                
                o_en <= '1';
                first_sel <= '1';
                o_addr_load <= '1';
            when S2_2 => --arriva qua in post-synth
                n_row_reg_load <= '1';
                o_en <= '1';
            when S3 => --indirizzo 2
                n_tot_addr_load <= '1';
                result_reg_load <= '1';
                n_row_reg_load <= '1';
                
                n_row_sel <= '1';
                o_en <= '1';
                first_sel <= '1';
                o_addr_load <= '1';
                
                reset_result_sel <= '1'; --per mettere al valore giusto n_tot_addr e result_reg checka se va bene
                tot_addr_sel <= '1';
                
                min_reg_load <= '1';
                max_reg_load <= '1';
            when S3_1 =>
                n_tot_addr_load <= '1';
                n_row_reg_load <= '1';
                result_reg_load <= '1';
                
                n_row_sel <= '1';
                
                reset_result_sel <= '1';
                tot_addr_sel <= '1';
                
                min_reg_load <= '1';
                max_reg_load <= '1';
            when S3_2 =>
                n_tot_addr_load <= '1';
                n_row_reg_load <= '1';
                result_reg_load <= '1';
                
                addr_to_look_load <= '1';
                
                n_row_sel <= '1';
                stop_adding_sel <= '0';
                tot_addr_sel <= '1';
                reset_result_sel <= '1';
                
                min_reg_load <= '1';
                max_reg_load <= '1';
            when S4_1 =>
                addr_to_look_load <= '1';
                o_en <= '1';
                
                min_reg_load <= '1';
                max_reg_load <= '1';
            when S4_2 =>
                zero_row_sel <= '1';
            when S5_1 =>
                addr_to_look_load <= '1';
                decr_sel <= '1';
                min_reg_load <= '1';
                max_reg_load <= '1';
                
                o_en <= '1';
            when S5_15 =>
                addr_to_look_load <= '1';
                decr_sel <= '1';
                
                o_en <= '1';
            when S5_2A =>
                addr_to_look_load <= '1';
                decr_sel <= '1';
                min_reg_load <= '1';
                max_reg_load <= '1';
                
                o_en <= '1';
                first_sel <= '1';
                o_addr_load <= '1';
            when S5_2B =>
                addr_to_look_load <= '1';
                decr_sel <= '1';
                min_reg_load <= '1';
                max_reg_load <= '1';
                
                o_en <= '1';
                first_sel <= '1'; --scorre tutti indirizzi
                o_addr_load <= '1';
            when S6 => --all'inizio di S7, ho tutti i valori di input iniziali, il min e il max
                min_reg_load <= '1';
                max_reg_load <= '1';
                o_en <= '1';
                zero_row_sel <= '1';
                
                o_addr_load <= '1';
                second_or_default_sel <= '1';
                address_two <= '1';
                --bisogna sottrarre 1 all'indirizzo
            when S7 => --all'inizio di S8 ottengo il delta
                delta_load <= '1';
            when S8 =>
                o_en <= '1';
                num_reg_load <= '1';
                exp_load <= '1';
            when S9_A => --ho il num_reg (e exp_reg)
                two_power_of_zero <= '0';
                sum_counter_load <= '1';
            when S9_B =>
                two_power_of_zero <= '0';
                sum_counter_load <= '1';
            when S9_C => --sei all'indirizzo 2, allo stato 11_15 sarai a 2 + result_reg
            when S10 =>
                second_or_default_sel <= '1'; --torna indietro di reg_load - 1 posizioni
                o_addr_load <= '1';
                o_en <= '1';
            when S10_1 => --ho disponibile floor(log2(delta+1))+1 (poi gli sottraggo 1)
                o_en <= '1';
                
                shift_load <= '1';
                --concat_reg_load <= '1'; carica un XXXX in o_concat_reg
            when S11_12 =>
                o_en <= '1';
                curr_pixel_load <= '1';
            when S11_15 =>
                concat_reg_load <= '1';
                conc_sel <= '0';
                
                shift_load <= '1';
                shift_once <= '0';
                shift_sel <= '1';
                
                second_or_default_sel <= '1';
                o_addr_load <= '1';
                sub_or_sum_sel <= '1'; --va avanti di reg_load posizioni
            when S11_A =>
                shift_load <= '1';
                shift_once <= '0';
                shift_sel <= '1';
                
                concat_reg_load <= '1';
                conc_sel <= '0';
                curr_conc_sel <= '1';
                
                new_pix_load <= '1'; --carica valore confronto in new_pix_reg
                confront_load <= '1';
            when S11_B =>
                shift_load <= '1';
                shift_once <= '0';
                shift_sel <= '1';
                
                concat_reg_load <= '1';
                conc_sel <= '0';
                curr_conc_sel <= '1';
                
                new_pix_load <= '1';
                confront_load <= '1';
            when S11_C =>
                conc_sel <= '0';
                curr_conc_sel <= '1';
                
                new_pix_load <= '1';
                
                confront_load <= '1';
            when S12_A_1 =>
                confront_load <= '1';
                new_pix_load <= '1';
            when S12_A_1_B =>
            when S12_A_2 =>
                o_en <= '1';
                o_we <= '1';
            when S12_B_1 =>
                confront_load <= '1';
                new_pix_load <= '1';
            when S12_B_2 =>
                new_pix_load <= '1';
            when S12_B_3 =>
                o_en <= '1';
                o_we <= '1';
            when S16 =>
                o_done <= '1';
                o_addr_load <= '1'; --torna a indirizzo 0
                reset_regs <= '1';
        end case;    
    end process;
    
    process(i_clk, i_rst, reset_regs)
    begin
        if(i_rst = '1') then
            o_cost_reg <= "11111111";-- "XXXXXXXX";
        elsif(reset_regs = '1') then
            o_cost_reg <= "11111111";-- "XXXXXXXX";
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
        n_row_mux <= i_data when '0',
                     n_row_sub when '1',
                    "XXXXXXXX" when others;
    
    process(i_clk, i_rst, reset_regs)
    begin
        if(i_rst = '1') then
            o_n_row_reg <= "11111111"; --"XXXXXXXX";
        elsif(reset_regs = '1') then
            o_n_row_reg <= "11111111"; --"XXXXXXXX";
        elsif i_clk'event and i_clk = '1' then
            if(n_row_reg_load = '1') then
                o_n_row_reg <= n_row_mux;
            end if;
        end if;
    end process;
    
    n_row_sub <= o_n_row_reg - "00000001";
    
    end_multiply <= '1' when ((o_n_row_reg = "00000000") or (o_cost_reg = "00000000")) else '0';
    
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
    
    curr_addr_sum <= o_n_tot_addr_reg + "0000000000000001";
    
    with second_or_default_sel select
        second_or_def_mux <= "0000000000000000" when '0',
                     sub_or_sum_mux when '1',
                    "XXXXXXXXXXXXXXXX" when others;
    
    with sub_or_sum_sel select
        sub_or_sum_mux <= addr_two_or_minus_cost when '0',
                     addr_plus_cost when '1',
                    "XXXXXXXXXXXXXXXX" when others;
    with address_two select
        addr_two_or_minus_cost <= addr_minus_cost when '0',
                     "0000000000000010" when '1',
                    "XXXXXXXXXXXXXXXX" when others;
    
    addr_minus_cost <= o_o_addr_reg - o_result_reg + "0000000000000001";
    
    addr_plus_cost <= o_o_addr_reg + o_result_reg;
    
    with first_sel select
        first_sel_mux <= second_or_def_mux when '0', -- 0 o addr_minus/plus_cost(ind corrente -/+ o_result_reg)
                     o_addr_sum when '1', --indirizzo + 1 o 0
                    "XXXXXXXXXXXXXXXX" when others;
    
    done <= '1' when (o_o_addr_reg = done_sum) else '0';
    
    process(i_clk, i_rst, address_two)--a S6 address_two a 1
    begin
        if(i_rst = '1') then
            o_o_addr_reg <= "0000000000000000";
        --elsif(address_two = '1') then
            --o_o_addr_reg <= "0000000000000010"; --metti tutto nel first_sel_mux
        elsif i_clk'event and i_clk = '1' then
            if(o_addr_load = '1') then
                o_o_addr_reg <= first_sel_mux;
            end if;
        end if;
    end process;

    o_addr_sum <= o_o_addr_reg + stop_mux;
    
    addr_to_look_sub <= o_addr_to_look_reg - 1;
    
    decrement <= '0' when (o_addr_to_look_reg = "0000000000000000") else '1';
    
    with stop_sel select
        stop_mux <= "0000000000000001" when '0',
                     "0000000000000000" when '1',
                    "XXXXXXXXXXXXXXXX" when others;
    
    done_sum <= o_result_reg + o_n_tot_addr_reg + "0000000000000001";
    
    --fine primo foglio
    
    process(i_clk, i_rst, reset_regs)
    begin
        if(i_rst = '1') then
            o_min_reg <= "11111111"; --255 valore iniziale min
        elsif(reset_regs = '1') then
            o_min_reg <= "11111111";
        elsif i_clk'event and i_clk = '1' then
            if(min_reg_load = '1') then
                o_min_reg <= min_mux;
            end if;
        end if;
    end process;
    
    with gen_comp_one select
        min_mux <= i_data when '1',
                     o_min_reg when '0',
                    "11111111" when others;
                    
    gen_comp_one <= '1' when (i_data < o_min_reg) else '0';
    
    process(i_clk, i_rst, reset_regs)
    begin
        if(i_rst = '1') then
            o_max_reg <= "00000000"; --0 valore iniziale min
        elsif(reset_regs = '1') then
            o_max_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(max_reg_load = '1') then
                o_max_reg <= max_mux;
            end if;
        end if;
    end process;
    
    with gen_comp_two select
        max_mux <= i_data when '1',
                     o_max_reg when '0',
                    "00000000" when others;
    
    gen_comp_two <= '1' when (i_data > o_max_reg) else '0';
    
    max_minus_min <= "00000000" & (o_max_reg - o_min_reg);
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_delta_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(delta_load = '1') then
                o_delta_reg <= max_minus_min;
            end if;
        end if;
    end process;
    
    delta_sum <= o_delta_reg + "0000000000000001";
    
    dont_shift <= '1' when delta_sum = "0000000100000000" else '0'; --quando ho 256 in delta sum non c'è bisogno di shift
    
    shift_by_one <= '1' when delta_sum = "0000000010000000" else '0'; --128
    
    shift_by_two <= '1' when delta_sum = "0000000001000000" else '0'; --64
    
    shift_by_three <= '1' when delta_sum = "0000000000100000" else '0'; --32
    
    shift_by_four <= '1' when delta_sum = "0000000000010000" else '0'; --16
    
    shift_by_five <= '1' when delta_sum = "0000000000001000" else '0'; --8
    
    shift_by_six <= '1' when delta_sum = "0000000000000100" else '0'; --4
    
    shift_by_seven <= '1' when delta_sum = "0000000000000010" else '0'; --2
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_num_reg <= "1111111111111111";-- "XXXXXXXXXXXXXXXX";
        elsif i_clk'event and i_clk = '1' then
            if(num_reg_load = '1') then
                o_num_reg <= delta_sum;
            end if;
        end if;
    end process;
    
    with two_power_of_zero select
        two_power_of_zero_mux <= exp_sum when '0',
                     "0000000000000001" when '1',
                    "XXXXXXXXXXXXXXXX" when others;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_exp_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(exp_load = '1') then --SEMPRE A 1
                o_exp_reg <= two_power_of_zero_mux;
            end if;
        end if;
    end process;
    
    exp_sum <= o_exp_reg + o_exp_reg;
    
    gen_comp_three <= '1' when (o_exp_reg >= o_num_reg) else '0';
    
    with gen_comp_three select
        end_sum_mux <= "00000000" when '1',
                     "00000001" when '0',
                    "XXXXXXXX" when others;
    
    counter_sum <= end_sum_mux + o_sum_counter_reg;
    
    process(i_clk, i_rst, reset_regs)
    begin
        if(i_rst = '1') then
            o_sum_counter_reg <= "00000000";
        elsif(reset_regs = '1') then
            o_sum_counter_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(sum_counter_load = '1') then
                o_sum_counter_reg <= counter_sum;
            end if;
        end if;
    end process;
    
    sum_counter_sub <= o_sum_counter_reg - "00000001";
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_curr_pixel_reg <= "0000000000000000"; -- "XXXXXXXXXXXXXXXX";
        elsif i_clk'event and i_clk = '1' then
            if(curr_pixel_load = '1') then
                o_curr_pixel_reg <=  ("00000000" & i_data);
            end if;
        end if;
    end process;
    
    curr_pixel_sub <= (o_curr_pixel_reg - ("00000000" & o_min_reg));
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_concat_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(concat_reg_load = '1') then
                o_concat_reg <= curr_concat_mux;
            end if;
        end if;
    end process;
    
    with curr_conc_sel select
        curr_concat_mux <= curr_pixel_sub when '0',
                     conc_mux when '1',
                    "0000000000000000" when others;
    
    with conc_sel select
        conc_mux <= o_concat_reg when '1',
                     (o_concat_reg (14 downto 0) & '0') when '0',
                    "XXXXXXXXXXXXXXXX" when others;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_shift_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(shift_load = '1') then
                o_shift_reg <= mux_shift_reg;
            end if;
        end if;
    end process;
    
    with shift_once select
        shift_mux <= "00000000" when '1',
                     "00000001" when '0',
                    "00000000" when others;
    
    shift_decr_sub <= o_shift_reg - shift_mux;
    
    shift_sub <= "00001000" - sum_counter_sub;
    
    with shift_sel select
        mux_shift_reg <= shift_decr_sub when '1',
                     shift_sub when '0',
                    "XXXXXXXX" when others;
    
    end_shift <= '1' when (o_shift_reg = "00000000") else '0';
    
    gen_comp_four <= '1' when (confront_with_ff_reg < "0000000011111111") else '0'; --'1' when (o_concat_reg < "0000000011111111")
    
    with comp_four_mux select
        temp_mux <= confront_with_ff_reg(7 downto 0) when '1',
                     "11111111" when '0',
                    "00000000" when others;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            confront_with_ff_reg <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(confront_load = '1') then
                confront_with_ff_reg <= o_concat_reg;
            end if;
        end if;
    end process;
    
    with comp_four_sel select
        comp_four_mux <= gen_comp_four when '1',
                     '1' when '0',
                    '0' when others;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_new_pix_reg <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(new_pix_load = '1') then
                o_new_pix_reg <= temp_mux;
            end if;
        end if;
    end process;
    
    o_data <= o_new_pix_reg;
    
end Behavioral;
