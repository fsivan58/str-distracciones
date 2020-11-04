
package Priorities is

    Sporadic_Priority : constant integer := 20;
    Risk_Priority : constant integer := 19;      -- 150 ms
    Distance_Priority : constant integer := 18;  -- 300 ms
    Steering_Priority : constant integer := 17;  -- 350 ms
    Head_Priority : constant integer := 16;      -- 400 ms
    Display_Priority : constant integer := 15;   -- 1000 ms

end Priorities;