--Inizio progetto Reti Logiche

library IEEE;
use IEEE.STD_LOGIC_1164.ALL; --per usare STD_LOGIC
Use IEEE.STD_LOGIC_ARITH.all; --per vettori

bit'('0');
'U'; --uninitialized
'X'; --unknown

entity culo is
  Port(
    ...
  );
end culo;
--entity: visione ai morsetti(ingresso/uscita), senza dettagli su funzionamento/architettura
--architettura: specifica funzionamento entity, anche + per una entity
architecture Behavioral of culo is --arch DATAFLOW, STRUCTURAL O Behavioral
--istruz dich: segnali, costanti, componenti
  signal

begin
  pa: process(i_clk, i_res) --lista di sensibilità, segnali le cui variazioni causano attivazione proc
  --parte dichiarativa, variabili usate in proc...
  begin
  -- istruzione sequenziale pa_1
  -- istruzione sequenziale pa_2
  -- ...
  end;
  pb: process
  begin
  -- istruzione sequenziale pa_2
  -- ...
  end;
end;
--istruz funz
end Behavioral;

constant GROUND: bit :=0 ; --costanti, per leggibilità

--segnali: astrazione dei collegamenti fisici
signal segnale: STD_LOGIC_VECTOR (7 downto 0);
--segnali hanno attributi, a essi si accede con '
segnale'event;
--event è vero se in determinato istante si è verificato evento sul segnale

--segnali in process aggiornati solo al termine dell'esecuz con ultimo valore assegnato
--variabili visibili solo all'interno del processo in cui sono dichiarate, assegnamenti istantanei
