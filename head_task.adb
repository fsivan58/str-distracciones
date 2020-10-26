with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;
with Symptoms_PKG; use Symptoms_PKG;

package body head_task is
    task body Head is
        Previous_H: HeadPosition_Samples_Type := (+2,-2);
        Current_H: HeadPosition_Samples_Type := (+2, -2);
        Current_S: Steering_Samples_Type;
        Siguiente_Instante: Time;
        begin
            Siguiente_Instante := Clock + Milliseconds(400);
            for i in 1..20 loop
                Starting_Notice ("Head");
                Previous_H := Current_H;
                Symptoms.Read_HeadPosition (Current_H);
                Reading_Steering (Current_S);
                if ((abs Previous_H(x) > 30 and abs Current_H(x) > 30) or
                (abs Previous_H(y) > 30 and abs Current_H(y) > 30 and abs Current_S > 30))
                then 
                Symptoms.Write_Head_Symptom (True);
                Beep(4);
                else Symptoms.Write_Head_Symptom (False);
                end if;
                Finishing_Notice ("Head");
                delay until Siguiente_Instante;
                Siguiente_Instante := Siguiente_Instante + Milliseconds(400);
            end loop;
    end Head;
end head_task;