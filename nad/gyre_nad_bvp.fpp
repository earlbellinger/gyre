! Module   : gyre_nad_bvp
! Purpose  : solve nonadiabatic BVPs
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

module gyre_nad_bvp

  ! Uses

  use core_kinds
  use core_parallel

  use gyre_bvp
  use gyre_mech_coeffs
  use gyre_mech_coeffs_mpi
  use gyre_therm_coeffs
  use gyre_therm_coeffs_mpi
  use gyre_oscpar
  use gyre_gridpar
  use gyre_numpar
  use gyre_nad_shooter
  use gyre_nad_bound
  use gyre_sysmtx
  use gyre_ext_arith
  use gyre_grid
  use gyre_eigfunc

  use ISO_FORTRAN_ENV

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type, extends(bvp_t) :: nad_bvp_t
     private
     class(mech_coeffs_t), allocatable  :: mc
     class(therm_coeffs_t), allocatable :: tc
     type(oscpar_t)                     :: op
     type(gridpar_t)                    :: gp
     type(numpar_t)                     :: np
     type(nad_shooter_t)                :: sh
     type(nad_bound_t)                  :: bd
     type(sysmtx_t)                     :: sm
     real(WP), allocatable              :: x(:)
     integer                            :: e_norm
     integer, public                    :: n
     integer, public                    :: n_e
   contains 
     private
     procedure, public :: init
     procedure, public :: get_mc
     procedure, public :: get_tc
     procedure, public :: get_op
     procedure, public :: get_gp
     procedure, public :: get_np
     procedure, public :: set_norm
     procedure, public :: discrim
     procedure         :: build
     procedure         :: recon
     procedure, public :: eigfunc
  end type nad_bvp_t

  ! Interfaces

  $if($MPI)

  interface bcast
     module procedure bcast_bp
  end interface bcast

  $endif

  ! Access specifiers

  private

  public :: nad_bvp_t
  $if($MPI)
  public :: bcast
  $endif

  ! Procedures

contains

  subroutine init (this, mc, tc, op, gp, np, x)

    class(nad_bvp_t), intent(out)                  :: this
    class(mech_coeffs_t), intent(in)               :: mc
    class(therm_coeffs_t), allocatable, intent(in) :: tc
    type(oscpar_t), intent(in)                     :: op
    type(gridpar_t), intent(in)                    :: gp
    type(numpar_t), intent(in)                     :: np
    real(WP), intent(in)                           :: x(:)

    integer :: n

    $ASSERT(ALLOCATED(tc),Coefficients missing)

    ! Initialize the nad_bvp

    allocate(this%mc, SOURCE=mc)
    allocate(this%tc, SOURCE=tc)

    this%op = op
    this%gp = gp
    this%np = np

    call this%sh%init(this%mc, this%tc, this%op, this%np)
    call this%bd%init(this%mc, this%tc, this%op)

    n = SIZE(x)

    call this%sm%init(n-1, this%sh%n_e, this%bd%n_i, this%bd%n_o)

    this%x = x

    this%e_norm = 0

    this%n = n
    this%n_e = this%sh%n_e

    ! Finish

    return

  end subroutine init

!****

  $if($MPI)

  subroutine bcast_bp (this, root_rank)

    class(nad_bvp_t), intent(inout) :: this
    integer, intent(in)             :: root_rank

    class(mech_coeffs_t), allocatable  :: mc
    class(therm_coeffs_t), allocatable :: tc
    type(oscpar_t)                     :: op
    type(gridpar_t)                    :: gp
    type(numpar_t)                     :: np
    real(WP), allocatable              :: x(:)

    ! Broadcast the bvp

    if(MPI_RANK == root_rank) then

       call bcast_alloc(this%mc, root_rank)
       call bcast_alloc(this%tc, root_rank)
      
       call bcast(this%op, root_rank)
       call bcast(this%gp, root_rank)
       call bcast(this%np, root_rank)

       call bcast_alloc(this%x, root_rank)

    else

       call bcast_alloc(mc, root_rank)
       call bcast_alloc(tc, root_rank)

       call bcast(op, root_rank)
       call bcast(gp, root_rank)
       call bcast(np, root_rank)
    
       call bcast_alloc(x, root_rank)

       call this%init(mc, tc, op, gp, np, x)

    endif

    ! Finish

    return

  end subroutine bcast_bp

  $endif

!****

  $define $GET $sub

  $local $ITEM_NAME $1
  $local $ITEM_TYPE $2

  function get_$ITEM_NAME (this) result (item)

    class(nad_bvp_t), intent(in), target :: this
    $ITEM_TYPE, pointer                  :: item

    ! Get a pointer to the item

    item => this%$ITEM_NAME

    ! Finish

    return

  end function get_$ITEM_NAME
  
  $endsub

  $GET(mc,class(mech_coeffs_t))
  $GET(tc,class(therm_coeffs_t))
  $GET(op,type(oscpar_t))
  $GET(gp,type(gridpar_t))
  $GET(np,type(numpar_t))
    
!****

  subroutine set_norm (this, omega)

    class(nad_bvp_t), intent(inout) :: this
    complex(WP), intent(in)         :: omega

    type(ext_complex_t) :: discrim

    ! Evaluate the discriminant

    discrim = this%discrim(omega)

    ! Set the normalizing exponent based on this discriminant

    this%e_norm = exponent(discrim)

    ! Finish

    return

  end subroutine set_norm

!****

  function discrim (this, omega, norm)

    class(nad_bvp_t), intent(inout) :: this
    complex(WP), intent(in)         :: omega
    logical, intent(in), optional   :: norm
    type(ext_complex_t)             :: discrim

    logical :: norm_

    if(PRESENT(norm)) then
       norm_ = norm
    else
       norm_ = .FALSE.
    endif

    ! Evaluate the discriminant as the determinant of the sysmtx

    call this%build(omega)

    discrim = this%sm%determinant()

    ! Apply the normalization

    if(norm_) discrim = scale(discrim, -this%e_norm)

    ! Finish

    return

  end function discrim

!****

  subroutine build (this, omega)

    class(nad_bvp_t), intent(inout) :: this
    complex(WP), intent(in)         :: omega

    ! Set up the sysmtx

    call this%sm%set_inner_bound(this%bd%inner_bound(omega))
    call this%sm%set_outer_bound(this%bd%outer_bound(omega))

    call this%sh%shoot(omega, this%x, this%sm)

    ! Finish

    return

  end subroutine build

!****

  subroutine recon (this, omega, x, y)

    class(nad_bvp_t), intent(inout)       :: this
    complex(WP), intent(in)               :: omega
    real(WP), allocatable, intent(out)    :: x(:)
    complex(WP), allocatable, intent(out) :: y(:,:)

    complex(WP) :: y_sh(this%n_e,this%n)
    integer     :: dn(this%n-1)

    ! Reconstruct the solution on the shooting grid

    call this%build(omega)

    y_sh = RESHAPE(this%sm%null_vector(), SHAPE(y_sh))

    ! Set up the grid

    select case (this%gp%grid_type)
    case ('GEOM')
       call build_geom_grid(this%gp%s, this%gp%n_grid, x)
    case ('LOG')
       call build_geom_grid(this%gp%s, this%gp%n_grid, x)
    case ('CLONE')
       x = this%x
    case ('DISP')
       dn = 0
       call plan_dispersion_grid(this%x, this%mc, omega, this%op, &
                                 this%gp%alpha_osc, this%gp%alpha_exp, this%gp%n_center, this%gp%n_floor, dn)
       call build_oversamp_grid(this%x, dn, x)
    case default
       $ABORT(Invalid grid_type)
    end select

    ! Reconstruct the full solution

    allocate(y(this%n_e,SIZE(x)))

    call this%sh%recon(omega, this%x, y_sh, x, y)

    ! Finish

    return

  end subroutine recon

!****

  function eigfunc (this, omega) result (ef)

    class(nad_bvp_t), intent(inout) :: this
    complex(WP), intent(in)         :: omega
    type(eigfunc_t)                 :: ef

    real(WP), allocatable    :: x(:)
    complex(WP), allocatable :: y(:,:)
    integer                  :: n
    complex(WP), allocatable :: xi_r(:)
    complex(WP), allocatable :: xi_h(:)
    complex(WP), allocatable :: phi_pri(:)
    complex(WP), allocatable :: dphi_pri(:)
    complex(WP), allocatable :: del_S(:)
    complex(WP), allocatable :: del_L(:)
    integer                  :: i

    ! Reconstruct the solution

    call this%recon(omega, x, y)

    ! Calculate eigenfunctions

    n = SIZE(x)

    allocate(xi_r(n))
    allocate(xi_h(n))
    allocate(phi_pri(n))
    allocate(dphi_pri(n))
    allocate(del_S(n))
    allocate(del_L(n))

    do i = 1, n

       associate(c_1 => this%mc%c_1(x(i)))

         ! Scale the solution

         if(x(i) > 0._WP) then
            y(:,i) = y(:,i)*x(i)**(this%op%lambda_0+1._WP)
         else
            if(this%op%lambda_0 /= -1._WP) then
               y(:,i) = 0._WP
            endif
         endif
       
         ! Calculate radial & horizontal displacements

         if(this%op%l == 0) then
            xi_r(i) = y(1,i)
            xi_h(i) = 0._WP
         else
            xi_r(i) = y(1,i)
            xi_h(i) = y(2,i)/(c_1*omega**2)
         endif

         ! Calculate gravitational perturbations

         phi_pri(i) = x(i)*y(3,i)/c_1
         dphi_pri(i) = y(4,i)/c_1

         ! Calculate thermal perturbations

         del_S(i) = x(i)*y(5,i)
         del_L(i) = x(i)**2*y(6,i)

       end associate

    end do

    ! Initialize the eigfunc
    
    call ef%init(this%op, omega, x, xi_r, xi_h, phi_pri, dphi_pri, del_S, del_L)

    ! Finish

    return

  end function eigfunc

end module gyre_nad_bvp
