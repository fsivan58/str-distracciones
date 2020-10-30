with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;

with Tools; use Tools;
with Devices; use Devices;
with Symptoms_PKG; use Symptoms_PKG;

package body Steering_Task is
    task body Steering is
        Previous_S : Steering_Samples_Type := 0;
        Current_S : Steering_Samples_Type;
        Speed: Speed_Samples_Type := 0;
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(350);
        for i in 1..20 loop
            Prevoius_S := Current_S;
            Symptoms.Read_Steering (Current_S);
            Measures.Read_Speed (Speed);
            if Prevoius_S - Current_S > abs(20) and Speed > 40 then
                Symptoms.Write_Steering_Symptom (True);
            else Symptoms.Write_Steering (False);
            end if;
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(350);
        end loop;
    end Steering;
end Steering_Task;