! Incfile  : gyre_nad_diff
! Purpose  : nonadiabatic difference equations
!
! Copyright 2016 Rich Townsend
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

module gyre_nad_diff

  ! Uses

  use core_kinds

  use gyre_nad_eqns
  use gyre_nad_match
  use gyre_diff
  use gyre_diff_factory
  use gyre_trapz_diff
  use gyre_ext
  use gyre_model
  use gyre_mode_par
  use gyre_num_par
  use gyre_osc_par
  use gyre_point

  use ISO_FORTRAN_ENV

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type, extends (c_diff_t) :: nad_diff_t
     private
     class(c_diff_t), allocatable :: df
     type(nad_eqns_t)             :: eq
     type(point_t)                :: pt_a
     type(point_t)                :: pt_b
   contains
     private
     procedure, public :: build
  end type nad_diff_t

  ! Interfaces

  interface nad_diff_t
     module procedure nad_diff_t_
  end interface nad_diff_t

  ! Access specifiers

  private

  public :: nad_diff_t

  ! Procedures

contains

  function nad_diff_t_ (ml, pt_a, pt_b, md_p, nm_p, os_p) result (df)

    class(model_t), pointer, intent(in) :: ml
    type(point_t), intent(in)           :: pt_a
    type(point_t), intent(in)           :: pt_b
    type(mode_par_t), intent(in)        :: md_p
    type(num_par_t), intent(in)         :: nm_p
    type(osc_par_t), intent(in)         :: os_p
    type(nad_diff_t)                    :: df

    type(nad_eqns_t) :: eq

    ! Construct the nad_diff_t

    if (pt_a%s == pt_b%s) then

       eq = nad_eqns_t(ml, md_p, os_p)

       select case (nm_p%diff_scheme)
       case ('TRAPZ')
          allocate(df%df, SOURCE=c_trapz_diff_t(eq, pt_a, pt_b, [0.5_WP,0.5_WP,0.5_WP,0.5_WP,0._WP,1._WP]))
       case default
          allocate(df%df, SOURCE=c_diff_t(eq, pt_a, pt_b, nm_p))
       end select
 
       df%eq = eq

       df%pt_a = pt_a
       df%pt_b = pt_b

   else

       allocate(df%df, SOURCE=nad_match_t(ml, pt_a, pt_b, md_p, os_p))

    endif

    df%n_e = df%df%n_e

    ! Finish

    return

  end function nad_diff_t_

  !****

  subroutine build (this, omega, E_l, E_r, scl)

    use gyre_magnus_diff
    use gyre_colloc_diff

    class(nad_diff_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP), intent(out)      :: E_l(:,:)
    complex(WP), intent(out)      :: E_r(:,:)
    type(c_ext_t), intent(out)    :: scl

    type(point_t) :: pt
    complex(WP)   :: A(this%n_e,this%n_e)
    complex(WP)   :: lambda_1
    complex(WP)   :: lambda_2
    complex(WP)   :: lambda_3

    $CHECK_BOUNDS(SIZE(E_l, 1),this%n_e)
    $CHECK_BOUNDS(SIZE(E_l, 2),this%n_e)

    $CHECK_BOUNDS(SIZE(E_r, 1),this%n_e)
    $CHECK_BOUNDS(SIZE(E_r, 2),this%n_e)

    ! Build the difference equations

    call this%df%build(omega, E_l, E_r, scl)

    ! Apply regularization corrections

    select type (df => this%df)

    class is (c_magnus_diff_t)

       ! Rescale by the uncoupled eigenvalues, in order to help the root
       ! finder

       pt%s = this%pt_a%s
       pt%x = 0.5_WP*(this%pt_a%x + this%pt_b%x)

       A = this%eq%A(pt, omega)

       lambda_1 = SQRT(A(2,1)*A(1,2))
       lambda_2 = SQRT(A(4,3)*A(3,4))
       lambda_3 = SQRT(A(6,5)*A(5,6))

       scl = scl*exp(c_ext_t(-(lambda_1+lambda_2+lambda_3)*(this%pt_b%x - this%pt_a%x)))

    ! class is (c_colloc_diff_t)

    !    pt%s = this%pt_a%s
    !    pt%x = 0.5_WP*(this%pt_a%x + this%pt_b%x)

    !    A = this%eq%A(pt, omega)

    !    lambda_1 = SQRT(A(2,1)*A(1,2))
    !    lambda_2 = SQRT(A(4,3)*A(3,4))
    !    lambda_3 = SQRT(A(6,5)*A(5,6))

    !    scl = scl*exp(c_ext_t(-(lambda_1+lambda_2+lambda_3)*(this%pt_b%x - this%pt_a%x)))

    end select

    ! Finish

    return

  end subroutine build

end module gyre_nad_diff
