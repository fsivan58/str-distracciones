
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;
with Measures_PKG; use Measures_PKG;
with Symptoms_PKG; use Symptoms_PKG;

package body distance_task is
    task body Distance is
        Current_D: Distance_Samples_Type := 0;
        Current_V: Speed_Samples_Type := 0;
        Recommended_Distance: float;
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Clock + Milliseconds(300);
        for i in 1..20 loop
            Starting_Notice ("Distance");
            Measures.Write_Distance;
            Measures.Read_Distance (Current_D);
            Measures.Write_Speed;
            Measures.Read_Speed (Current_V);
            Recommended_Distance := float ((Current_V/10)**2);
            if (float(Current_D) < Recommended_Distance) then
                Symptoms.Write_Distancia_Insegura (True);
                Light (On);
            elsif (float(Current_D) < float(Recommended_Distance)/float(2)) then
                Symptoms.Write_Distancia_Imprudente (True);
                Light (On);
            elsif (float(Current_D) < float(Recommended_Distance)/float(3)) then 
                Symptoms.Write_Peligro_Colision (True);
                Light (On);
            else
                Light (Off);
                Symptoms.Write_Distancia_Insegura (False);
                Symptoms.Write_Distancia_Imprudente (False);
                Symptoms.Write_Peligro_Colision (False);
            end if;
            Finishing_Notice ("Distance");
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(300);
        end loop;
    end Distance;
end distance_task;