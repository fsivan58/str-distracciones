with Priorities; use Priorities;
with devices; use devices;
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
        Pragma Priority (Head_Priority);
        procedure Read_Head_Values (Current_H: out HeadPosition_Samples_Type; Current_S: out Steering_Samples_Type);
        procedure Write_Distance_Symptoms (Colision: in Boolean; Insegura: in Boolean; Imprudente: in Boolean);
        procedure Read_Risks_Symptoms ( Volantazo: out Boolean;
                                        Head: out Boolean;
                                        Insegura: out Boolean;
                                        Imprudente: out Boolean;
                                        Colision: out Boolean);
        procedure Read_Steering_Values (Current_S: out Steering_Samples_Type);
        procedure Read_Sporadic_Symptoms (Colision: out Boolean; Head: out Boolean);
        procedure Write_Head_Symptom (Value: in Boolean);
        procedure Write_Steering_Symptom (Value: in Boolean);
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
        Pragma Priority (Risk_Priority);
        procedure Read_Distance_Values (Current_D: out Distance_Samples_Type; Current_V: out Speed_Samples_Type);
        procedure Read_Speed_Values (Current_V: out Speed_Samples_Type);
        procedure Show_Measures;
        procedure Read_Speed (Value: out Speed_Samples_Type);
    private
        Distance: Distance_Samples_Type;
        Speed: Speed_Samples_Type;
    end Measures;

end Driver;
