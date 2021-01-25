!STARTOFREGISTRYGENERATEDFILE 'IfW_BladedFFWind_Types.f90'
!
! WARNING This file is generated automatically by the FAST registry.
! Do not edit.  Your changes to this file will be lost.
!
! FAST Registry
!*********************************************************************************************************************************
! IfW_BladedFFWind_Types
!.................................................................................................................................
! This file is part of IfW_BladedFFWind.
!
! Copyright (C) 2012-2016 National Renewable Energy Laboratory
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!
!
! W A R N I N G : This file was automatically generated from the FAST registry.  Changes made to this file may be lost.
!
!*********************************************************************************************************************************
!> This module contains the user-defined types needed in IfW_BladedFFWind. It also contains copy, destroy, pack, and
!! unpack routines associated with each defined data type. This code is automatically generated by the FAST Registry.
MODULE IfW_BladedFFWind_Types
!---------------------------------------------------------------------------------------------------------------------------------
USE IfW_FFWind_Base_Types
USE NWTC_Library
IMPLICIT NONE
! =========  IfW_BladedFFWind_InitInputType  =======
  TYPE, PUBLIC :: IfW_BladedFFWind_InitInputType
    CHARACTER(1024)  :: WindFileName      !< Name of the wind file to use [-]
    LOGICAL  :: TowerFileExist      !< Tower file exists [-]
    INTEGER(IntKi)  :: SumFileUnit      !< Unit number for the summary file (-1 for none).  Provided by IfW. [-]
    LOGICAL  :: NativeBladedFmt      !< Whether this is native Bladed (needs wind profile and TI scaling) or not [-]
  END TYPE IfW_BladedFFWind_InitInputType
! =======================
! =========  IfW_BladedFFWind_InitOutputType  =======
  TYPE, PUBLIC :: IfW_BladedFFWind_InitOutputType
    TYPE(ProgDesc)  :: Ver      !< Version information off FFWind submodule [-]
    REAL(ReKi) , DIMENSION(1:3)  :: TI      !< Turbulence intensity given in the file [-]
    REAL(ReKi)  :: PropagationDir      !< Propogation direction from native Bladed format [degrees]
    REAL(ReKi)  :: VFlowAngle      !< Vertical flow angle from native Bladed format [degrees]
  END TYPE IfW_BladedFFWind_InitOutputType
! =======================
! =========  IfW_BladedFFWind_MiscVarType  =======
  TYPE, PUBLIC :: IfW_BladedFFWind_MiscVarType
    INTEGER(IntKi)  :: dummy = 0      !< An Index into the TData array [-]
  END TYPE IfW_BladedFFWind_MiscVarType
! =======================
! =========  IfW_BladedFFWind_ParameterType  =======
  TYPE, PUBLIC :: IfW_BladedFFWind_ParameterType
    TYPE(IfW_FFWind_ParameterType)  :: FF      !< Parameters used in all full-field wind types [-]
  END TYPE IfW_BladedFFWind_ParameterType
! =======================
CONTAINS
 SUBROUTINE IfW_BladedFFWind_CopyInitInput( SrcInitInputData, DstInitInputData, CtrlCode, ErrStat, ErrMsg )
   TYPE(IfW_BladedFFWind_InitInputType), INTENT(IN) :: SrcInitInputData
   TYPE(IfW_BladedFFWind_InitInputType), INTENT(INOUT) :: DstInitInputData
   INTEGER(IntKi),  INTENT(IN   ) :: CtrlCode
   INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
   CHARACTER(*),    INTENT(  OUT) :: ErrMsg
! Local 
   INTEGER(IntKi)                 :: i,j,k
   INTEGER(IntKi)                 :: i1, i1_l, i1_u  !  bounds (upper/lower) for an array dimension 1
   INTEGER(IntKi)                 :: ErrStat2
   CHARACTER(ErrMsgLen)           :: ErrMsg2
   CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_CopyInitInput'
! 
   ErrStat = ErrID_None
   ErrMsg  = ""
    DstInitInputData%WindFileName = SrcInitInputData%WindFileName
    DstInitInputData%TowerFileExist = SrcInitInputData%TowerFileExist
    DstInitInputData%SumFileUnit = SrcInitInputData%SumFileUnit
    DstInitInputData%NativeBladedFmt = SrcInitInputData%NativeBladedFmt
 END SUBROUTINE IfW_BladedFFWind_CopyInitInput

 SUBROUTINE IfW_BladedFFWind_DestroyInitInput( InitInputData, ErrStat, ErrMsg )
  TYPE(IfW_BladedFFWind_InitInputType), INTENT(INOUT) :: InitInputData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
  CHARACTER(*),    PARAMETER :: RoutineName = 'IfW_BladedFFWind_DestroyInitInput'
  INTEGER(IntKi)                 :: i, i1, i2, i3, i4, i5 
! 
  ErrStat = ErrID_None
  ErrMsg  = ""
 END SUBROUTINE IfW_BladedFFWind_DestroyInitInput

 SUBROUTINE IfW_BladedFFWind_PackInitInput( ReKiBuf, DbKiBuf, IntKiBuf, Indata, ErrStat, ErrMsg, SizeOnly )
  REAL(ReKi),       ALLOCATABLE, INTENT(  OUT) :: ReKiBuf(:)
  REAL(DbKi),       ALLOCATABLE, INTENT(  OUT) :: DbKiBuf(:)
  INTEGER(IntKi),   ALLOCATABLE, INTENT(  OUT) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_InitInputType),  INTENT(IN) :: InData
  INTEGER(IntKi),   INTENT(  OUT) :: ErrStat
  CHARACTER(*),     INTENT(  OUT) :: ErrMsg
  LOGICAL,OPTIONAL, INTENT(IN   ) :: SizeOnly
    ! Local variables
  INTEGER(IntKi)                 :: Re_BufSz
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_BufSz
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_BufSz
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i,i1,i2,i3,i4,i5
  LOGICAL                        :: OnlySize ! if present and true, do not pack, just allocate buffers
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_PackInitInput'
 ! buffers to store subtypes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)

  OnlySize = .FALSE.
  IF ( PRESENT(SizeOnly) ) THEN
    OnlySize = SizeOnly
  ENDIF
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_BufSz  = 0
  Db_BufSz  = 0
  Int_BufSz  = 0
      Int_BufSz  = Int_BufSz  + 1*LEN(InData%WindFileName)  ! WindFileName
      Int_BufSz  = Int_BufSz  + 1  ! TowerFileExist
      Int_BufSz  = Int_BufSz  + 1  ! SumFileUnit
      Int_BufSz  = Int_BufSz  + 1  ! NativeBladedFmt
  IF ( Re_BufSz  .GT. 0 ) THEN 
     ALLOCATE( ReKiBuf(  Re_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating ReKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Db_BufSz  .GT. 0 ) THEN 
     ALLOCATE( DbKiBuf(  Db_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating DbKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Int_BufSz  .GT. 0 ) THEN 
     ALLOCATE( IntKiBuf(  Int_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating IntKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF(OnlySize) RETURN ! return early if only trying to allocate buffers (not pack them)

  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred = 1

    DO I = 1, LEN(InData%WindFileName)
      IntKiBuf(Int_Xferred) = ICHAR(InData%WindFileName(I:I), IntKi)
      Int_Xferred = Int_Xferred + 1
    END DO ! I
    IntKiBuf(Int_Xferred) = TRANSFER(InData%TowerFileExist, IntKiBuf(1))
    Int_Xferred = Int_Xferred + 1
    IntKiBuf(Int_Xferred) = InData%SumFileUnit
    Int_Xferred = Int_Xferred + 1
    IntKiBuf(Int_Xferred) = TRANSFER(InData%NativeBladedFmt, IntKiBuf(1))
    Int_Xferred = Int_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_PackInitInput

 SUBROUTINE IfW_BladedFFWind_UnPackInitInput( ReKiBuf, DbKiBuf, IntKiBuf, Outdata, ErrStat, ErrMsg )
  REAL(ReKi),      ALLOCATABLE, INTENT(IN   ) :: ReKiBuf(:)
  REAL(DbKi),      ALLOCATABLE, INTENT(IN   ) :: DbKiBuf(:)
  INTEGER(IntKi),  ALLOCATABLE, INTENT(IN   ) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_InitInputType), INTENT(INOUT) :: OutData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
    ! Local variables
  INTEGER(IntKi)                 :: Buf_size
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i
  INTEGER(IntKi)                 :: i1, i1_l, i1_u  !  bounds (upper/lower) for an array dimension 1
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_UnPackInitInput'
 ! buffers to store meshes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred  = 1
    DO I = 1, LEN(OutData%WindFileName)
      OutData%WindFileName(I:I) = CHAR(IntKiBuf(Int_Xferred))
      Int_Xferred = Int_Xferred + 1
    END DO ! I
    OutData%TowerFileExist = TRANSFER(IntKiBuf(Int_Xferred), OutData%TowerFileExist)
    Int_Xferred = Int_Xferred + 1
    OutData%SumFileUnit = IntKiBuf(Int_Xferred)
    Int_Xferred = Int_Xferred + 1
    OutData%NativeBladedFmt = TRANSFER(IntKiBuf(Int_Xferred), OutData%NativeBladedFmt)
    Int_Xferred = Int_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_UnPackInitInput

 SUBROUTINE IfW_BladedFFWind_CopyInitOutput( SrcInitOutputData, DstInitOutputData, CtrlCode, ErrStat, ErrMsg )
   TYPE(IfW_BladedFFWind_InitOutputType), INTENT(IN) :: SrcInitOutputData
   TYPE(IfW_BladedFFWind_InitOutputType), INTENT(INOUT) :: DstInitOutputData
   INTEGER(IntKi),  INTENT(IN   ) :: CtrlCode
   INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
   CHARACTER(*),    INTENT(  OUT) :: ErrMsg
! Local 
   INTEGER(IntKi)                 :: i,j,k
   INTEGER(IntKi)                 :: i1, i1_l, i1_u  !  bounds (upper/lower) for an array dimension 1
   INTEGER(IntKi)                 :: ErrStat2
   CHARACTER(ErrMsgLen)           :: ErrMsg2
   CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_CopyInitOutput'
! 
   ErrStat = ErrID_None
   ErrMsg  = ""
      CALL NWTC_Library_Copyprogdesc( SrcInitOutputData%Ver, DstInitOutputData%Ver, CtrlCode, ErrStat2, ErrMsg2 )
         CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg,RoutineName)
         IF (ErrStat>=AbortErrLev) RETURN
    DstInitOutputData%TI = SrcInitOutputData%TI
    DstInitOutputData%PropagationDir = SrcInitOutputData%PropagationDir
    DstInitOutputData%VFlowAngle = SrcInitOutputData%VFlowAngle
 END SUBROUTINE IfW_BladedFFWind_CopyInitOutput

 SUBROUTINE IfW_BladedFFWind_DestroyInitOutput( InitOutputData, ErrStat, ErrMsg )
  TYPE(IfW_BladedFFWind_InitOutputType), INTENT(INOUT) :: InitOutputData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
  CHARACTER(*),    PARAMETER :: RoutineName = 'IfW_BladedFFWind_DestroyInitOutput'
  INTEGER(IntKi)                 :: i, i1, i2, i3, i4, i5 
! 
  ErrStat = ErrID_None
  ErrMsg  = ""
  CALL NWTC_Library_Destroyprogdesc( InitOutputData%Ver, ErrStat, ErrMsg )
 END SUBROUTINE IfW_BladedFFWind_DestroyInitOutput

 SUBROUTINE IfW_BladedFFWind_PackInitOutput( ReKiBuf, DbKiBuf, IntKiBuf, Indata, ErrStat, ErrMsg, SizeOnly )
  REAL(ReKi),       ALLOCATABLE, INTENT(  OUT) :: ReKiBuf(:)
  REAL(DbKi),       ALLOCATABLE, INTENT(  OUT) :: DbKiBuf(:)
  INTEGER(IntKi),   ALLOCATABLE, INTENT(  OUT) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_InitOutputType),  INTENT(IN) :: InData
  INTEGER(IntKi),   INTENT(  OUT) :: ErrStat
  CHARACTER(*),     INTENT(  OUT) :: ErrMsg
  LOGICAL,OPTIONAL, INTENT(IN   ) :: SizeOnly
    ! Local variables
  INTEGER(IntKi)                 :: Re_BufSz
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_BufSz
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_BufSz
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i,i1,i2,i3,i4,i5
  LOGICAL                        :: OnlySize ! if present and true, do not pack, just allocate buffers
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_PackInitOutput'
 ! buffers to store subtypes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)

  OnlySize = .FALSE.
  IF ( PRESENT(SizeOnly) ) THEN
    OnlySize = SizeOnly
  ENDIF
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_BufSz  = 0
  Db_BufSz  = 0
  Int_BufSz  = 0
   ! Allocate buffers for subtypes, if any (we'll get sizes from these) 
      Int_BufSz   = Int_BufSz + 3  ! Ver: size of buffers for each call to pack subtype
      CALL NWTC_Library_Packprogdesc( Re_Buf, Db_Buf, Int_Buf, InData%Ver, ErrStat2, ErrMsg2, .TRUE. ) ! Ver 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf)) THEN ! Ver
         Re_BufSz  = Re_BufSz  + SIZE( Re_Buf  )
         DEALLOCATE(Re_Buf)
      END IF
      IF(ALLOCATED(Db_Buf)) THEN ! Ver
         Db_BufSz  = Db_BufSz  + SIZE( Db_Buf  )
         DEALLOCATE(Db_Buf)
      END IF
      IF(ALLOCATED(Int_Buf)) THEN ! Ver
         Int_BufSz = Int_BufSz + SIZE( Int_Buf )
         DEALLOCATE(Int_Buf)
      END IF
      Re_BufSz   = Re_BufSz   + SIZE(InData%TI)  ! TI
      Re_BufSz   = Re_BufSz   + 1  ! PropagationDir
      Re_BufSz   = Re_BufSz   + 1  ! VFlowAngle
  IF ( Re_BufSz  .GT. 0 ) THEN 
     ALLOCATE( ReKiBuf(  Re_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating ReKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Db_BufSz  .GT. 0 ) THEN 
     ALLOCATE( DbKiBuf(  Db_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating DbKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Int_BufSz  .GT. 0 ) THEN 
     ALLOCATE( IntKiBuf(  Int_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating IntKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF(OnlySize) RETURN ! return early if only trying to allocate buffers (not pack them)

  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred = 1

      CALL NWTC_Library_Packprogdesc( Re_Buf, Db_Buf, Int_Buf, InData%Ver, ErrStat2, ErrMsg2, OnlySize ) ! Ver 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Re_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Re_Buf) > 0) ReKiBuf( Re_Xferred:Re_Xferred+SIZE(Re_Buf)-1 ) = Re_Buf
        Re_Xferred = Re_Xferred + SIZE(Re_Buf)
        DEALLOCATE(Re_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
      IF(ALLOCATED(Db_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Db_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Db_Buf) > 0) DbKiBuf( Db_Xferred:Db_Xferred+SIZE(Db_Buf)-1 ) = Db_Buf
        Db_Xferred = Db_Xferred + SIZE(Db_Buf)
        DEALLOCATE(Db_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
      IF(ALLOCATED(Int_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Int_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Int_Buf) > 0) IntKiBuf( Int_Xferred:Int_Xferred+SIZE(Int_Buf)-1 ) = Int_Buf
        Int_Xferred = Int_Xferred + SIZE(Int_Buf)
        DEALLOCATE(Int_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
    DO i1 = LBOUND(InData%TI,1), UBOUND(InData%TI,1)
      ReKiBuf(Re_Xferred) = InData%TI(i1)
      Re_Xferred = Re_Xferred + 1
    END DO
    ReKiBuf(Re_Xferred) = InData%PropagationDir
    Re_Xferred = Re_Xferred + 1
    ReKiBuf(Re_Xferred) = InData%VFlowAngle
    Re_Xferred = Re_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_PackInitOutput

 SUBROUTINE IfW_BladedFFWind_UnPackInitOutput( ReKiBuf, DbKiBuf, IntKiBuf, Outdata, ErrStat, ErrMsg )
  REAL(ReKi),      ALLOCATABLE, INTENT(IN   ) :: ReKiBuf(:)
  REAL(DbKi),      ALLOCATABLE, INTENT(IN   ) :: DbKiBuf(:)
  INTEGER(IntKi),  ALLOCATABLE, INTENT(IN   ) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_InitOutputType), INTENT(INOUT) :: OutData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
    ! Local variables
  INTEGER(IntKi)                 :: Buf_size
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i
  INTEGER(IntKi)                 :: i1, i1_l, i1_u  !  bounds (upper/lower) for an array dimension 1
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_UnPackInitOutput'
 ! buffers to store meshes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred  = 1
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Re_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Re_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Re_Buf = ReKiBuf( Re_Xferred:Re_Xferred+Buf_size-1 )
        Re_Xferred = Re_Xferred + Buf_size
      END IF
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Db_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Db_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Db_Buf = DbKiBuf( Db_Xferred:Db_Xferred+Buf_size-1 )
        Db_Xferred = Db_Xferred + Buf_size
      END IF
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Int_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Int_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Int_Buf = IntKiBuf( Int_Xferred:Int_Xferred+Buf_size-1 )
        Int_Xferred = Int_Xferred + Buf_size
      END IF
      CALL NWTC_Library_Unpackprogdesc( Re_Buf, Db_Buf, Int_Buf, OutData%Ver, ErrStat2, ErrMsg2 ) ! Ver 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf )) DEALLOCATE(Re_Buf )
      IF(ALLOCATED(Db_Buf )) DEALLOCATE(Db_Buf )
      IF(ALLOCATED(Int_Buf)) DEALLOCATE(Int_Buf)
    i1_l = LBOUND(OutData%TI,1)
    i1_u = UBOUND(OutData%TI,1)
    DO i1 = LBOUND(OutData%TI,1), UBOUND(OutData%TI,1)
      OutData%TI(i1) = ReKiBuf(Re_Xferred)
      Re_Xferred = Re_Xferred + 1
    END DO
    OutData%PropagationDir = ReKiBuf(Re_Xferred)
    Re_Xferred = Re_Xferred + 1
    OutData%VFlowAngle = ReKiBuf(Re_Xferred)
    Re_Xferred = Re_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_UnPackInitOutput

 SUBROUTINE IfW_BladedFFWind_CopyMisc( SrcMiscData, DstMiscData, CtrlCode, ErrStat, ErrMsg )
   TYPE(IfW_BladedFFWind_MiscVarType), INTENT(IN) :: SrcMiscData
   TYPE(IfW_BladedFFWind_MiscVarType), INTENT(INOUT) :: DstMiscData
   INTEGER(IntKi),  INTENT(IN   ) :: CtrlCode
   INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
   CHARACTER(*),    INTENT(  OUT) :: ErrMsg
! Local 
   INTEGER(IntKi)                 :: i,j,k
   INTEGER(IntKi)                 :: ErrStat2
   CHARACTER(ErrMsgLen)           :: ErrMsg2
   CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_CopyMisc'
! 
   ErrStat = ErrID_None
   ErrMsg  = ""
    DstMiscData%dummy = SrcMiscData%dummy
 END SUBROUTINE IfW_BladedFFWind_CopyMisc

 SUBROUTINE IfW_BladedFFWind_DestroyMisc( MiscData, ErrStat, ErrMsg )
  TYPE(IfW_BladedFFWind_MiscVarType), INTENT(INOUT) :: MiscData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
  CHARACTER(*),    PARAMETER :: RoutineName = 'IfW_BladedFFWind_DestroyMisc'
  INTEGER(IntKi)                 :: i, i1, i2, i3, i4, i5 
! 
  ErrStat = ErrID_None
  ErrMsg  = ""
 END SUBROUTINE IfW_BladedFFWind_DestroyMisc

 SUBROUTINE IfW_BladedFFWind_PackMisc( ReKiBuf, DbKiBuf, IntKiBuf, Indata, ErrStat, ErrMsg, SizeOnly )
  REAL(ReKi),       ALLOCATABLE, INTENT(  OUT) :: ReKiBuf(:)
  REAL(DbKi),       ALLOCATABLE, INTENT(  OUT) :: DbKiBuf(:)
  INTEGER(IntKi),   ALLOCATABLE, INTENT(  OUT) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_MiscVarType),  INTENT(IN) :: InData
  INTEGER(IntKi),   INTENT(  OUT) :: ErrStat
  CHARACTER(*),     INTENT(  OUT) :: ErrMsg
  LOGICAL,OPTIONAL, INTENT(IN   ) :: SizeOnly
    ! Local variables
  INTEGER(IntKi)                 :: Re_BufSz
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_BufSz
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_BufSz
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i,i1,i2,i3,i4,i5
  LOGICAL                        :: OnlySize ! if present and true, do not pack, just allocate buffers
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_PackMisc'
 ! buffers to store subtypes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)

  OnlySize = .FALSE.
  IF ( PRESENT(SizeOnly) ) THEN
    OnlySize = SizeOnly
  ENDIF
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_BufSz  = 0
  Db_BufSz  = 0
  Int_BufSz  = 0
      Int_BufSz  = Int_BufSz  + 1  ! dummy
  IF ( Re_BufSz  .GT. 0 ) THEN 
     ALLOCATE( ReKiBuf(  Re_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating ReKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Db_BufSz  .GT. 0 ) THEN 
     ALLOCATE( DbKiBuf(  Db_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating DbKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Int_BufSz  .GT. 0 ) THEN 
     ALLOCATE( IntKiBuf(  Int_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating IntKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF(OnlySize) RETURN ! return early if only trying to allocate buffers (not pack them)

  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred = 1

    IntKiBuf(Int_Xferred) = InData%dummy
    Int_Xferred = Int_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_PackMisc

 SUBROUTINE IfW_BladedFFWind_UnPackMisc( ReKiBuf, DbKiBuf, IntKiBuf, Outdata, ErrStat, ErrMsg )
  REAL(ReKi),      ALLOCATABLE, INTENT(IN   ) :: ReKiBuf(:)
  REAL(DbKi),      ALLOCATABLE, INTENT(IN   ) :: DbKiBuf(:)
  INTEGER(IntKi),  ALLOCATABLE, INTENT(IN   ) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_MiscVarType), INTENT(INOUT) :: OutData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
    ! Local variables
  INTEGER(IntKi)                 :: Buf_size
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_UnPackMisc'
 ! buffers to store meshes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred  = 1
    OutData%dummy = IntKiBuf(Int_Xferred)
    Int_Xferred = Int_Xferred + 1
 END SUBROUTINE IfW_BladedFFWind_UnPackMisc

 SUBROUTINE IfW_BladedFFWind_CopyParam( SrcParamData, DstParamData, CtrlCode, ErrStat, ErrMsg )
   TYPE(IfW_BladedFFWind_ParameterType), INTENT(IN) :: SrcParamData
   TYPE(IfW_BladedFFWind_ParameterType), INTENT(INOUT) :: DstParamData
   INTEGER(IntKi),  INTENT(IN   ) :: CtrlCode
   INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
   CHARACTER(*),    INTENT(  OUT) :: ErrMsg
! Local 
   INTEGER(IntKi)                 :: i,j,k
   INTEGER(IntKi)                 :: ErrStat2
   CHARACTER(ErrMsgLen)           :: ErrMsg2
   CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_CopyParam'
! 
   ErrStat = ErrID_None
   ErrMsg  = ""
      CALL IfW_FFWind_CopyParam( SrcParamData%FF, DstParamData%FF, CtrlCode, ErrStat2, ErrMsg2 )
         CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg,RoutineName)
         IF (ErrStat>=AbortErrLev) RETURN
 END SUBROUTINE IfW_BladedFFWind_CopyParam

 SUBROUTINE IfW_BladedFFWind_DestroyParam( ParamData, ErrStat, ErrMsg )
  TYPE(IfW_BladedFFWind_ParameterType), INTENT(INOUT) :: ParamData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
  CHARACTER(*),    PARAMETER :: RoutineName = 'IfW_BladedFFWind_DestroyParam'
  INTEGER(IntKi)                 :: i, i1, i2, i3, i4, i5 
! 
  ErrStat = ErrID_None
  ErrMsg  = ""
  CALL IfW_FFWind_DestroyParam( ParamData%FF, ErrStat, ErrMsg )
 END SUBROUTINE IfW_BladedFFWind_DestroyParam

 SUBROUTINE IfW_BladedFFWind_PackParam( ReKiBuf, DbKiBuf, IntKiBuf, Indata, ErrStat, ErrMsg, SizeOnly )
  REAL(ReKi),       ALLOCATABLE, INTENT(  OUT) :: ReKiBuf(:)
  REAL(DbKi),       ALLOCATABLE, INTENT(  OUT) :: DbKiBuf(:)
  INTEGER(IntKi),   ALLOCATABLE, INTENT(  OUT) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_ParameterType),  INTENT(IN) :: InData
  INTEGER(IntKi),   INTENT(  OUT) :: ErrStat
  CHARACTER(*),     INTENT(  OUT) :: ErrMsg
  LOGICAL,OPTIONAL, INTENT(IN   ) :: SizeOnly
    ! Local variables
  INTEGER(IntKi)                 :: Re_BufSz
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_BufSz
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_BufSz
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i,i1,i2,i3,i4,i5
  LOGICAL                        :: OnlySize ! if present and true, do not pack, just allocate buffers
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_PackParam'
 ! buffers to store subtypes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)

  OnlySize = .FALSE.
  IF ( PRESENT(SizeOnly) ) THEN
    OnlySize = SizeOnly
  ENDIF
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_BufSz  = 0
  Db_BufSz  = 0
  Int_BufSz  = 0
   ! Allocate buffers for subtypes, if any (we'll get sizes from these) 
      Int_BufSz   = Int_BufSz + 3  ! FF: size of buffers for each call to pack subtype
      CALL IfW_FFWind_PackParam( Re_Buf, Db_Buf, Int_Buf, InData%FF, ErrStat2, ErrMsg2, .TRUE. ) ! FF 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf)) THEN ! FF
         Re_BufSz  = Re_BufSz  + SIZE( Re_Buf  )
         DEALLOCATE(Re_Buf)
      END IF
      IF(ALLOCATED(Db_Buf)) THEN ! FF
         Db_BufSz  = Db_BufSz  + SIZE( Db_Buf  )
         DEALLOCATE(Db_Buf)
      END IF
      IF(ALLOCATED(Int_Buf)) THEN ! FF
         Int_BufSz = Int_BufSz + SIZE( Int_Buf )
         DEALLOCATE(Int_Buf)
      END IF
  IF ( Re_BufSz  .GT. 0 ) THEN 
     ALLOCATE( ReKiBuf(  Re_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating ReKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Db_BufSz  .GT. 0 ) THEN 
     ALLOCATE( DbKiBuf(  Db_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating DbKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF ( Int_BufSz  .GT. 0 ) THEN 
     ALLOCATE( IntKiBuf(  Int_BufSz  ), STAT=ErrStat2 )
     IF (ErrStat2 /= 0) THEN 
       CALL SetErrStat(ErrID_Fatal, 'Error allocating IntKiBuf.', ErrStat, ErrMsg,RoutineName)
       RETURN
     END IF
  END IF
  IF(OnlySize) RETURN ! return early if only trying to allocate buffers (not pack them)

  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred = 1

      CALL IfW_FFWind_PackParam( Re_Buf, Db_Buf, Int_Buf, InData%FF, ErrStat2, ErrMsg2, OnlySize ) ! FF 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Re_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Re_Buf) > 0) ReKiBuf( Re_Xferred:Re_Xferred+SIZE(Re_Buf)-1 ) = Re_Buf
        Re_Xferred = Re_Xferred + SIZE(Re_Buf)
        DEALLOCATE(Re_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
      IF(ALLOCATED(Db_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Db_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Db_Buf) > 0) DbKiBuf( Db_Xferred:Db_Xferred+SIZE(Db_Buf)-1 ) = Db_Buf
        Db_Xferred = Db_Xferred + SIZE(Db_Buf)
        DEALLOCATE(Db_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
      IF(ALLOCATED(Int_Buf)) THEN
        IntKiBuf( Int_Xferred ) = SIZE(Int_Buf); Int_Xferred = Int_Xferred + 1
        IF (SIZE(Int_Buf) > 0) IntKiBuf( Int_Xferred:Int_Xferred+SIZE(Int_Buf)-1 ) = Int_Buf
        Int_Xferred = Int_Xferred + SIZE(Int_Buf)
        DEALLOCATE(Int_Buf)
      ELSE
        IntKiBuf( Int_Xferred ) = 0; Int_Xferred = Int_Xferred + 1
      ENDIF
 END SUBROUTINE IfW_BladedFFWind_PackParam

 SUBROUTINE IfW_BladedFFWind_UnPackParam( ReKiBuf, DbKiBuf, IntKiBuf, Outdata, ErrStat, ErrMsg )
  REAL(ReKi),      ALLOCATABLE, INTENT(IN   ) :: ReKiBuf(:)
  REAL(DbKi),      ALLOCATABLE, INTENT(IN   ) :: DbKiBuf(:)
  INTEGER(IntKi),  ALLOCATABLE, INTENT(IN   ) :: IntKiBuf(:)
  TYPE(IfW_BladedFFWind_ParameterType), INTENT(INOUT) :: OutData
  INTEGER(IntKi),  INTENT(  OUT) :: ErrStat
  CHARACTER(*),    INTENT(  OUT) :: ErrMsg
    ! Local variables
  INTEGER(IntKi)                 :: Buf_size
  INTEGER(IntKi)                 :: Re_Xferred
  INTEGER(IntKi)                 :: Db_Xferred
  INTEGER(IntKi)                 :: Int_Xferred
  INTEGER(IntKi)                 :: i
  INTEGER(IntKi)                 :: ErrStat2
  CHARACTER(ErrMsgLen)           :: ErrMsg2
  CHARACTER(*), PARAMETER        :: RoutineName = 'IfW_BladedFFWind_UnPackParam'
 ! buffers to store meshes, if any
  REAL(ReKi),      ALLOCATABLE   :: Re_Buf(:)
  REAL(DbKi),      ALLOCATABLE   :: Db_Buf(:)
  INTEGER(IntKi),  ALLOCATABLE   :: Int_Buf(:)
    !
  ErrStat = ErrID_None
  ErrMsg  = ""
  Re_Xferred  = 1
  Db_Xferred  = 1
  Int_Xferred  = 1
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Re_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Re_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Re_Buf = ReKiBuf( Re_Xferred:Re_Xferred+Buf_size-1 )
        Re_Xferred = Re_Xferred + Buf_size
      END IF
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Db_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Db_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Db_Buf = DbKiBuf( Db_Xferred:Db_Xferred+Buf_size-1 )
        Db_Xferred = Db_Xferred + Buf_size
      END IF
      Buf_size=IntKiBuf( Int_Xferred )
      Int_Xferred = Int_Xferred + 1
      IF(Buf_size > 0) THEN
        ALLOCATE(Int_Buf(Buf_size),STAT=ErrStat2)
        IF (ErrStat2 /= 0) THEN 
           CALL SetErrStat(ErrID_Fatal, 'Error allocating Int_Buf.', ErrStat, ErrMsg,RoutineName)
           RETURN
        END IF
        Int_Buf = IntKiBuf( Int_Xferred:Int_Xferred+Buf_size-1 )
        Int_Xferred = Int_Xferred + Buf_size
      END IF
      CALL IfW_FFWind_UnpackParam( Re_Buf, Db_Buf, Int_Buf, OutData%FF, ErrStat2, ErrMsg2 ) ! FF 
        CALL SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, RoutineName)
        IF (ErrStat >= AbortErrLev) RETURN

      IF(ALLOCATED(Re_Buf )) DEALLOCATE(Re_Buf )
      IF(ALLOCATED(Db_Buf )) DEALLOCATE(Db_Buf )
      IF(ALLOCATED(Int_Buf)) DEALLOCATE(Int_Buf)
 END SUBROUTINE IfW_BladedFFWind_UnPackParam

END MODULE IfW_BladedFFWind_Types
!ENDOFREGISTRYGENERATEDFILE
