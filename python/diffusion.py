#Gabe Imlay
#CSC330: Organization of Programming Languages
#Project 2: Diffusion Model -> Python
#November 17th, 2022

import math


def main():
    maxsize = int(input("What would you like maxsize to be: "))
    choice = input("Would you like a partition (y for 'yes' and n for 'no'): ")
    cube = [[[0.0] * (maxsize) for _ in range(maxsize)] for _ in range(maxsize)]
    partition = [[[0.0] * (maxsize) for _ in range(maxsize)] for _ in range(maxsize)]
    # Zero the cube
    i = 0
    while (i < maxsize) :
        j = 0
        while (j < maxsize) :
            k = 0
            while (k < maxsize) :
                cube[i][j][k] = 0.0
                k += 1
            j += 1
        i += 1
  
    diffusion_coefficient = 0.175
    room_dimension = 5 # 5 Meters
    speed_of_gas_molecules = 250.0 # Based on 100 g/mol gas at RT
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize # h in seconds
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)
    
    # Zero the partition
    i = 0
    while (i < maxsize) :
        j = 0
        while (j < maxsize) :
            k = 0
            while (k < maxsize) :
                partition[i][j][k] = 0
                k += 1
            j += 1
        i += 1
    # Initialize the first cell

    cube[0][0][0] = 1.0E21

    if (choice == 'y'):
        #if the user selects yes, set the partition as 1's in the partition cube
        i = (math.ceil(maxsize*.5)-1)
        for j in range (math.ceil(maxsize*.25)-1, maxsize) :
            for k in range (0,maxsize) :
                partition[i][j][k] = 1
                
    # Initialize the first cell


    time = 0.0 # to keep up with accumulated system time.
    ratio = 0.0
    
     
     
    
    
     
     
    while True :
        i = 0
        while (i < maxsize) :
            j = 0
            while (j < maxsize) :
                k = 0 
                while (k < maxsize) :
                    l = 0 
                    while (l < maxsize) :
                        m = 0
                        while (m < maxsize) :
                            n = 0 
                            while (n < maxsize) :
                                if ((   ((i == l) and (j == m) and (k == n + 1)) or 
                                        ((i == l) and (j == m) and (k == n - 1)) or 
                                        ((i == l) and (j == m + 1) and (k == n)) or 
                                        ((i == l) and (j == m - 1) and (k == n)) or 
                                        ((i == l + 1) and (j == m) and (k == n)) or 
                                        ((i == l - 1) and (j == m) and (k == n))) and partition[i][j][k] != 1 and partition[l][m][n] != 1) :
                                    change = (cube[i][j][k] - cube[l][m][n]) * DTerm
                                    cube[i][j][k] = cube[i][j][k] - change
                                    cube[l][m][n] = cube[l][m][n] + change
                                n += 1
                            m += 1
                        l += 1
                    k += 1
                j += 1
            i += 1
        
        time = time + timestep
        
        sumval = 0.0
        maxval = cube[0][0][0]
        minval = cube[0][0][0]
        
        i = 0
        while (i < maxsize) :
            j = 0
            while (j < maxsize) :
                k = 0
                while (k < maxsize) :
                    if (partition[i][j][k] != 1):
                        maxval = max(cube[i][j][k],maxval)
                        minval = min(cube[i][j][k],minval)
                        sumval += cube[i][j][k]
                    k += 1
                j += 1
            i += 1
        
        ratio = minval / maxval
        
        # System.out.println( ratio + " time = " + time);
        print(str(time) + " " + str(cube[0][0][0]), end ="")
        print(" " + str(cube[maxsize - 1][0][0]), end ="")
        print(" " + str(cube[maxsize - 1][maxsize - 1][0]), end ="")
        print(" " + str(cube[maxsize - 1][maxsize - 1][maxsize - 1]), end ="")
        print(" " + str(sumval) + "\n", end ="")
        if((ratio < 0.99) == False) :
                break
    print("Box equilibrated in " + str(time) + " seconds of simulated time.")


main()