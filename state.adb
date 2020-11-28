
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with devices; use devices;
with Driver; use Driver;
with Ada.Interrupts.Names;

package body State is

    task body Display is
        Siguiente_Instante: Time;
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(1000);
        loop
            Starting_Notice ("Display");
            Symptoms.Show_Symptoms;
            Measures.Show_Distance;
            Measures.Show_Speed;
            Finishing_Notice ("Display");
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(1000);
        end loop;
    end Display;

    task body Risks is
		Head_Symptom: Boolean := False;
        Volantazo: Boolean := False;
		Distancia_Insegura: Boolean := False;
		Distancia_Imprudente: Boolean := False;
		Peligro_Colision: Boolean := False;
		Speed: Speed_Samples_Type := 0;
		Siguiente_Instante: Time;
        Mode: integer := 1;
    begin
        Siguiente_Instante := Big_Bang + Milliseconds(150);
        loop
            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Milliseconds(150);

            Starting_Notice ("Risks");
            Symptoms.Read_Steering_Symptom (Volantazo);
            Symptoms.Read_Head_Symptom (Head_Symptom);
            Symptoms.Read_Distancia_Insegura (Distancia_Insegura);
            Symptoms.Read_Distancia_Imprudente (Distancia_Imprudente);
            Symptoms.Read_Peligro_Colision (Peligro_Colision);
            Measures.Read_Speed (Speed);
            Operation_Mode.Read_Mode (Mode);

            if Volantazo and Mode < 3 and not Head_Symptom and not Distancia_Imprudente and not Distancia_Insegura and not Peligro_Colision then
                Beep (1);
            end if;
            if Head_Symptom and Mode < 3 and Speed > 70 then
                Beep (3);
            elsif Head_Symptom and Mode < 3 then
                Beep (2);
            end if;
            if Peligro_Colision and Mode < 3 and Head_Symptom then
                Beep (5);
                Activate_Brake;
            elsif Distancia_Imprudente and Mode = 1 then
                Light (On);
                Beep (4);
            elsif Distancia_Insegura and Mode = 1 then
                Light (On);
            elsif Mode /= 3 then
                Light (Off);
            end if;
            Put_Line ("fin de risks");
            Finishing_Notice ("Risks");
        end loop;
    end Risks;

    task body Sporadic_Task is
        Peligro_Colision: Boolean;
        Head_Symptom: Boolean;
        Mode: integer := 1;
    begin
        loop
            Interruption_Handler.Change_Mode;
            Starting_Notice("Iniciando tarea esporadica");

            Operation_Mode.Read_Mode (Mode);
            Symptoms.Read_Peligro_Colision (Peligro_Colision);
            Symptoms.Read_Head_Symptom (Head_Symptom);

            if Mode = 1 and not Peligro_Colision then
                Operation_Mode.Write_Mode (2);
            elsif Mode = 2 and not Peligro_Colision and not Head_Symptom then 
                Light (Off);
                Operation_Mode.Write_Mode (3);
            elsif Mode = 3 then
                Operation_Mode.Write_Mode (1);
            end if;

            Put (": MODE :");
            Put (Integer'Image(Mode));

            Finishing_Notice("Finishing tarea esporadica");
        end loop;
    end Sporadic_Task;

    protected body Operation_Mode is
        procedure Write_Mode (Value: in integer) is
        begin
            Mode := Value;
            Execution_Time(Milliseconds(2));
        end Write_Mode;
        procedure Read_Mode (Value: out integer) is
        begin
            Value := Mode;
        end Read_Mode;
    end Operation_Mode;

    protected body Interruption_Handler is
        procedure Validate_Entry is
        begin
            Enter := True;
            Execution_Time(Milliseconds(2));
        end Validate_Entry;
        entry Change_Mode when Enter is
        begin
            Enter := False;
        end Change_Mode;
    end Interruption_Handler;

begin
    null;
end State;
