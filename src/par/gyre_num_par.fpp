! Module   : gyre_num_par
! Purpose  : numerics parameters
!
! Copyright 2013-2018 Rich Townsend
!
! This file is part of GYRE. GYRE is free software: you can
! redistribute it and/or modify it under the terms of the GNU General
! Public License as published by the Free Software Foundation, version 3.
!
! GYRE is distributed in the hope that it will be useful, but WITHOUT
! ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
! or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
! License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.

$include 'core.inc'

module gyre_num_par

  ! Uses

  use core_kinds

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type :: num_par_t
     integer         :: n_iter_max = 50
     logical         :: deflate_roots = .TRUE.
     logical         :: restrict_roots = .TRUE.
     character(64)   :: diff_scheme = 'COLLOC_GL2'
     character(64)   :: r_root_solver = 'BRENT'
     character(64)   :: c_root_solver = 'RIDDERS'
     character(64)   :: matrix_type = 'BLOCK'
     character(2048) :: tag_list = ''
  end type num_par_t

  ! Access specifiers

  private

  public :: num_par_t
  public :: read_num_par

  ! Procedures

contains

  subroutine read_num_par (unit, nm_p)

    integer, intent(in)                       :: unit
    type(num_par_t), allocatable, intent(out) :: nm_p(:)

    integer                            :: n_nm_p
    integer                            :: i
    integer                            :: n_iter_max
    logical                            :: deflate_roots
    logical                            :: restrict_roots
    character(LEN(nm_p%diff_scheme))   :: diff_scheme
    character(LEN(nm_p%r_root_solver)) :: r_root_solver
    character(LEN(nm_p%c_root_solver)) :: c_root_solver
    character(LEN(nm_p%matrix_type))   :: matrix_type
    character(LEN(nm_p%tag_list))      :: tag_list

    namelist /num/ n_iter_max, deflate_roots, restrict_roots, &
         diff_scheme, r_root_solver, c_root_solver, matrix_type, tag_list

    ! Count the number of num namelists

    rewind(unit)

    n_nm_p = 0

    count_loop : do
       read(unit, NML=num, END=100)
       n_nm_p = n_nm_p + 1
    end do count_loop

100 continue

    ! Read numerical parameters

    rewind(unit)

    allocate(nm_p(n_nm_p))

    read_loop : do i = 1,n_nm_p

       ! Set default values

       nm_p(i) = num_par_t()

       n_iter_max = nm_p(i)%n_iter_max
       deflate_roots = nm_p(i)%deflate_roots
       restrict_roots = nm_p(i)%restrict_roots
       diff_scheme = nm_p(i)%diff_scheme
       r_root_solver = nm_p(i)%r_root_solver
       c_root_solver = nm_p(i)%c_root_solver
       matrix_type = nm_p(i)%matrix_type
       tag_list = nm_p(i)%tag_list

       ! Read the namelist

       read(unit, NML=num)

       ! Store read values

       nm_p(i)%n_iter_max = n_iter_max
       nm_p(i)%deflate_roots = deflate_roots
       nm_p(i)%restrict_roots = restrict_roots
       nm_p(i)%diff_scheme = diff_scheme
       nm_p(i)%r_root_solver = r_root_solver
       nm_p(i)%c_root_solver = c_root_solver
       nm_p(i)%matrix_type = matrix_type
       nm_p(i)%tag_list = tag_list

    end do read_loop

    ! Finish

    return

  end subroutine read_num_par

end module gyre_num_par