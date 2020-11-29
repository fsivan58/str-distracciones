-- Gonzalo Martin Rodriguez
-- Ivan Fernandez Samaniego

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
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(300);
        loop
            Starting_Notice ("Distance");
            Measures.Read_Distance_Values (Current_D, Current_V);
            Recommended_Distance := float ((Current_V/10)**2);
            if (float(Current_D) < float(Recommended_Distance)/float(3000)) then
                Symptoms.Write_Distance_Symptoms (True, False, False);
            elsif (float(Current_D) < float(Recommended_Distance)/float(2000)) then
                Symptoms.Write_Distance_Symptoms (False, True, False);
            elsif (float(Current_D) < Recommended_Distance) then
                Symptoms.Write_Distance_Symptoms (False, False, True);
            else Symptoms.Write_Distance_Symptoms (False, False, False);
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
        loop
            Starting_Notice ("Steering");
            Previous_S := Current_S;
            Symptoms.Read_Steering_Values (Current_S);
            Measures.Read_Speed_Values (Speed);
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
        loop
            Starting_Notice ("Head");
            Previous_H := Current_H;
            Symptoms.Read_Head_Values (Current_H, Current_S);

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
        procedure Read_Head_Values (Current_H: out HeadPosition_Samples_Type; Current_S: out Steering_Samples_Type) is
        begin
            Reading_HeadPosition(HeadPosition);
            Reading_Steering (Steering);
            Current_H := HeadPosition;
            Current_S := Steering;
            Execution_Time(Milliseconds(6));
        end Read_Head_Values;

        procedure Write_Distance_Symptoms (Colision: in Boolean; Insegura: in Boolean; Imprudente: in Boolean) is
        begin
            Peligro_Colision := Colision;
            Distancia_Insegura := Insegura;
            Distancia_Imprudente := Imprudente;
            Execution_Time(Milliseconds(4));
        end Write_Distance_Symptoms;

        procedure Read_Risks_Symptoms ( Volantazo: out Boolean;
                                        Head: out Boolean;
                                        Insegura: out Boolean;
                                        Imprudente: out Boolean;
                                        Colision: out Boolean) is
        begin
            Volantazo := Steering_Symptom;
            Head := Head_Symptom;
            Insegura := Distancia_Insegura;
            Imprudente := Distancia_Imprudente;
            Colision := Peligro_Colision;
            Execution_Time(Milliseconds(8));
        end Read_Risks_Symptoms;

        procedure Read_Steering_Values (Current_S: out Steering_Samples_Type) is
        begin
            Reading_Steering (Steering);
            Current_S := Steering;
            Execution_Time(Milliseconds(3));
        end Read_Steering_Values;

        procedure Read_Sporadic_Symptoms (Colision: out Boolean; Head: out Boolean) is
        begin
            Colision := Peligro_Colision;
            Head := Head_Symptom;
            Execution_Time(Milliseconds(3));
        end Read_Sporadic_Symptoms;

        procedure Write_Head_Symptom (Value: in Boolean) is
        begin
            Head_Symptom := Value;
            Execution_Time(Milliseconds(2));
        end Write_Head_Symptom;

        procedure Write_Steering_Symptom (Value: in Boolean) is
        begin
            Steering_Symptom := Value;
            Execution_Time(Milliseconds(6));
        end Write_Steering_Symptom;

        procedure Display_Symptom (Symptom: in Unbounded_String) is
        begin
            Current_Time (Big_Bang);
            Put ("............# ");
            Put ("Symptom: ");
            Put (Symptom);
        end Display_Symptom;

        procedure Show_Symptoms is
        begin
            if Head_Symptom then Display_Symptom (To_Unbounded_String("CABEZA INCLINADA")); end if;
            if Steering_Symptom then Display_Symptom (To_Unbounded_String("VOLANTAZO")); end if;
            if Distancia_Insegura then Display_Symptom (To_Unbounded_String("DISTANCIA INSEGURA")); end if;
            if Distancia_Imprudente then Display_Symptom (To_Unbounded_String("DISTANCIA IMPRUDENTE")); end if;
            if Peligro_Colision then Display_Symptom (To_Unbounded_String("PELIGRO COLISION")); end if;
            Execution_Time(Milliseconds(7));
        end Show_Symptoms;
    end Symptoms;

    protected body Measures is
        procedure Read_Distance_Values (Current_D: out Distance_Samples_Type; Current_V: out Speed_Samples_Type) is
        begin
            Reading_Distance(Distance);
            Reading_Speed(Speed);
            Current_D := Distance;
            Current_V := Speed;
            Execution_Time(Milliseconds(8));
        end Read_Distance_Values;

        procedure Read_Speed_Values (Current_V: out Speed_Samples_Type) is
        begin
            Reading_Speed(Speed);
            Current_V := Speed;
            Execution_Time(Milliseconds(2));
        end Read_Speed_Values;

        procedure Show_Measures is
        begin
            Display_Distance(Distance);
            Display_Speed(Speed);
            Execution_Time(Milliseconds(3));
        end Show_Measures;

        procedure Read_Speed (Value: out Speed_Samples_Type) is
        begin
            Value := Speed;
            Execution_Time(Milliseconds(5));
        end Read_Speed;
    end Measures;

begin
    null;
end Driver;
