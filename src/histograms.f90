PROGRAM histogram
 IMPLICIT NONE
 INTEGER            :: n_datos = 0
 INTEGER            :: n_boxs  = 200
 INTEGER            :: ierr,i,j,k
 REAL               :: max_,min_,suma
 CHARACTER (LEN=80) :: line
 REAL, allocatable  :: values(:),delta(:)
 LOGICAL            :: normalise = .false.
!
 OPEN(111,FILE="input",STATUS='OLD',ACTION='READ',IOSTAT=IERR)
 fileopen: IF( IERR == 0) THEN
  read_: DO
    READ (111,'(A)',IOSTAT=IERR) line
    IF( IERR /= 0 ) EXIT
    n_datos = n_datos + 1
  END DO read_
  REWIND( 111 )
 ENDIF fileopen
 ALLOCATE(values(1:n_datos) ,STAT=IERR)
 ALLOCATE(delta(0:n_boxs+1) ,STAT=IERR)
 IF(IERR/=0) STOP '[ERROR] variables sin alicatar en memoria.'
 datas: DO i=1,n_datos
   READ(111,*) values(i)
 END DO datas
 max_  = MAXVAL(values)
 min_  = MINVAL(values)
 delta(0) = min_
 DO j=1,n_boxs+1
    delta(j)=delta(j-1)+(max_-min_)/REAL(n_boxs)
 ENDDO
 CALL make_histogram(values,delta,n_datos,n_boxs+1)
 CLOSE(111)
 DEALLOCATE(values)
 DEALLOCATE(delta)
CONTAINS
 SUBROUTINE make_histogram(data,bound,j,k)
   IMPLICIT NONE
   INTEGER :: j,k
   REAL    :: ave,adev,sdev,var,skew,curt
   REAL,   intent(in) :: data(1:j)
   REAL,   intent(in) :: bound(0:k)
   REAL    :: histo(0:k)
   INTEGER :: i
   suma=0.0
   do i = 1,k
      histo(i) = count( data <= bound(i) .and. data >= bound(i-1))
   enddo
   ave = SUM(histo)
   do i=1,k
      histo(i)=histo(i)/ave
      WRITE(6,'(f10.6,f10.6)') bound(i),histo(i)
   end do
   CALL moment(data,j,ave,adev,sdev,var,skew,curt)
   WRITE(6,*)'# ave,sdev,skew,curt:'
   WRITE(6,*)'# moments:',ave,sdev,skew,curt
   WRITE(6,*)'# adev,var:'
   WRITE(6,*)'# deviation:',adev,var
 END SUBROUTINE make_histogram
!
 SUBROUTINE moment(data,n,ave,adev,sdev,var,skew,curt)
  IMPLICIT NONE
! Numerical Recipes (Fortran 90), pp 607-608.
! Given an array of data(1:n), its returns its mean ave, average deviation adev,
! standar deviation sdev, variance var, skewness skew, and kurtosis curt.
  INTEGER :: n,j
  REAL    :: adev,ave,curt,sdev,skew,var,data(n)
  REAL    :: p,ep
  REAL    :: s = 0.0
  IF (n<=1) PRINT*,'n must be at least 2 in moment'
  DO j=1,n
     s=s+data(j)
  END DO
  ave  = s/real(n)
  adev = 0.0
  var  = 0.0
  skew = 0.0
  curt = 0.0
  ep   = 0.0
  storage: DO j=1,n
     s    = data(j) - ave
     ep   = ep + s
     adev = adev + abs(s)
     p    = s*s
     var  = var + p
     p    = p*s
     skew = skew + p
     p    = p*s
     curt = curt + p
  END DO storage
  adev = adev/real(n)
  var  = (var-ep*ep/real(n))/(n-1)
  sdev = sqrt(var)
  IF(var/=0.0)THEN
    skew = skew/(n*adev**3)
    curt = curt/(n*var*var)-3.0
  ELSE
   skew=0.0
   curt=0.0
  end if
  RETURN
 END SUBROUTINE
END PROGRAM histogram
