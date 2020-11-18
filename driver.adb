with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.text_io; use ada.strings.unbounded.text_io;
with System; use System;

with Tools; use Tools;
with devices; use devices;

package body Driver is

    task body Distance is
        Current_D: Distance_Samples_Type := 0;
        Current_V: Speed_Samples_Type := 0;
        Recommended_Distance: float;
        Siguiente_Instante: Time;
    begin -- 0.077008000
        Siguiente_Instante := Big_Bang + Milliseconds(300);
        loop
            Starting_Notice ("Distance");
            Measures.Write_Distance;
            Measures.Write_Speed;
            Measures.Read_Distance (Current_D);
            Measures.Read_Speed (Current_V);
            Recommended_Distance := float ((Current_V/10)**2);
            if (float(Current_D) < float(Recommended_Distance)/float(3000)) then
                Symptoms.Write_Peligro_Colision (True);
                Symptoms.Write_Distancia_Insegura (False);
                Symptoms.Write_Distancia_Imprudente (False);
            elsif (float(Current_D) < float(Recommended_Distance)/float(2000)) then
                Symptoms.Write_Distancia_Imprudente (True);
                Symptoms.Write_Distancia_Insegura (False);
                Symptoms.Write_Peligro_Colision (False);
            elsif (float(Current_D) < Recommended_Distance)then
                Symptoms.Write_Distancia_Insegura (True);
                Symptoms.Write_Distancia_Imprudente (False);
                Symptoms.Write_Peligro_Colision (False);
            else
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
    begin -- 0,055778400
        Siguiente_Instante := Big_Bang + Milliseconds(350);
        loop
            Starting_Notice ("Steering");
            Previous_S := Current_S;
            Symptoms.Write_Steering;
            Measures.Write_Speed;
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
    begin -- 0,0544129
        Siguiente_Instante := Big_Bang + Milliseconds(400);
        loop
            Starting_Notice ("Head");
            Previous_H := Current_H;
            Symptoms.Write_HeadPosition;
            Symptoms.Write_Steering;
            Symptoms.Read_HeadPosition (Current_H);
            Symptoms.Read_Steering (Current_S);

            if (((abs Previous_H(x) > 30) and (abs Current_H(x) > 30)) or
                ((Previous_H(y) > 30) and (Current_H(y) > 30) and (Current_S < 30)) or
                ((Previous_H(y) < 30) and (Current_H(y) < 30) and (Current_S > 30)))
            then
                Symptoms.Write_Head_Symptom (True);
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
            Execution_Time(Milliseconds(2));
        end Write_Head_Symptom;

        procedure Read_Head_Symptom (Value: out Boolean) is
        begin
            Value := Head_Symptom;
            Execution_Time(Milliseconds(2));
        end Read_Head_Symptom;

        procedure Write_Distancia_Insegura (Value: in Boolean) is
        begin
            Distancia_Insegura := Value;
            Execution_Time(Milliseconds(3));
        end Write_Distancia_Insegura;

        procedure Read_Distancia_Insegura (Value: out Boolean) is
        begin
	        Value := Distancia_Insegura;
            Execution_Time(Milliseconds(3));
        end Read_Distancia_Insegura;

        procedure Write_Distancia_Imprudente (Value: in Boolean) is
        begin
            Distancia_Imprudente := Value;
            Execution_Time(Milliseconds(4));
        end Write_Distancia_Imprudente;

        procedure Read_Distancia_Imprudente (Value: out Boolean) is
        begin
            Value := Distancia_Imprudente;
            Execution_Time(Milliseconds(4));
        end Read_Distancia_Imprudente;

        procedure Write_Peligro_Colision (Value: in Boolean) is
        begin
            Peligro_Colision := Value;
            Execution_Time(Milliseconds(5));
        end Write_Peligro_Colision;

        procedure Read_Peligro_Colision (Value: out Boolean) is
        begin
            Value := Peligro_Colision;
            Execution_Time(Milliseconds(5));
        end Read_Peligro_Colision;

        procedure Write_Steering_Symptom (Value: in Boolean) is
        begin
            Steering_Symptom := Value;
            Execution_Time(Milliseconds(6));
        end Write_Steering_Symptom;
        
        procedure Read_Steering_Symptom (Value: out Boolean) is
        begin 
            Value := Steering_Symptom;
            Execution_Time(Milliseconds(6));
        end Read_Steering_Symptom;

        procedure Write_HeadPosition is
        begin
            Reading_HeadPosition(HeadPosition);
            Execution_Time(Milliseconds(7));
        end Write_HeadPosition; 

        procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type) is
        begin
            Value := HeadPosition;
            Execution_Time(Milliseconds(7));
        end Read_HeadPosition;

        procedure Write_Steering is
        begin
            Reading_Steering (Steering);
            Execution_Time(Milliseconds(8));
        end Write_Steering;

        procedure Read_Steering (Value: out Steering_Samples_Type) is
        begin
            Value := Steering;
            Execution_Time(Milliseconds(8));
        end Read_Steering;

        procedure Display_Symptom (Symptom: in Unbounded_String) is
        begin
            Current_Time (Big_Bang);
            Put ("............# ");
            Put ("Symptom: ");
            Put (Symptom);
            Execution_Time(Milliseconds(2));
        end Display_Symptom;

        procedure Show_Symptoms is
        begin
            if Head_Symptom then Display_Symptom (To_Unbounded_String("CABEZA INCLINADA")); end if;
            if Steering_Symptom then Display_Symptom (To_Unbounded_String("VOLANTAZO")); end if;
            if Distancia_Insegura then Display_Symptom (To_Unbounded_String("DISTANCIA INSEGURA")); end if;
            if Distancia_Imprudente then Display_Symptom (To_Unbounded_String("DISTANCIA IMPRUDENTE")); end if;
            if Peligro_Colision then Display_Symptom (To_Unbounded_String("PELIGRO COLISION")); end if;
            Execution_Time(Milliseconds(6));
        end Show_Symptoms;
    end Symptoms;

    protected body Measures is
        procedure Read_Distance (Value: out Distance_Samples_Type) is
        begin
            Value := Distance;
            Execution_Time(Milliseconds(2));
        end Read_Distance;
    
        procedure Write_Distance is
        begin
            Reading_Distance(Distance);
            Execution_Time(Milliseconds(3));
        end Write_Distance;

        procedure Show_Distance is
        begin
            Display_Distance(Distance);
            Execution_Time(Milliseconds(4));
        end Show_Distance;

        procedure Read_Speed (Value: out Speed_Samples_Type) is
        begin
            Value := Speed;
            Execution_Time(Milliseconds(5));
        end Read_Speed;

        procedure Write_Speed is
        begin
            Reading_Speed(Speed);
            Execution_Time(Milliseconds(6));
        end Write_Speed;

        procedure Show_Speed is
        begin
            Display_Speed(Speed);
            Execution_Time(Milliseconds(7));
        end Show_Speed;
    end Measures;

begin
    null;
end Driver;
