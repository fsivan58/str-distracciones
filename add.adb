
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

    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------

    task Distance is
      pragma Priority (15);
    end Distance;
    
    task Head is
      pragma Priority (16);
    end Head;



    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------

    -- Aqui se escriben los cuerpos de las tareas 

    task body Distance is 
      Current_D: Distance_Samples_Type := 0;
      Current_V: Speed_Samples_Type := 0;
      Distancia_Recomendada: float;
    begin

      Starting_Notice ("Distance");
      Reading_Distance (Current_D);
      Display_Distance (Current_D);
      Reading_Speed (Current_V);
      Display_Speed (Current_V);
      Distancia_Recomendada := float ((Current_V/10)**2);
      if (float(Current_D) < Distancia_Recomendada) then 
	Put("DISTANCIA INSEGURA"); Put_Line;
	Light (On);
      elsif (Current_D < Distancia_Recomendada/2) then
	Put("DISTANCIA IMPRUDENTE"); Put_Line;
	Light (On);
      elsif (Current_D < Distancia_Recomendada/3) then 
	Put("PELIGRO DE COLISION"); Put_Line;
	Light (On);
      else Put("SIN PELIGRO DE COLISION"); Put_Line; Light (Off);
      Finishing_Notice ("Distance");
      end if;
      delay until Clock + Milliseconds(300);
     
    end Distance;

    task body Head is
      Previous_H: Head_Position_Samples_Type;
      Current_H: Head_Position_Samples_Type := (+2, -2);
      Current_S: Steering_Samples_Type;
    begin
      
      Starting_Notice ("Head");
      Previous_H := Current_H;
      Reading_HeadPosition (Current_H);
      Reading_Steering (Surrent_S);
      if ((abs Previous_H(x) > 30 and abs Current_H(x) > 30) or
	(abs Previous_H(y) > 30 and abs Current_H(y) > 30 and abs Current_S > 30))
      then 
	Put("CABEZA INCLINADA"); Put_Line;
	Beep(4);
      else Put ("CABEZA RECTA"); Put_Line;
      end if;
      Finishing_Notice ("Head");
      delay until Clock + Milliseconds(400);

    end Head;

    ----------------------------------------------------------------------
    ------------- procedure para probar los dispositivos 
    ----------------------------------------------------------------------
    procedure Prueba_Dispositivos; 

    Procedure Prueba_Dispositivos is
        Current_V: Speed_Samples_Type := 0;
        Current_H: HeadPosition_Samples_Type := (+2,-2);
        Current_D: Distance_Samples_Type := 0;
        Current_O: Eyes_Samples_Type := (70,70);
        Current_E: EEG_Samples_Type := (1,1,1,1,1,1,1,1,1,1);
        Current_S: Steering_Samples_Type := 0;
    begin
         Starting_Notice ("Prueba_Dispositivo");

         for I in 1..120 loop
         -- Prueba distancia
          --  Reading_Distance (Current_D);
           -- Display_Distance (Current_D);
           -- if (Current_D < 40) then Light (On); 
                              --  else Light (Off); end if;

         --Prueba velocidad
           -- Reading_Speed (Current_V);
           -- Display_Speed (Current_V);
           -- if (Current_V > 110) then Beep (2); end if;

         -- Prueba volante
           -- Reading_Steering (Current_S);
           -- Display_Steering (Current_S);
           -- if (Current_S > 30) OR (Current_S < -30) then Light (On);
                                                     --else Light (Off); end if;

         -- Prueba Posicion de la cabeza
           -- Reading_HeadPosition (Current_H);
           -- Display_HeadPosition_Sample (Current_H);
           -- if (Current_H(x) > 30) then Beep (4); end if;

         -- Prueba ojos
           -- Reading_EyesImage (Current_O);
            --Display_Eyes_Sample (Current_O);

         -- Prueba electroencefalograma
            --Reading_Sensors (Current_E);
            --Display_Electrodes_Sample (Current_E);
   
         delay until (Clock + To_time_Span(0.1));
         end loop;

         Finishing_Notice ("Prueba_Dispositivo");
    end Prueba_Dispositivos;



begin
   Starting_Notice ("Programa Principal");
  -- Prueba_Dispositivos;

   Finishing_Notice ("Programa Principal");
end add;



