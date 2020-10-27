with Devices; use Devices;

package symptoms_pkg is
    protected Symptoms is
        procedure Write_Head_Symptom (Value: in Boolean);
        procedure Read_Head_Symptom (Value: in Boolean);
        procedure Write_Distancia_Insegura (Value: in Boolean);
        procedure Read_Distancia_Insegura (Value: in Boolean);
        procedure Write_Distancia_Imprudente (Value: in Boolean);
        procedure Read_Distancia_Imprudente (Value: in Boolean);
        procedure Write_Peligro_Colision (Value: in Boolean);
        procedure Read_Peligro_Colision (Value: in Boolean);
        procedure Write_HeadPosition;
        procedure Read_HeadPosition (Value: out HeadPosition_Samples_Type);
    private
        Head_Symptom: Boolean := False;
        Distancia_Insegura: Boolean := False;
        Distancia_Imprudente: Boolean := False;
        Peligro_Colision: Boolean := False;
        HeadPosition: HeadPosition_Samples_Type := (+2, -2);
    end Symptoms;
end symptoms_pkg;
