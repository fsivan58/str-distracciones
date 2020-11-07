
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Driver; use Driver;
with State; use State;

with Pulse_Interrupt; use Pulse_Interrupt;

package body add is

    procedure Background is
    begin
        loop
            null;
        end loop;
    end Background;

begin
    Starting_Notice ("Programa Principal");
    Finishing_Notice ("Programa Principal");
end add;



