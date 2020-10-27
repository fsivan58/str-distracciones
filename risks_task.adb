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
    begin
	for i in 1..40 loop
	    Symptoms.Read_Head_Syptoms (Head_Symptom);
	    Symptoms.Read_Distancia_Insegura (Distancia_Insegura);
	    Symptoms.Read_Distancia_Imprudente (Distancia_Imprudente);
	    Symptoms.Read_Peligro_Colision (Peligro_Colision);
	end loop;
    end Risks;
        
