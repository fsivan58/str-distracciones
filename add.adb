
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
      procedure Write_Distance (Value: in Distance_Samples_Type);
      procedure Show_Distance;
      procedure Read_Speed (Value: out Speed_Samples_Type);
      procedure Write_Speed (Value: in Speed_Samples_Type);
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

      procedure Write_Distance (Value: in Distance_Samples_Type) is
      begin
	Distance := Value;
      end Write_Distance;

      procedure Show_Distance is
      begin
	Display_Distance(Distance);
      end Show_Distance;

      procedure Read_Speed (Value: out Speed_Samples_Type) is
      begin
	Value := Speed;
      end Read_Speed;

      procedure Write_Speed (Value: in Speed_Samples_Type) is
      begin
	Speed := Value;
      end Write_Speed;

      procedure Show_Speed is
      begin
	Display_Speed(Speed);
      end Show_Speed ;

    end Medidas;

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

    -- Aqui se escriben los cuerpos de las tareas 

    task body Distance is 
      Current_D: Distance_Samples_Type := 0;
      Current_V: Speed_Samples_Type := 0;
      Recommended_Distance: float;
      Current_Time: Time;
    begin

      Starting_Notice ("Distance");
      Current_Time := Clock;
      Reading_Distance (Current_D);
      Display_Distance (Current_D);
      Reading_Speed (Current_V);
      Display_Speed (Current_V);
      Recommended_Distance := float ((Current_V/10)**2);
      if (float(Current_D) < Recommended_Distance) then 
	Put("DISTANCIA INSEGURA");
	Light (On);
      elsif (float(Current_D) < float(Recommended_Distance)/float(2)) then
	Put("DISTANCIA IMPRUDENTE");
	Light (On);
      elsif (float(Current_D) < float(Recommended_Distance)/float(3)) then 
	Put("PELIGRO DE COLISION");
	Light (On);
      else Put("SIN PELIGRO DE COLISION"); Light (Off);
      Finishing_Notice ("Distance");
      end if;
      delay until Current_Time + Milliseconds(1000);
     
    end Distance;

    task body Head is
      Previous_H: HeadPosition_Samples_Type := (+2,-2);
      Current_H: HeadPosition_Samples_Type := (+2, -2);
      Current_S: Steering_Samples_Type;
      Current_Time: Time;
    begin
      
      Starting_Notice ("Head");
      Current_Time := Clock;
      Previous_H := Current_H;
      Reading_HeadPosition (Current_H);
      Reading_Steering (Current_S);
      if ((abs Previous_H(x) > 30 and abs Current_H(x) > 30) or
	(abs Previous_H(y) > 30 and abs Current_H(y) > 30 and abs Current_S > 30))
      then 
	Put("CABEZA INCLINADA");
	Beep(4);
      else Put("CABEZA RECTA");
      end if;
      Finishing_Notice ("Head");
      delay until Current_Time + Milliseconds(1000);

    end Head;

    task body Display is
      Current_Time: Time;
    begin
      
      Current_Time := Clock;
      Medidas.Show_Distance;
      Medidas.Show_Speed;
      delay until Current_Time + Milliseconds(1000);
      
    end Display;

begin
   Starting_Notice ("Programa Principal");
   Finishing_Notice ("Programa Principal");
end add;



