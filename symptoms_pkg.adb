
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

package body symptoms_pkg is
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
end symptoms_pkg;