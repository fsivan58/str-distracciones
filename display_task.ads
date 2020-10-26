with priorities; use priorities;

package display_task is
    task Display is
        pragma Priority (Display_Priority);
    end Display;
end display_task;