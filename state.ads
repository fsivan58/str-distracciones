with Priorities; use Priorities;
with Devices; use Devices;

package State is

    task Display is
        pragma Priority (Display_Priority);
    end Display;

    task Risks is
        pragma Priority (Risk_Priority);
    end Risks;

    protected Operation_Mode is
        procedure Write_Mode (Value: in Boolean);
        procedure Read_Mode (Value: out Boolean);
    private
        Mode: integer := 1;
    end Operation_Mode;

    protected Interruption_Handler is
        pragma Priority (Sporadic_Priority);
        procedure Validate_Entry;
        pragma Attach_Handler (Validate_Entry, Ada.Interrupt.Names.External_Interrupt_2);
        entry Change_Mode;
    private
        Enter: Boolean := False;
    end Interruption_Handler;

end State;