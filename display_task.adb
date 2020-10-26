with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;
with Measures_PKG; use Measures_PKG;

package body display_task is
    task body Display is
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Clock + Milliseconds(1000);
        for i in 1..20 loop
            Measures.Show_Distance;
            Measures.Show_Speed;
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(1000);
        end loop;
    end Display;
end display_task;