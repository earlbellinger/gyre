! Module   : gyre_nad_dziem_bound
! Purpose  : nonadiabatic boundary conditions (Dziembowski formulation)
!
! Copyright 2013 Rich Townsend
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

module gyre_nad_dziem_bound

  ! Uses

  use core_kinds

  use gyre_bound
  use gyre_model
  use gyre_jacobian
  use gyre_modepar

  use ISO_FORTRAN_ENV

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type, extends (bound_t) :: nad_dziem_bound_t
     private
     class(model_t), pointer        :: ml => null()
     class(jacobian_t), allocatable :: jc
     type(modepar_t)                :: mp
   contains 
     private
     procedure, public :: inner_bound => inner_bound_
     procedure, public :: outer_bound => outer_bound_
  end type nad_dziem_bound_t

  ! Interfaces

  interface nad_dziem_bound_t
     module procedure nad_dziem_bound_t_
  end interface nad_dziem_bound_t

  ! Access specifiers

  private

  public :: nad_dziem_bound_t

  ! Procedures

contains

  function nad_dziem_bound_t_ (ml, jc, mp) result (bd)

    class(model_t), pointer, intent(in) :: ml
    class(jacobian_t), intent(in)       :: jc
    type(modepar_t), intent(in)         :: mp
    type(nad_dziem_bound_t)             :: bd

    ! Construct the nad_dziem_bound_t

    bd%ml => ml
    allocate(bd%jc, SOURCE=jc)
    bd%mp = mp

    bd%n_i = 3
    bd%n_o = 3
    bd%n_e = bd%n_i + bd%n_o

    $CHECK_BOUNDS(bd%n_e,bd%jc%n_e)

    ! Finish

    return
    
  end function nad_dziem_bound_t_

!****

  function inner_bound_ (this, x_i, omega) result (B_i)

    class(nad_dziem_bound_t), intent(in) :: this
    real(WP), intent(in)                 :: x_i
    complex(WP), intent(in)              :: omega
    complex(WP)                          :: B_i(this%n_i,this%n_e)

    $ASSERT(x_i == 0._WP,Boundary condition invalid for x_i /= 0)

    ! Set the inner boundary conditions to enforce non-diverging modes

    associate(c_1 => this%ml%c_1(x_i), l => this%mp%l, &
              omega_c => this%ml%omega_c(x_i, this%mp%m, omega))

      B_i(1,1) = c_1*omega_c**2
      B_i(1,2) = -l
      B_i(1,3) = 0._WP
      B_i(1,4) = 0._WP
      B_i(1,5) = 0._WP
      B_i(1,6) = 0._WP

      B_i(2,1) = 0._WP
      B_i(2,2) = 0._WP
      B_i(2,3) = l
      B_i(2,4) = -1._WP
      B_i(2,5) = 0._WP
      B_i(2,6) = 0._WP

      B_i(3,1) = 0._WP
      B_i(3,2) = 0._WP
      B_i(3,3) = 0._WP
      B_i(3,4) = 0._WP
      B_i(3,5) = 1._WP
      B_i(3,6) = 0._WP

    end associate

    B_i = MATMUL(B_i, this%jc%trans_matrix(x_i, omega, .TRUE.))

    ! Finish

    return

  end function inner_bound_

!****

  function outer_bound_ (this, x_o, omega) result (B_o)

    class(nad_dziem_bound_t), intent(in) :: this
    real(WP), intent(in)                 :: x_o
    complex(WP), intent(in)              :: omega
    complex(WP)                          :: B_o(this%n_o,this%n_e)

    ! Set the outer boundary conditions

    associate(V => this%ml%V(x_o), nabla_ad => this%ml%nabla_ad(x_o), &
              l => this%mp%l, omega_c => this%ml%omega_c(x_o, this%mp%m, omega))

      B_o(1,1) = 1 + (l*(l+1)/omega_c**2 - 4 - omega_c**2)/V
      B_o(1,2) = -1._WP
      B_o(1,3) = 1 + (l*(l+1)/omega_c**2 - l - 1)/V
      B_o(1,4) = 0._WP
      B_o(1,5) = 0._WP
      B_o(1,6) = 0._WP
     
      B_o(2,1) = 0._WP
      B_o(2,2) = 0._WP
      B_o(2,3) = l + 1._WP
      B_o(2,4) = 1._WP
      B_o(2,5) = 0._WP
      B_o(2,6) = 0._WP

      B_o(3,1) = 2._WP - 4._WP*nabla_ad*V
      B_o(3,2) = 4._WP*nabla_ad*V
      B_o(3,3) = -4._WP*nabla_ad*V
      B_o(3,4) = 0._WP
      B_o(3,5) = 4._WP
      B_o(3,6) = -1._WP

    end associate

    B_o = MATMUL(B_o, this%jc%trans_matrix(x_o, omega, .TRUE.))

    ! Finish

    return

  end function outer_bound_

end module gyre_nad_dziem_bound