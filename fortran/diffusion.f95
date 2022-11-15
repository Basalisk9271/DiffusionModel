!Gabe Imlay
!CSC330: Organization of Programming Languages
!Project 2: Diffusion Model -> Fortran
!November 17th, 2022

program Diffusion
    implicit none
    !declare all variables and dynamic arrays
    real (kind=8), dimension(:,:,:), allocatable :: cube
    integer (kind=8), dimension(:,:,:), allocatable :: partition
    integer :: maxsize, i, j, k, l, m, n, ierr
    character(len=1) :: choice
    real (kind=8) :: diffusion_coefficient, room_dimension, speed_of_gas_molecules, timestep, distance_between_blocks, DTerm
    real (kind=8) :: time = 0.0, ratio = 0.0, change, sumval, maxval, minval
    
    !get user input for maxsize and choice
    write(*,"(A)",advance="no") "What would you like maxsize to be: "
    read *,maxsize
    write(*,"(A)",advance="no") "Would you like a partition (y for 'yes' and n for 'no'): "
    read *,choice
    
    !allocate the arrays with maxsize gotten from the user
    allocate (cube(0:maxsize-1,0:maxsize-1,0:maxsize-1), stat=ierr)
    allocate (partition(0:maxsize-1,0:maxsize-1,0:maxsize-1), stat=ierr)
    if ( ierr /= 0 ) then
        print *, "Could not allocate memory - halting run."
        stop
    endif
    
    !zero the cube and the partition
    cube = 0
    partition = 0
    

    diffusion_coefficient = 0.175
    room_dimension = 5 ! 5 Meters
    speed_of_gas_molecules = 250.0 ! Based on 100 g/mol gas at RT
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize ! h in seconds
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

    cube(0,0,0) = 1E21

    !if the user selects yes, set the partition as 1's in the partition cube
    if (choice .eq. 'y') then
        i = int(ceiling(real(maxsize*.5))-1)
        do j = int(ceiling(real(maxsize*.25))-1), maxsize-1
            do k = 0, maxsize-1
                partition(i,j,k) = 1
            end do
        end do
    end if
    
    do while ( .true. )
        do i = 0, maxsize-1
            do j = 0, maxsize-1
                do k = 0, maxsize-1
                    do l = 0, maxsize-1
                        do m = 0, maxsize-1
                            do n = 0, maxsize-1
                                if ((((i == l) .and. (j == m) .and. (k == n + 1)) .or. &
                                    ((i == l) .and. (j == m) .and. (k == n - 1)) .or. &
                                    ((i == l) .and. (j == m + 1) .and. (k == n)) .or. &
                                    ((i == l) .and. (j == m - 1) .and. (k == n)) .or. &
                                    ((i == l + 1) .and. (j == m) .and. (k == n)) .or. &
                                    ((i == l - 1) .and. (j == m) .and. (k == n))) .and. &
                                    (partition(i,j,k) /=1 .and. partition(l,m,n) /=1)) then
                                    !must check to see if a specified block on the partition cube is part of the partition or not
                                        change = (cube(i,j,k) - cube(l,m,n)) * DTerm
                                        cube(i,j,k) = cube(i,j,k) - change
                                        cube(l,m,n) = cube(l,m,n) + change
                                end if
                            end do
                        end do
                    end do
                end do
            end do
        end do

        time = time + timestep

        sumval = 0.0
        maxval = cube(0,0,0)
        minval = cube(0,0,0)

        do i = 0, maxsize-1
            do j = 0, maxsize-1
                do k = 0, maxsize-1
                    if (partition(i,j,k) /= 1) then 
                        maxval = DMAX1(cube(i,j,k),maxval)
                        minval = DMIN1(cube(i,j,k), minval)
                        sumval = sumval + cube(i,j,k)
                    end if
                end do
            end do
        end do

        ratio = minval/maxval
        WRITE(*, '(F0.5)',advance="no") time
        write(*, '(A)',advance="no") " "
        WRITE(*, '(F0.16)',advance="no") ratio
        write(*, '(A)',advance="no") " "
        WRITE(*, '(F0.5)',advance="no") cube(0,0,0)
        write(*, '(A)',advance="no") " "
        write(*, '(F0.5)',advance="no") cube(maxsize-1,0,0)
        write(*, '(A)',advance="no") " "
        write(*, '(F0.5)',advance="no") cube(maxsize-1,maxsize-1,0)
        write(*, '(A)',advance="no") " "
        write(*, '(F0.5)',advance="no") cube(maxsize-1,maxsize-1,maxsize-1)
        write(*, '(A)',advance="no") " "
        write(*, '(F0.5)',advance="yes") sumval
        if (ratio >= .99) exit
    end do

    write(*, '(A)',advance="no") "Box equilibrated in "
    Write(*, '(F0.9)', advance="no") time
    write(*, '(A)',advance="yes") " seconds of simulated time"
    if ( allocated(cube) ) deallocate(cube)
    if ( allocated(partition) ) deallocate(partition)

end program Diffusion