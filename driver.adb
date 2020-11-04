with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.text_io; use ada.strings.unbounded.text_io;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

package body Driver is

    task body Distance is
        Current_D: Distance_Samples_Type := 0;
        Current_V: Speed_Samples_Type := 0;
        Recommended_Distance: float;
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Clock + Milliseconds(300);
        --for i in 1..27
        loop
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

    task body Steering is
        Previous_S : Steering_Samples_Type;
        Current_S : Steering_Samples_Type := 0;
        Speed: Speed_Samples_Type := 0;
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(350);
        --for i in 1..23
        loop
            Starting_Notice ("Steering");
            Previous_S := Current_S;
            Symptoms.Read_Steering (Current_S);
            Measures.Read_Speed (Speed);
            if Previous_S - Current_S > abs(20) and Speed > 40 then
                Symptoms.Write_Steering_Symptom (True);
            else Symptoms.Write_Steering_Symptom (False);
            end if;
            Finishing_Notice ("Steering");
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(350);
        end loop;
    end Steering;

    task body Head is
        Previous_H: HeadPosition_Samples_Type := (+2,-2);
        Current_H: HeadPosition_Samples_Type := (+2, -2);
        Current_S: Steering_Samples_Type;
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(400);
        --for i in 1..20
        loop
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

    protected body Symptoms is
        procedure Write_Head_Symptom (Value: in Boolean) is
        begin
            Head_Symptom := Value;
        end Write_Head_Symptom;

        procedure Read_Head_Symptom (Value: out Boolean) is
        begin
            Value := Head_Symptom;
        end Read_Head_Symptom;

        procedure Write_Distancia_Insegura (Value: in Boolean) is
        begin
            Distancia_Insegura := Value;
        end Write_Distancia_Insegura;

        procedure Read_Distancia_Insegura (Value: out Boolean) is
        begin
	    Value := Distancia_Insegura;
        end Read_Distancia_Insegura;

        procedure Write_Distancia_Imprudente (Value: in Boolean) is
        begin
            Distancia_Imprudente := Value;
        end Write_Distancia_Imprudente;

        procedure Read_Distancia_Imprudente (Value: out Boolean) is
        begin
            Value := Distancia_Imprudente;
        end Read_Distancia_Imprudente;

        procedure Write_Peligro_Colision (Value: in Boolean) is
        begin
            Peligro_Colision := Value;
        end Write_Peligro_Colision;

        procedure Read_Peligro_Colision (Value: out Boolean) is
        begin
            Value := Peligro_Colision;
        end Read_Peligro_Colision;

        procedure Write_Steering_Symptom (Value: in Boolean) is
        begin
            Steering_Symptom := Value;
        end Write_Steering_Symptom;
        
        procedure Read_Steering_Symptom (Value: out Boolean) is
        begin 
            Value := Steering_Symptom;
        end Read_Steering_Symptom;

        procedure Write_HeadPosition is
        begin
            Reading_HeadPosition(HeadPosition);
        end Write_HeadPosition; 

        procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type) is
        begin
            Value := HeadPosition;
        end Read_HeadPosition;

        procedure Write_Steering is
        begin
            Reading_Steering (Steering);
        end Write_Steering;

        procedure Read_Steering (Value: out Steering_Samples_Type) is
        begin
            Value := Steering;
        end Read_Steering;

        procedure Show_Symptoms is
        begin
            if Head_Symptom then Display_Symptom (To_Unbounded_String("CABEZA INCLINADA")); end if;
            if Steering_Symptom then Display_Symptom (To_Unbounded_String("VOLANTAZO")); end if;
            if Distancia_Insegura then Display_Symptom (To_Unbounded_String("DISTANCIA INSEGURA")); end if;
            if Distancia_Imprudente then Display_Symptom (To_Unbounded_String("DISTANCIA IMPRUDENTE")); end if;
            if Peligro_Colision then Display_Symptom (To_Unbounded_String("PELIGRO COLISION")); end if;
        end Show_Symptoms;
    end Symptoms;

    protected body Measures is
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
        end Show_Speed;
    end Measures;

begin
    null;
end Driver;