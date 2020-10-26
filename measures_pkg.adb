
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

package body Measures_PKG is
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
end Measures_PKG;