! Incfile  : gyre_bound
! Purpose  : boundary conditions (template)
!
! Copyright 2013-2015 Rich Townsend
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

$define $MOD_DECL $sub

$local $T $1
$local $TYPE $2

module gyre_${T}_bound

  ! Uses

  use core_kinds

  ! No implicit typing

  implicit none

  ! Derived-type definitions

  type, abstract :: ${T}_bound_t
     private
     integer, public :: n_i
     integer, public :: n_o
     integer, public :: n_e
   contains
     private
     procedure(build_), deferred, public :: build_i
     procedure(build_), deferred, public :: build_o
   end type ${T}_bound_t

  ! Interfaces

  abstract interface

     subroutine build_ (this, omega, B, scl)
       use core_kinds
       import ${T}_bound_t
       class(${T}_bound_t), intent(in) :: this
       $TYPE(WP), intent(in)           :: omega
       $TYPE(WP), intent(out)          :: B(:,:)
       $TYPE(WP), intent(out)          :: scl(:)
     end subroutine build_

  end interface

  ! Access specifiers

  private

  public :: ${T}_bound_t

end module gyre_${T}_bound

$endsub