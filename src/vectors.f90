MODULE vector_module
! Chapman p. 544
! u%x = ARRAY(1)
! u%y = ARRAY(2)
! u%z = ARRAY(3) 
 IMPLICIT NONE
 TYPE  :: vector
  SEQUENCE
  REAL :: x
  REAL :: y
  REAL :: z
 END TYPE vector
 CONTAINS
  type (vector) function vector_unitary(v1)
   implicit none
   type(vector), intent(in) :: v1
   real                     :: norma
   norma=absvec(v1) 
   vector_unitary%x = v1%x/norma
   vector_unitary%y = v1%y/norma
   vector_unitary%z = v1%z/norma
  end function vector_unitary
  type (vector) function vector_scale(v1, r )
   implicit none
   type(vector), intent(in) :: v1
   real,intent(in)          :: r
   vector_scale%x = v1%x*r
   vector_scale%y = v1%y*r
   vector_scale%z = v1%z*r
  end function vector_scale
! 
   TYPE (vector) FUNCTION vector_add (v1,v2)
    IMPLICIT NONE
    TYPE (vector), INTENT(IN) :: v1
    TYPE (vector), INTENT(IN) :: v2
    vector_add%x = v1%x + v2%x
    vector_add%y = v1%y + v2%y
    vector_add%z = v1%z + v2%z
   END FUNCTION vector_add
!
   TYPE (vector) FUNCTION vector_sub (v1,v2)
    IMPLICIT NONE
    TYPE (vector), INTENT(IN) :: v1
    TYPE (vector), INTENT(IN) :: v2
    vector_sub%x = v1%x - v2%x
    vector_sub%y = v1%y - v2%y
    vector_sub%z = v1%z - v2%z
   END FUNCTION vector_sub
!
   TYPE (vector) FUNCTION cross(a,b) 
    IMPLICIT NONE
    TYPE (vector), INTENT (in) :: a, b
    cross%x = a%y * b%z - a%z * b%y
    cross%y = a%z * b%x - a%x * b%z
    cross%z = a%x * b%y - a%y * b%x
   END FUNCTION cross
!
   REAL FUNCTION absvec(a)
    TYPE (vector), INTENT (in) :: a
    absvec = sqrt(a%x**2 + a%y**2 + a%z**2)
   END FUNCTION absvec
END MODULE vector_module
