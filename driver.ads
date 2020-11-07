with Priorities; use Priorities;
with Devices1; use Devices1;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.text_io; use ada.strings.unbounded.text_io;

package Driver is

    task Distance is
        pragma Priority (Distance_Priority);
    end Distance;

    task Steering is
        pragma Priority (Steering_Priority);
    end Steering;

    task Head is
        pragma Priority (Head_Priority);
    end Head;

    protected Symptoms is
        procedure Write_Head_Symptom (Value: in Boolean);
        procedure Read_Head_Symptom (Value: out Boolean);
        procedure Write_Distancia_Insegura (Value: in Boolean);
        procedure Read_Distancia_Insegura (Value: out Boolean);
        procedure Write_Distancia_Imprudente (Value: in Boolean);
        procedure Read_Distancia_Imprudente (Value: out Boolean);
        procedure Write_Peligro_Colision (Value: in Boolean);
        procedure Read_Peligro_Colision (Value: out Boolean);
        procedure Write_Steering_Symptom (Value: in Boolean);
        procedure Read_Steering_Symptom (Value: out Boolean);
        procedure Write_HeadPosition;
        procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type);
        procedure Write_Steering;
        procedure Read_Steering (Value: out Steering_Samples_Type);
        procedure Display_Symptom (Symptom: in Unbounded_String);
        procedure Show_Symptoms;
    private
        Head_Symptom: Boolean := False;
        Steering_Symptom: Boolean := False;
        Distancia_Insegura: Boolean := False;
        Distancia_Imprudente: Boolean := False;
        Peligro_Colision: Boolean := False;
        HeadPosition: HeadPosition_Samples_Type := (+2, -2);
        Steering: Steering_Samples_Type := 0;
    end Symptoms;

    protected Measures is
        procedure Read_Distance (Value: out Distance_Samples_Type);
        procedure Write_Distance; 
        procedure Show_Distance;
        procedure Read_Speed (Value: out Speed_Samples_Type);
        procedure Write_Speed;
        procedure Show_Speed;
    private
        Distance: Distance_Samples_Type;
        Speed: Speed_Samples_Type;
    end Measures;

end Driver;