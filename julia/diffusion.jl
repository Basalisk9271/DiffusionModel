#!/usr2/local/julia-1.8.2/bin/julia
#Gabe Imlay
#CSC330: Organization of Programming Languages
#Project 2: Diffusion Model -> Julia
#November 17th, 2022

function main()
    print("What would you like maxsize to be: ")
    maxsize = parse(Int32, readline())

    print("Would you like a partition (y for 'yes' and n for 'no'): ")
    choice = readline()
    cube = Array{Float64,3}(undef, maxsize, maxsize, maxsize)
    partition = Array{Float64,3}(undef, maxsize, maxsize, maxsize)
    #zero the cube
    fill!(cube, 0.0)
    #zero the partition
    fill!(partition, 0)

    time = 0.0
    ratio = 0.0
    diffusion_coefficient = 0.175
    room_dimension = 5 # 5 Meters
    speed_of_gas_molecules = 250.0 # Based on 100 g/mol gas at RT
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize # h in seconds
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

    #Initialize the first cell
    cube[1,1,1] = 1.0E21

    #if the user selects yes, set the partition as 1's in the partition cube
    if choice == "y"
    i = ceil(Int,maxsize*.5)
        for j = ceil(Int,maxsize*.25):maxsize
            for k = 1:maxsize
                partition[i,j,k] = 1
            end
        end
    end
    while true
        for i = 1:maxsize
            for j = 1:maxsize
                for k = 1:maxsize
                    for l = 1:maxsize
                        for m = 1:maxsize
                            for n = 1:maxsize
                                if (( ((i == l) && (j == m) && (k == n + 1)) || ((i == l) && (j == m) && (k == n - 1)) || ((i == l) && (j == m + 1) && (k == n)) || ((i == l) && (j == m - 1) && (k == n)) || ((i == l + 1) && (j == m) && (k == n)) || ((i == l - 1) && (j == m) && (k == n))) && (partition[i,j,k] != 1 && partition[l,m,n] != 1))
                                    change = (cube[i,j,k] - cube[l,m,n]) * DTerm;
                                    cube[i,j,k] = cube[i,j,k] - change;
                                    cube[l,m,n] = cube[l,m,n] + change;
                                end
                            end
                        end
                    end
                end
            end
        end

        time += timestep

        sumval = 0.0
        maxval = cube[1,1,1]
        minval = cube[1,1,1]

        for i = 1:maxsize
            for j = 1:maxsize
                for k = 1:maxsize
                    #protect from the partition
                    if partition[i,j,k] != 1
                        maxval = max(cube[i,j,k],maxval);
                        minval = min(cube[i,j,k],minval);
                        sumval += cube[i,j,k];
                    end
                end
            end
        end
        
        ratio = minval / maxval

        # print(time," ",cube[1,1,1])
        # print(" ",cube[maxsize,1,1])
        # print(" ",cube[maxsize,maxsize,1])
        # print(" ",cube[maxsize,maxsize,maxsize])
        # println(" ",sumval)

        if (ratio >= 0.99) 
            break
        end
    end

    println("Box equilibrated in ",time," seconds of simulated time.")

end

main()