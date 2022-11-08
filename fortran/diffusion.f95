!Gabe Imlay
!CSC330: Organization of Programming Languages
!Project 2: Diffusion Model -> Fortran
!November 17th, 2022

program Diffusion

    integer :: maxsize = 10
    real (kind=8), dimension(:,:,:), allocatable :: cube
    real (kind=8) :: diffusion_coefficient, room_dimension, speed_of_gas_molecules, timestep, distance_between_blocks, DTerm
    real (kind=8) :: time = 0.0, ratio = 0.0, change, sumval, maxval, minval
    !maxsize = 10
    allocate (cube(0:maxsize-1,0:maxsize-1,0:maxsize-1), stat=ierr)
    if ( ierr /= 0 ) then
        print *, "Could not allocate memory - halting run."
        stop
    endif
    cube = 0

    diffusion_coefficient = 0.175
    room_dimension = 5 ! 5 Meters
    speed_of_gas_molecules = 250.0 ! Based on 100 g/mol gas at RT
    timestep = (room_dimension / speed_of_gas_molecules) / maxsize ! h in seconds
    distance_between_blocks = room_dimension / maxsize
    DTerm = diffusion_coefficient * timestep / (distance_between_blocks * distance_between_blocks)

    cube(0,0,0) = 1E21

    do while ( ratio < 0.99 )
        do i = 0, maxsize-1
            do j = 0, maxsize-1
                do k = 0, maxsize-1
                    do l = 0, maxsize-1
                        do m = 0, maxsize-1
                            do n = 0, maxsize-1
                                if (((i == l) .and. (j == m) .and. (k == n + 1)) .or. &
                                    ((i == l) .and. (j == m) .and. (k == n - 1)) .or. &
                                    ((i == l) .and. (j == m + 1) .and. (k == n)) .or. &
                                    ((i == l) .and. (j == m - 1) .and. (k == n)) .or. &
                                    ((i == l + 1) .and. (j == m) .and. (k == n)) .or. &
                                    ((i == l - 1) .and. (j == m) .and. (k == n)) ) then
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
                    maxval = DMAX1(cube(i,j,k),maxval)
                    minval = DMIN1(cube(i,j,k), minval)
                    sumval = sumval + cube(i,j,k)
                end do
            end do
        end do

        ratio = minval/maxval
        WRITE(*, '(F0.5)',advance="no") time
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
    end do

    write(*, '(A)',advance="no") "Box equilibrated in "
    Write(*, '(F0.9)', advance="no") time
    write(*, '(A)',advance="yes") " seconds of simulated time"
    if ( allocated(cube) ) deallocate(cube)

end program Diffusion