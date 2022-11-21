use std::io::{self, Write};
fn main() {
    // Statements here are executed when the compiled binary is called
    
    let mut ms = String::new(); //string to take input for the size
    println!("What would you like maxsize to be: ");
    io::stdout().flush().unwrap();
    io::stdin().read_line(&mut ms).expect("Could not get input!");
    let mut temp = ms.trim().parse::<i32>().expect("Input not an integer"); //convert string to integer for size
    let val = temp as f64;
    temp = temp + 1;
    let maxsize: usize = temp as usize;
    let mut cube = vec![vec![vec![0.0f64; maxsize]; maxsize]; maxsize];
    let mut choice = String::new();
    println!("Would you like a partition (y for 'yes' and n for 'no'): ");
    io::stdout().flush().unwrap();
    io::stdin().read_line(&mut choice).expect("Could not get input!");
    
    let mut partition = vec![vec![vec![0i32; maxsize]; maxsize]; maxsize];
    
    let diffusion_coefficient = 0.175;
    let room_dimension = 5.0; // 5 Meters
    let speed_of_gas_molecules = 250.0;// Based on 100 g/mol gas at RT
    let timestep = (room_dimension / speed_of_gas_molecules) / val; // h in seconds
    let distance_between_blocks = room_dimension / val;
    let dterm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks);
    let partition_top = ((val)*0.25).ceil() as usize;
    let mut time = 0.0;
    let mut ratio = 0.0;

    cube [1][1][1] = 1E21;
    
    if choice.trim() == "y" {
      let i = ((val)*0.5).ceil() as usize;
      for j in partition_top..maxsize{
        for k in 1..maxsize{
          partition[i][j][k] = 1;
        }
      }
    }
    
    loop {
      let mut change = 0.0;
      let mut sumval = 0.0;
      let mut maxval = cube[1][1][1];
      let mut minval = cube[1][1][1];
      
      for i in 1..maxsize {
        for j in 1..maxsize {
          for k in 1..maxsize {
            for l in 1..maxsize {
              for m in 1..maxsize {
                for n in 1..maxsize {
                  if  (((i == l) && (j == m) && (k == n + 1)) || 
                          ((i == l) && (j == m) && (k == n - 1)) || 
                          ((i == l) && (j == m + 1) && (k == n)) || 
                          ((i == l) && (j == m - 1) && (k == n)) || 
                          ((i == l + 1) && (j == m) && (k == n)) || 
                          ((i == l - 1) && (j == m) && (k == n))) && (partition[i][j][k] != 1 && partition[l][m][n] != 1){
                          change = (cube[i][j][k] - cube[l][m][n]) * dterm;
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

      for i in 1..maxsize {
        for j in 1..maxsize {
          for k in 1..maxsize {
            // protect from the partition
            if partition[i][j][k] != 1 {
                maxval = (cube[i][j][k]).max(maxval);
                minval = (cube[i][j][k]).min(minval);
                sumval = sumval + cube[i][j][k];
            }
          }
        }
      }

      ratio = minval/maxval;

      //println!("{} {} {} {} {} {} {} {} {}", time, ratio, minval, maxval, cube [1][1][1], cube [maxsize-1][1][1], cube [maxsize-1][maxsize-1][1], cube [maxsize-1][maxsize-1][maxsize-1], sumval);

      if ratio >= 0.99{
        break;
      }
    }
    // for i in 1..maxsize {
    //   for j in 1..maxsize {
    //     for k in 1..maxsize {
    //       print!("{}", partition[i][j][k]);
    //     }
    //     println!();
    //   }
    //   println!();
    // }//print off the cube 



    println!("Box equilibrated in {} seconds of simulated time.", time);
    
}