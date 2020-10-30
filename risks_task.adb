with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;
with Measures_PKG; use Measures_PKG;
with Symptoms_PKG; use Symptoms_PKG;

package body Risks_Task is
    task body Risks is
		Head_Symptom: Boolean := False;
		Distancia_Insegura: Boolean := False;
		Distancia_Imprudente: Boolean := False;
		Peligro_Colision: Boolean := False;
		Speed: Speed_Samples_Type := 0;
		Siguiente_Instante: Time;
		begin
			Siguiente_Instante := Big_Bang + Milliseconds(150);
			for i in 1..40 loop
                delay until Siguiente_Instante;
				Siguiente_Instante := Clock + Milliseconds(150);
				Symptoms.Read_Head_Syptoms (Head_Symptom);
				Symptoms.Read_Distancia_Insegura (Distancia_Insegura);
				Symptoms.Read_Distancia_Imprudente (Distancia_Imprudente);
				Symptoms.Read_Peligro_Colision (Peligro_Colision);
				Measures.Read_Speed (Speed);
				-- if solo volantazo then Beep (1);
				if Head_Symptom and Speed > 70 then
					Beep (3);
				elsif Head_Symptom then
					Beep (2);
				end if;
				if Distancia_Insegura then
					Light (On);
				elsif Distancia_Imprudente then
					Light (On);
					Beep (4);
				elsif Peligro_Colision and Head_Symptom then
					Beep (5);
					Activate_Brake;
				else Light (Off);
				end if;
			end loop;
    end Risks;
end Risks_Task;