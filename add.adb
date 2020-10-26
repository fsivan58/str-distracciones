
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;
with Distance_Task; use Distance_Task;
with head_task;
with display_task;


-- Packages needed to generate pulse interrupts       
-- with Ada.Interrupts.Names;
-- with Pulse_Interrupt; use Pulse_Interrupt;

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



