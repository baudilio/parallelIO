PROGRAM MAIN
  USE MPI
  IMPLICIt NONE

  Integer :: rank, numprocs, namelen
  Character(len=MPI_MAX_PROCESSOR_NAME) :: processor_name
  character(32) :: fileName
  Integer :: amode, info, fh
  Integer :: ierr

  INTEGER, Parameter :: BUFSIZE = 10000
  INTEGER, Parameter :: nl = 5 + 1
  CHARACTER(LEN=nl) :: rec
  CHARACTER(LEN=nl*BUFSIZE) :: buf = ""
  INTEGER:: i

! ---
  CALL MPI_Init ( ierr )
  CALL MPI_Comm_rank ( MPI_COMM_WORLD, rank, ierr )
  CALL MPI_Comm_size ( MPI_COMM_WORLD, numprocs, ierr )
  CALL MPI_Get_processor_name ( processor_name, namelen, ierr)

  !
  write(UNIT=fileName, FMT='("test_",I0,".txt")') rank

  !
  info = MPI_INFO_NULL
  amode = MPI_MODE_CREATE + MPI_MODE_WRONLY
  CALL MPI_FILE_OPEN(MPI_COMM_SELF, fileName, amode, info, fh, ierr)

  do i=1, BUFSIZE

     WRITE(UNIT=rec, FMT='(I5)') i ! convert the INT to a STR

     buf = TRIM(ADJUSTL(buf)) // TRIM(ADJUSTL(rec)) // CHAR(10) ! Append STR into buf

  end do

  ! Call WRITE only once:
  CALL MPI_File_write ( fh, buf, Len_TRIM(buf), MPI_CHARACTER,  MPI_STATUS_IGNORE, ierr )

  CALL MPI_File_close ( fh, ierr )
  CALL MPI_Finalize ( ierr )

END PROGRAM MAIN
