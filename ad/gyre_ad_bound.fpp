! Module   : gyre_ad_bound
! Purpose  : adiabatic boundary conditions

$include 'core.inc'

module gyre_ad_bound

  ! Uses

  use core_kinds

  use gyre_mech_coeffs

  use ISO_FORTRAN_ENV

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type :: ad_bound_t
     private
     class(mech_coeffs_t), pointer             :: mc
     real(WP)                                  :: lambda_0
     integer                                   :: l
     integer, public                           :: n_e
     integer, public                           :: n_i
     integer, public                           :: n_o 
     procedure(outer_bound_i), pointer, public :: outer_bound
   contains 
     private
     procedure, public :: init
     procedure, public :: inner_bound
  end type ad_bound_t

  ! Interfaces

  abstract interface

     function outer_bound_i (this, omega) result (B_o)
       use core_kinds
       import ad_bound_t
       class(ad_bound_t), intent(in) :: this
       complex(WP), intent(in)       :: omega
       complex(WP)                   :: B_o(this%n_o,this%n_e)
     end function outer_bound_i

  end interface

  ! Access specifiers

  private

  public :: ad_bound_t

  ! Procedures

contains

  subroutine init (this, mc, lambda_0, l, outer_bound)

    class(ad_bound_t), intent(out)           :: this
    class(mech_coeffs_t), intent(in), target :: mc
    real(WP), intent(in)                     :: lambda_0
    integer, intent(in)                      :: l
    character(LEN=*), intent(in)             :: outer_bound

    ! Initialize the ad_bound

    this%mc => mc

    this%lambda_0 = lambda_0
    this%l = l
    
    this%n_i = 2
    this%n_o = 2
    this%n_e = this%n_i + this%n_o

    select case (outer_bound)
    case ('ZERO')
       this%outer_bound => outer_bound_zero
    case ('DZIEM')
       this%outer_bound => outer_bound_dziem
    case ('UNNO')
       this%outer_bound => outer_bound_unno
    case ('JCD')
       this%outer_bound => outer_bound_jcd
    case default
       $ABORT(Invalid outer_bound)
    end select

    ! Finish

    return
    
  end subroutine init

!****

  function inner_bound (this, omega) result (B_i)

    class(ad_bound_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP)                   :: B_i(this%n_i,this%n_e)

    ! Set the inner boundary conditions to enforce non-diverging modes

    associate(c_1 => this%mc%c_1(0._WP), &
              lambda_0 => this%lambda_0, l => this%l)
                 
      B_i(1,1) = c_1*omega**2
      B_i(1,2) = -l
      B_i(1,3) = 0._WP
      B_i(1,4) = 0._WP

      B_i(2,1) = 0._WP
      B_i(2,2) = 0._WP
      B_i(2,3) = l
      B_i(2,4) = -1._WP

    end associate

    ! Finish

    return

  end function inner_bound

!****

  function outer_bound_zero (this, omega) result (B_o)

    class(ad_bound_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP)                   :: B_o(this%n_o,this%n_e)

    ! Set the outer boundary conditions, assuming delta p -> 0. The U
    ! term in the gravitational bc is required for cases where the
    ! surface density remains finite (see Cox 1980, eqn. 17.71)

    associate(U => this%mc%U(1._WP), l => this%l)

      B_o(1,1) = 1._WP
      B_o(1,2) = -1._WP
      B_o(1,3) = 1._WP
      B_o(1,4) = 0._WP
      
      B_o(2,1) = U
      B_o(2,2) = 0._WP
      B_o(2,3) = l + 1._WP
      B_o(2,4) = 1._WP

    end associate

    ! Finish

    return

  end function outer_bound_zero

!****

  function outer_bound_dziem (this, omega) result (B_o)

    class(ad_bound_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP)                   :: B_o(this%n_o,this%n_e)

    ! Set the outer boundary conditions, assuming Dziembowski's (1971)
    ! condition: d(delta p)/dr -> 0 for an isothermal atmosphere.

    associate(U => this%mc%U(1._WP), V => this%mc%V(1._WP), &
              l => this%l)

      B_o(1,1) = 1 + (l*(l+1)/omega**2 - 4 - omega**2)/V
      B_o(1,2) = -1._WP
      B_o(1,3) = 1 + (l*(l+1)/omega**2 - l - 1)/V
      B_o(1,4) = 0._WP
     
      B_o(2,1) = 0._WP
      B_o(2,2) = 0._WP
      B_o(2,3) = l + 1._WP
      B_o(2,4) = 1._WP

    end associate

    ! Finish

    return

  end function outer_bound_dziem

!****

  function outer_bound_unno (this, omega) result (B_o)

    class(ad_bound_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP)                   :: B_o(this%n_o,this%n_e)

    complex(WP) :: lambda
    complex(WP) :: b_11
    complex(WP) :: b_12
    complex(WP) :: b_13
    complex(WP) :: b_21
    complex(WP) :: b_22
    complex(WP) :: b_23
    complex(WP) :: alpha_1
    complex(WP) :: alpha_2

    ! Set the outer boundary conditions, assuming Unno et al.'s (1989,
    ! S18.1) formulation.

    associate(V_g => this%mc%V(1._WP)/this%mc%Gamma_1(1._WP), &
              As => this%mc%As(1._WP), l => this%l)

      lambda = outer_wavenumber(V_g, As, omega, l)
      
      b_11 = V_g - 3._WP
      b_12 = l*(l+1)/omega**2 - V_g
      b_13 = V_g

      b_21 = omega**2 - As
      b_22 = 1._WP + As
      b_23 = -As
    
      alpha_1 = (b_12*b_23 - b_13*(b_22+l))/((b_11+l)*(b_22+l) - b_12*b_21)
      alpha_2 = (b_21*b_13 - b_23*(b_11+l))/((b_11+l)*(b_22+l) - b_12*b_21)

      B_o(1,1) = (lambda - b_11)/b_12
      B_o(1,2) = -1._WP
      B_o(1,3) = -(alpha_1*(lambda - b_11)/b_12 - alpha_2)
      B_o(1,4) = 0._WP

      B_o(2,1) = 0._WP
      B_o(2,2) = 0._WP
      B_o(2,3) = l + 1._WP
      B_o(2,4) = 1._WP

    end associate

    ! Finish

    return

  end function outer_bound_unno

!****

  function outer_bound_jcd (this, omega) result (B_o)

    class(ad_bound_t), intent(in) :: this
    complex(WP), intent(in)       :: omega
    complex(WP)                   :: B_o(this%n_o,this%n_e)

    complex(WP) :: lambda
    complex(WP) :: b_11
    complex(WP) :: b_12

    ! Set the outer boundary conditions, assuming
    ! Christensen-Dalsgaard's formulation (see ADIPLS documentation)

    associate(V_g => this%mc%V(1._WP)/this%mc%Gamma_1(1._WP), &
              As => this%mc%V(1._WP)*(1._WP-1._WP/this%mc%Gamma_1(1._WP)), &
              l => this%l)

      b_11 = V_g - 3._WP
      b_12 = l*(l+1)/omega**2 - V_g

      if(l /= 0) then
         B_o(1,1) = (lambda - b_11)/b_12
         B_o(1,2) = -1._WP
         B_o(1,3) = 1._WP + (l*(l+1)/omega**2 - l - 1._WP)/(V_g + As)
         B_o(1,4) = 0._WP
      else
         B_o(1,1) = (lambda - b_11)/b_12
         B_o(1,2) = -1._WP
         B_o(1,3) = 1._WP
         B_o(1,4) = 0._WP
      endif

      B_o(2,1) = 0._WP
      B_o(2,2) = 0._WP
      B_o(2,3) = l + 1._WP
      B_o(2,4) = 1._WP

    end associate

    ! Finish

    return

  end function outer_bound_jcd

!****

  function outer_wavenumber (V_g, As, omega, l) result (lambda)

    real(WP)                :: V_g
    real(WP), intent(in)    :: As
    complex(WP), intent(in) :: omega
    integer, intent(in)     :: l
    complex(WP)             :: lambda

    real(WP)    :: a
    real(WP)    :: b
    real(WP)    :: c
    real(WP)    :: omega2_c_1
    real(WP)    :: omega2_c_2
    complex(WP) :: gamma
    complex(WP) :: sgamma

    ! Calculate the wavenumber at the outer boundary

    if(AIMAG(omega) == 0._WP) then

       ! Calculate cutoff frequencies

       a = -4._WP*V_g
       b = (As - V_g + 4._WP)**2 + 4._WP*V_g*As + 4._WP*l*(l+1)
       c = -4._WP*l*(l+1)*As

       omega2_c_1 = (-b + SQRT(b**2 - 4._WP*a*c))/(2._WP*a)
       omega2_c_2 = (-b - SQRT(b**2 - 4._WP*a*c))/(2._WP*a)

       $ASSERT(omega2_c_2 > omega2_c_1,Incorrect cutoff frequency ordering)

       ! Evaluate the wavenumber

       gamma = -4._WP*V_g*(omega**2 - omega2_c_1)*(omega**2 - omega2_c_2)/omega**2

       if(REAL(omega**2) > omega2_c_2) then

          ! Acoustic waves

          lambda = 0.5_WP*((V_g + As - 2._WP) - SQRT(gamma))

       elseif(REAL(omega**2) < omega2_c_1) then

          ! Gravity waves

          lambda = 0.5_WP*((V_g + As - 2._WP) + SQRT(gamma))

       else

          ! Evanescent

          lambda = 0.5_WP*((V_g + As - 2._WP) - SQRT(gamma))

       endif

    else

       ! Evaluate the wavenumber

       gamma = (As - V_g + 4._WP)**2 + 4*(l*(l+1)/omega**2 - V_g)*(omega**2 - As)
       sgamma = SQRT(gamma)

       if(AIMAG(omega) > 0._WP) then

          ! Decaying oscillations; choose the wave with diverging
          ! energy density (see Townsend 2000b)

          if(REAL(sgamma) > 0._WP) then
             lambda = 0.5_WP*((V_g + As - 2._WP) + sgamma)
          else
             lambda = 0.5_WP*((V_g + As - 2._WP) - sgamma)
          endif

       else

          ! Growing oscillations; choose the wave with non-diverging
          ! energy density (see Townsend 2000b)

          if(REAL(sgamma) > 0._WP) then
             lambda = 0.5_WP*((V_g + As - 2._WP) - sgamma)
          else
             lambda = 0.5_WP*((V_g + As - 2._WP) + sgamma)
          endif

       endif

    end if

    ! Finish

    return

  end function outer_wavenumber

end module gyre_ad_bound
