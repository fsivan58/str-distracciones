
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

-- Packages needed to generate pulse interrupts       
-- with Ada.Interrupts.Names;
-- with Pulse_Interrupt; use Pulse_Interrupt;

package body add is


    ---------------------------------------------------------------------- 
    --------------- procedure exported 
    ----------------------------------------------------------------------
    procedure Background is
    begin
      loop
        null;
      end loop;
    end Background;

    ----------------------------------------------------------------------
    ------------- Private Objects  
    ----------------------------------------------------------------------

    protected Medidas is
      procedure Read_Distance (Value: out Distance_Samples_Type);
      procedure Write_Distance; 
      procedure Show_Distance;
      procedure Read_Speed (Value: out Speed_Samples_Type);
      procedure Write_Speed;
      procedure Show_Speed;
    private
      Distance: Distance_Samples_Type;
      Speed: Speed_Samples_Type;
    end Medidas;

    protected body Medidas is

      procedure Read_Distance (Value: out Distance_Samples_Type) is
      begin
	Value := Distance;
      end Read_Distance;

      procedure Write_Distance is
      begin
	Reading_Distance(Distance);
      end Write_Distance;

      procedure Show_Distance is
      begin
	Display_Distance(Distance);
      end Show_Distance;

      procedure Read_Speed (Value: out Speed_Samples_Type) is
      begin
	Value := Speed;
      end Read_Speed;

      procedure Write_Speed is
      begin
	Reading_Speed(Speed);
      end Write_Speed;

      procedure Show_Speed is
      begin
	Display_Speed(Speed);
      end Show_Speed ;

    end Medidas;

    protected Symptoms is
      procedure Write_Head_Symptom (Value: in Boolean);
      procedure Write_Distancia_Insegura (Value: in Boolean);
      procedure Write_Distancia_Imprudente (Value: in Boolean);
      procedure Write_Peligro_Colision (Value: in Boolean);
      procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type);
      procedure Write_HeadPosition;
    private
      Head_Symptom: Boolean := False;
      Distancia_Insegura: Boolean := False;
      Distancia_Imprudente: Boolean := False;
      Peligro_Colision: Boolean := False;
      HeadPosition: HeadPosition_Samples_Type := (+2, -2);
    end Symptoms;

    protected body Symptoms is

      procedure Write_Head_Symptom (Value: in Boolean) is
      begin
	Head_Symptom := Value;
      end Write_Head_Symptom;
      
      procedure Write_Distancia_Insegura (Value: in Boolean) is
      begin
	Distancia_Insegura := Value;
      end Write_Distancia_Insegura;

      procedure Write_Distancia_Imprudente (Value: in Boolean) is
      begin
	Distancia_Imprudente := Value;
      end Write_Distancia_Imprudente;

      procedure Write_Peligro_Colision (Value: in Boolean) is
      begin
	Peligro_Colision := Value;
      end Write_Peligro_Colision;

      procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type) is
      begin
	Value := HeadPosition;
      end Read_HeadPosition; 

      procedure Write_HeadPosition is
      begin
	Reading_HeadPosition(HeadPosition);
      end Write_HeadPosition; 

    end Symptoms;

    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------

    task Distance is
      pragma Priority (15);
    end Distance;
    
    task Head is
      pragma Priority (16);
    end Head;

    task Display is
      pragma Priority (10);
    end Display;

    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------

    task body Distance is 
      Current_D: Distance_Samples_Type := 0;
      Current_V: Speed_Samples_Type := 0;
      Recommended_Distance: float;
      Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Clock + Milliseconds(300);
	for i in 1..20 loop
	      Starting_Notice ("Distance");
	      Medidas.Write_Distance;
	      Medidas.Read_Distance (Current_D);
	      Medidas.Write_Speed;
	      Medidas.Read_Speed (Current_V);
	      Recommended_Distance := float ((Current_V/10)**2);
	      if (float(Current_D) < Recommended_Distance) then
		Symptoms.Write_Distancia_Insegura (True);
		Light (On);
	      elsif (float(Current_D) < float(Recommended_Distance)/float(2)) then
		Symptoms.Write_Distancia_Imprudente (True);
		Light (On);
	      elsif (float(Current_D) < float(Recommended_Distance)/float(3)) then 
		Symptoms.Peligro_Colision (True);
		Light (On);
	      else
		Light (Off);
		Symptoms.Write_Distancia_Insegura (False);
		Symptoms.Write_Distancia_Imprudente (False);
		Symptoms.Peligro_Colision (False);
	      end if;
	      Finishing_Notice ("Distance");
	      delay until Siguiente_Instante;
	      Siguiente_Instante := Siguiente_Instante + Milliseconds(300);
	end loop;
     
    end Distance;

    task body Head is
      Previous_H: HeadPosition_Samples_Type := (+2,-2);
      Current_H: HeadPosition_Samples_Type := (+2, -2);
      Current_S: Steering_Samples_Type;
      Siguiente_Instante: Time;
    begin
      
	-- Guardar en sintomas los valores para cada caso del if
        Siguiente_Instante := Clock + Milliseconds(400);
	for i in 1..20 loop
	      Starting_Notice ("Head");
	      Previous_H := Current_H;
	      Read_HeadPosition (Current_H);
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

    task body Display is
      Siguiente_Instante: Time;
    begin
      
        Siguiente_Instante := Clock + Milliseconds(1000);
	for i in 1..20 loop
	      Medidas.Show_Distance;
	      Medidas.Show_Speed;
	      delay until Siguiente_Instante;
	      Siguiente_Instante := Siguiente_Instante + Milliseconds(1000);
	end loop;
      
    end Display;

begin
   Starting_Notice ("Programa Principal");
   Finishing_Notice ("Programa Principal");
end add;



