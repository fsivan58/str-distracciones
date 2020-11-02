with Priorities; use Priorities;
with Devices; use Devices;

package State is

    task Display is
        pragma Priority (Display_Priority);
    end Display;

    task Risks is
        pragma Priority (Risk_Priority);
    end Risks;

end State;