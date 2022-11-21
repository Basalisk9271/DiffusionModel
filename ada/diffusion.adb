-- Gabe Imlay
-- CSC330: Organization of Programming Languages
-- Project 2: Diffusion Model -> Ada
-- November 17th, 2022

with ada.text_io, ada.integer_text_io, ada.Long_Float_text_io;
use ada.text_io, ada.integer_text_io, ada.Long_Float_text_io;

procedure diffusion is
    -- declare type of arrays
    type Three_Dimensional_Float_Array is array (Integer range <>, Integer range <>, Integer range <>) of Long_Float;
    type Three_Dimensional_Integer_Array is array (Integer range <>, Integer range <>, Integer range <>) of Integer;
    
    --introduce all of the variables
    maxsize : Integer := 1;
    choice : Character;

begin
    put("What would you like maxsize to be: ");
    get(maxsize);
    put("Would you like a partition (y for 'yes' and n for 'no'): ");
    get(choice);

    
    declare
        -- creation of the arrays with their sizes and filled with 0's 
        cube :  Three_Dimensional_Float_Array ( 0..maxsize, 0..maxsize, 0..maxsize) := (others => (others => (others => 0.0)));
        partition :  Three_Dimensional_Integer_Array ( 0..maxsize, 0..maxsize, 0..maxsize) := (others => (others => (others => 0)));
        
        -- declaration of most of the float variable used in the physics of the simulation
        i : Integer;
        diffusion_coefficient : Long_Float := 0.175;
        room_dimension : Long_Float := 5.0; -- 5 Meters
        speed_of_gas_molecules : Long_Float := 250.0; -- Based on 100 g/mol gas at RT
        timestep: Long_Float := Long_Float ((room_dimension / speed_of_gas_molecules) / Long_Float(maxsize)); -- h in seconds
        distance_between_blocks : Long_Float := room_dimension / Long_Float(maxsize);
        DTerm : Long_Float := diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks);
        time : Long_Float := 0.00;
        ratio : Long_Float := 0.0;
        partitionTop : integer := Integer (Long_Float'Ceiling(Long_Float(maxsize)*0.25));
        Finished : Boolean := False;

    begin
        -- Initialize the first cell 
        cube(1,1,1) := 1.0e21;

        -- if the user selects yes, set the partition as 1's in the partition cube
        if choice = 'y' then
            i:= Integer (Long_Float'Ceiling(Long_Float(maxsize)*0.5));
            for j in partitionTop..maxsize loop
                for k in 1..maxsize loop
                    partition(i,j,k) := 1;
                end loop;
            end loop;
        end if;
        loop
            declare
                change : Long_Float;
                sumval : Long_Float := 0.0;
                maxval : Long_Float := cube(1,1,1);
                minval : Long_Float := cube(1,1,1);
            
            begin
                for i in 1..maxsize loop
                    for j in 1..maxsize loop
                        for k in 1..maxsize loop
                            for l in 1..maxsize loop
                                for m in 1..maxsize loop
                                    for n in 1..maxsize loop
                                        if (    (((i = l) and (j = m) and (k = n + 1)) or 
                                                ((i = l) and (j = m) and (k = n - 1)) or 
                                                ((i = l) and (j = m + 1) and (k = n)) or 
                                                ((i = l) and (j = m - 1) and (k = n)) or 
                                                ((i = l + 1) and (j = m) and (k = n)) or 
                                                ((i = l - 1) and (j = m) and (k = n))) and (partition (i,j,k) /= 1 and partition(l,m,n) /= 1)) then
                                                change := (cube(i,j,k) - cube(l,m,n)) *DTerm;
                                                cube(i,j,k) := cube(i,j,k) - change;
                                                cube(l,m,n) := cube(l,m,n) + change;
                                        end if;
                                    end loop;
                                end loop;
                            end loop;
                        end loop;
                    end loop;
                end loop;

                time := time + timestep;

                for i in 1..maxsize loop
                    for j in 1..maxsize loop
                        for k in 1..maxsize loop
                            -- protect from the partition
                            if partition(i,j,k) /= 1 then
                                maxval := Long_Float'Max(cube(i,j,k),maxval);
                                minval := Long_Float'Min(cube(i,j,k),minval);
                                sumval := sumval + cube(i,j,k);
                            end if;
                        end loop;
                    end loop;
                end loop;

                ratio := minval/maxval;
                
                --put(time,0,5,0);
                --put(" ");
                --put(minval);
                --put(" ");
                --put(maxval);
                --put(" ");
                --put(ratio);
                --put(" ");
                --put(cube(1,1,1));
                --put(" ");
                --put(cube(maxsize,1,1));
                --put(" ");
                --put(cube(maxsize,maxsize,1));
                --put(" ");
                --put(cube(maxsize,maxsize,maxsize));
                --put(" ");
                --put(sumval);
                --new_line;

                
            end;
            
            if (ratio >= 0.99) then
                Finished := True;
            end if;
            exit when Finished;
        end loop;

        put("Box equilibrated in ");
        put(time, 0,5,0);
        put(" seconds of simulated time.");
        new_line;
    end;
end diffusion;