//Gabe Imlay
//CSC330: Organization of Programming Languages
//Project 2: Diffusion Model -> C++
//November 17th, 2022

#include <iostream>
#include <string>
#include <vector>
#include <math.h>

using namespace std;

int main(int argc, char **argv)
{
    
    int maxsize;
    char choice;
    //takes in the number for maxsize
    cout << "What would you like maxsize to be: ";
    cin >> maxsize;
    //take in whether the user wants a partition or not
    do{
        cout << "Would you like a partition (y for 'yes' and n for 'no'): ";
        cin >> choice;
    }while(choice != 'y' && choice != 'n');
    
    //Dynamic arrays for the partition and cube
    vector<vector<vector<double> > > cube(maxsize, vector<vector<double> > (maxsize,vector<double> (maxsize)));
    vector<vector<vector<int> > > partition(maxsize, vector<vector<int> > (maxsize,vector<int> (maxsize)));

    // Zero the cube
    for (int i = 0; i < maxsize; i++)
    {
        for (int j = 0; j < maxsize; j++)
        {
            for (int k = 0; k < maxsize; k++)
            {
                cube[i][j][k] = 0.0;
            }
        }
    }
    double diffusion_coefficient = 0.175;
    double room_dimension = 5; // 5 Meters
    double speed_of_gas_molecules = 250.0; // Based on 100 g/mol gas at RT
    double timestep = (room_dimension / speed_of_gas_molecules) / maxsize; // h in seconds
    double distance_between_blocks = room_dimension / maxsize;
    double DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks);
    
    // Zero the partition
    for (int i = 0; i < maxsize; i++)
    {
        for (int j = 0; j < maxsize; j++)
        {
            for (int k = 0; k < maxsize; k++)
            {
                partition[i][j][k] = 0;
            }
        }
    }
    
   
    
    // Initialize the first cell
    //
    cube[0][0][0] = 1.0E21;

    if (choice == 'y'){
        //if the user selects yes, set the partition as 1's in the partition cube
        int i = ceil(maxsize*.5)-1;
        for (int j = ceil(maxsize*.25)-1; j < maxsize; j++)
        {
            for (int k = 0; k < maxsize; k++)
            {
                partition[i][j][k] = 1;
            }
        }
    }
  
    double time = 0.0; // to keep up with accumulated system time.
    double ratio = 0.0;
    do
    {
        for (int i = 0; i < maxsize; i++){
            for (int j = 0; j < maxsize; j++){
                for (int k = 0; k < maxsize; k++){
                    for (int l = 0; l < maxsize; l++){
                        for (int m = 0; m < maxsize; m++){
                            for (int n = 0; n < maxsize; n++){
                                if (    (((i == l) && (j == m) && (k == n + 1)) || 
                                        ((i == l) && (j == m) && (k == n - 1)) || 
                                        ((i == l) && (j == m + 1) && (k == n)) || 
                                        ((i == l) && (j == m - 1) && (k == n)) || 
                                        ((i == l + 1) && (j == m) && (k == n)) || 
                                        ((i == l - 1) && (j == m) && (k == n))) && partition [i][j][k] != 1 && partition[l][m][n] != 1) {
                                        //must check to see if a specified block in the partition cube is a partion or not 
                                    
                                    double change = (cube[i][j][k] - cube[l][m][n]) * DTerm;
                                    cube[i][j][k] = cube[i][j][k] - change;
                                    cube[l][m][n] = cube[l][m][n] + change;
                                }
                            }
                        }
                    }
                }
            }
        }

        time = time + timestep;

        double sumval = 0.0;
        double maxval = cube[0][0][0];
        double minval = cube[0][0][0];
        for (int i = 0; i < maxsize; i++){
            for (int j = 0; j < maxsize; j++){
                for (int k = 0; k < maxsize; k++){
                    if (partition[i][j][k] != 1){ // protect from the partition
                        maxval = max(cube[i][j][k],maxval);
                        minval = min(cube[i][j][k],minval);
                        sumval += cube[i][j][k];
                    }
                    
                }
            }
        }

        ratio = minval / maxval;

        // System.out.println( ratio + " time = " + time);
        // cout << to_string(time) + " " + to_string(cube[0][0][0]);
        // cout << " " + to_string(cube[maxsize - 1][0][0]);
        // cout << " " + to_string(cube[maxsize - 1][maxsize - 1][0]);
        // cout << " " + to_string(cube[maxsize - 1][maxsize - 1][maxsize - 1]);
        // cout << " " + to_string(sumval) + "\n";
    } while (ratio < 0.99);
    
    cout << "Box equilibrated in " + to_string(time) + " seconds of simulated time." << endl;
    return 0;
}
