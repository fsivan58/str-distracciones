with Devices; use Devices;

package Measures_PKG is
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
end Measures_PKG;