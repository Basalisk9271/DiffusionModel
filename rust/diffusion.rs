fn main() {
    // Statements here are executed when the compiled binary is called
    const MDIM: usize = 102; 
    let mut cube:[[[f64;MDIM];MDIM];MDIM] = [[[0.0;MDIM];MDIM];MDIM];
    // Print text to the console
    let val: f64 = MDIM as f64;
    
    for i in 0..MDIM {
      for j in 0..MDIM {
        for k in 0..MDIM {
          cube[i][j][k]=val*val*(i as f64)+val*(j as f64)+(k as f64)+1.0;
        }
      }
    }
    println!("{}", cube[MDIM-1][MDIM-1][MDIM-1]);
    
}