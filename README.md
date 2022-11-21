# Project 2 - Diffusion Model

## Description
Write a program in different languages (C++, Python, Fortran, Julia, Ada, Lisp, and Rust) that takes an integer argument for the size of the room and a char argument to set a partition flag within the program. The program will simulate a cube room and then proceed to run simulations for how particles would diffuse in said room. The program should then print off the simulated time it would take for the room to equilibrate, or be equal throughout. The program should have the ability to partition the room with a partition that is 75% of the height of the cube if the user so wishes. If the room is partitioned, the program should still accurately predict the equilibration time of the room.  

## Algorithm
This project's programs all share a common structure that includes having all of the program fuinctionality in the main function instead of multiple functions. The way that this works is that the program will ask the user for the size of the roomm and if they want a partition. Then the program creates two 3D arrays for the cube and partition that are the same side. The partition cube will hold the partition wall coordinates to ensure the cube does not diffuse into that area of the cube, but instead has to go around that portion of the cube. The program will loop and run until the whole cube finishes diffusing, at which point the program will display the estimated simulated equilibration time in seconds. 

## Authors and Acknowledgment
Gabe Imlay

## Project status
 -- Completed -- 

## Langauges 

---
### C++

**Compilation:** 

To compile, run:
```
g++ -O2 diffusion.cpp -o diffusion
```
To execute, run:
```
./diffusion
```

--- 
### Python

**Compilation:** This can be achieved by running the single command below. 
```
python3 diffusion.py
```
--- 
### Fortran

**Compilation:** 

To compile, run:
```
gfortran -O2 diffusion.f95 -o diffusion
```
To execute, run:
```
./diffusion
```
--- 
### Julia

**Compilation:** You'll need to make the file executable if it is not already by using `chmod 700 diffusion.jl`. Then, run the command below to execute. 
```
diffusion.jl
```
--- 
### Ada

**Compilation:** 

To compile, run:
```
gnatmake diffusion.adb
```
To execute, run:
```
./diffusion
```
--- 
### Lisp

**Compilation:** You'll need to make the file executable if it is not already by using `chmod 700 diffusion.lisp`. Then, run the command below to execute.
```
diffusion.lisp
```
--- 
### Rust

**Compilation:** 

To compile, run:
```
rustc -O diffusion.rust
```
To execute, run:
```
./diffusion
```
--- 

