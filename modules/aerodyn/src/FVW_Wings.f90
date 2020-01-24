module FVW_Wings 

   use NWTC_Library
   use FVW_Types
   use FVW_Subs
   use AirFoilInfo,   only : AFI_ComputeAirfoilCoefs
 
   implicit none

contains

   !----------------------------------------------------------------------------------------------------------------------------------
   !> Based on an input mesh, sets the following:
   !!  - s_LL       : Dimensionless spanwise coordinate of LL    
   !!  - s_CP_LL    : Dimensionless spanwise coordinate of LL CP 
   !!  - chord_LL   : chord on LL 
   !!  - chord_LL_CP: chord on LL cp  
   subroutine Wings_Panelling_Init(Meshes, r, p, m, ErrStat, ErrMsg )
      type(MeshType), dimension(:),    intent(in   )  :: Meshes         !< Wings mesh
      real(ReKi), dimension(:,:),      intent(in   )  :: r              !< 
      type(FVW_ParameterType),         intent(in   )  :: p              !< Parameters
      type(FVW_MiscVarType),           intent(inout)  :: m              !< Initial misc/optimization variables
      integer(IntKi),                  intent(  out)  :: ErrStat        !< Error status of the operation
      character(*),                    intent(  out)  :: ErrMsg         !< Error message if ErrStat /= ErrID_None
      ! Local
      integer(IntKi)          :: ErrStat2       ! temporary error status of the operation
      character(ErrMsgLen)    :: ErrMsg2        ! temporary error message
      integer(IntKi) :: iW, iSpan
      real(ReKi), dimension(3) :: First, Last, P1, P2, Pmid, DP
      real(ReKi) :: ds, length
      real(ReKi) :: c1,c2
      real(ReKi), dimension(:),allocatable :: s_in !< Dimensionless spanwise coordinate of input

      ! Initialize ErrStat
      ErrStat = ErrID_None
      ErrMsg  = ""

      ! --- Meshing
      do iW = 1,p%nWings
         if (allocated(s_in)) deallocate(s_in)
         allocate(s_in(1:Meshes(iW)%nNodes))
         ! --- Computing spanwise coordinate of input mesh normalized from 0 to 1
!FIXME: does this work for a highly curved blade?
!also note: this info also exists in InitInp%zLocal or InitInp%rLocal
         s_in(:) = -999
         First  = Meshes(iW)%Position(1:3,1        )
         Last   = Meshes(iW)%Position(1:3,p%nSpan+1)
         DP     = Last - First
         length = TwoNorm(DP)
         do iSpan = 1, Meshes(iW)%nNodes
            P1          = Meshes(iW)%Position(1:3, iSpan  )
            DP          = P1-First
            s_in(iSpan) = TwoNorm(DP) / length
         enddo

         ! --- Setting up Lifting line variables based on input  and a "meshing" method (TODO)
         if (Meshes(iW)%nNodes /= p%nSpan+1) then
            ! TODO Possibly interpolate based on FVW meshing
            ! NOTE: p%chord is copied from the InitInput
            print*,'TODO different discretization InputMesh / vortex code'
            STOP
         endif
         print*,'Input mesh size',Meshes(iW)%nNodes,' Number of vortex element', p%nSpan
         do iSpan = 1, p%nSpan+1
            m%s_LL    (iSpan, iW) = s_in(iSpan)
            m%chord_LL(iSpan, iW) = p%chord(iSpan,iW)
         enddo
         ! --- Control points
!TODO: does it make sense to keep the global position info here?  It might make it simpler to keep track of the nodes for requesting wind velocity info.
         ! TODO possibly Control points are not exactly at the middle depending on "meshing" method
         do iSpan = 1, p%nSpan
            m%s_CP_LL    (iSpan, iW) = (m%s_LL    (iSpan,iW)+ m%s_LL    (iSpan+1,iW))/2
            m%chord_CP_LL(iSpan, iW) = (m%chord_LL(iSpan,iW)+ m%chord_LL(iSpan+1,iW))/2
         enddo
      enddo
   end subroutine Wings_Panelling_Init

   !----------------------------------------------------------------------------------------------------------------------------------
   !> Based on an input mesh, sets the following:
   !!  - LE      : Leading edge points                 (3 x nSpan+1 x nWings)
   !!  - TE      : Trailing edge points                (3 x nSpan+1 x nWings)
   !!  - CP_LL   : Coordinates of LL CP"              (3 x nSpan x nWings)
   !!  - Tang    : Unit Tangential vector on LL CP" -
   !!  - Norm    : Unit Normal vector on LL CP    " -
   !!  - Orth    : Unit Orthogonal vector on LL CP" -
   !!  - Vstr_LL : Structural velocity on LL CP" m/s
   subroutine Wings_Panelling(Meshes, p, m, ErrStat, ErrMsg )
      type(MeshType), dimension(:),    intent(in   )  :: Meshes         !< Wings mesh
      type(FVW_ParameterType),         intent(in   )  :: p              !< Parameters
      type(FVW_MiscVarType),           intent(inout)  :: m              !< Initial misc/optimization variables
      integer(IntKi),                  intent(  out)  :: ErrStat        !< Error status of the operation
      character(*),                    intent(  out)  :: ErrMsg         !< Error message if ErrStat /= ErrID_None
      ! Local
      integer(IntKi)          :: ErrStat2       ! temporary error status of the operation
      character(ErrMsgLen)    :: ErrMsg2        ! temporary error message
      integer(IntKi) ::iSpan , iW
      real(ReKi), dimension(3) :: P_ref         ! Reference point of Input Mesh (e.g. AeroDynamic Center?)
      real(ReKi), dimension(3) :: DP_LE ! Distance between reference point and Leading edge
      real(ReKi), dimension(3) :: DP_TE ! Distance between reference point and trailing edge
      real(ReKi), dimension(3) :: P1,P2,P3,P4,P5,P7,P8,P6,P9,P10
      real(ReKi), dimension(3) :: DP1, DP2, DP3
      !real(ReKi), dimension(3,3) :: MRot
      ! Initialize ErrStat
      ErrStat = ErrID_None
      ErrMsg  = ""
      ! --- Position of leading edge and trailing edge
      ! TODO, this assumes one to one between InputMesh and FVW Mesh
      !
      do iW = 1,p%nWings
         do iSpan = 1,p%nSpan+1
            P_ref = Meshes(iW)%Position(1:3, iSpan )+Meshes(iW)%TranslationDisp(1:3, iSpan)
            if (p%HACK==1) then
               P_ref(3)=100
               P_ref(1)=0
            endif
            DP_LE(1:3) =  0.0
            DP_LE(1)   = -m%chord_LL(iSpan,iW)/4.  ! TODO TODO TODO Use orientation and might not be c/2
            DP_TE(1:3) =  0.0
            DP_TE(1)   = +3.*m%chord_LL(iSpan,iW)/4. ! TODO TODO TODO Use orientation and might not be c/2
            !MRot=Meshes(iW)%Orientation(1:3,1:3,iSpan) ! NOTE: this wont work
            !DP_LE = matmul(MRot,DP_LE)
            !DP_TE = matmul(MRot,DP_TE)
            m%LE(1:3, iSpan, iW) = P_ref + DP_LE(1)*Meshes(iW)%Orientation(2,1:3,iSpan)
            m%TE(1:3, iSpan, iW) = P_ref + DP_TE(1)*Meshes(iW)%Orientation(2,1:3,iSpan)
         enddo         
      enddo
      ! --- Generic code below to compute normal/tangential vectors of a lifting line panel
      ! Notations follow vanGarrel [TODO REF]
      do iW = 1,p%nWings
         do iSpan = 1,p%nSpan
            P1                    = m%LE(:,iSpan  , iw)
            P4                    = m%LE(:,iSpan+1, iw)
            P3                    = m%TE(:,iSpan+1, iw)
            P2                    = m%TE(:,iSpan  , iw)
            P8                    = (P1+P4)/2
            P6                    = (P2+P3)/2
            P5                    = (P1+P2)/2
            P7                    = (P4+P3)/2
            P9                    = 0.75_ReKi*P1+0.25_ReKi*P2
            P10                   = 0.75_ReKi*P4+0.25_ReKi*P3
            DP1                   = P6-P8
            DP2                   = P10-P9
            DP3                   = P7-P5
            m%Norm(1:3,iSpan,iW)  = cross_product(DP1,DP2)
            m%Norm(1:3,iSpan,iW)  = m%Norm(1:3,iSpan,iW)/norm2(m%Norm(1:3,iSpan,iW))
            m%Tang(1:3,iSpan,iW)  = (DP1)/norm2(DP1)                       ! tangential unit vector, along chord
            ! m%Tscoord(1:3,iSpan) = (DP3)/norm2(DP3)                      ! tangential unit vector, along span, follows ref line
            m%dl  (1:3,iSpan,iW)  = DP2
            m%Orth(1:3,iSpan,iW)  = cross_product(m%Norm(1:3,iSpan,iW),m%Tang(1:3,iSpan,iW)) ! orthogonal vector to N and T
            m%Area(iSpan, iW) = norm2(cross_product(DP1,DP3));
         end do
      enddo
!FIXME: does it make sense to use the position mesh for this info?
      ! --- Lifting Line/ Bound Circulation panel
      ! For now: goes from 1/4 chord to TE
      ! More panelling options may be considered in the future
      do iW = 1,p%nWings
         do iSpan = 1,p%nSpan+1
            m%r_LL(1:3,iSpan,1,iW)= m%TE(1:3,iSpan,iW)*0.25_ReKi+m%LE(1:3,iSpan,iW)*0.75_ReKi  ! 1/4 chord
            m%r_LL(1:3,iSpan,2,iW)= m%TE(1:3,iSpan,iW)                                         ! TE
         enddo
      enddo

      ! --- Position of control points CP_LL
      ! For now: placed exactly on the LL panel
      ! NOTE: separated from other loops just in case a special discretization is used
      do iW = 1,p%nWings
         call InterpArray(m%s_LL(:,iW), m%r_LL(1,:,1,iW), m%s_CP_LL(:,iW), m%CP_LL(1,:,iW))
         call InterpArray(m%s_LL(:,iW), m%r_LL(2,:,1,iW), m%s_CP_LL(:,iW), m%CP_LL(2,:,iW))
         call InterpArray(m%s_LL(:,iW), m%r_LL(3,:,1,iW), m%s_CP_LL(:,iW), m%CP_LL(3,:,iW))
      enddo

      ! --- Structural velocity on LL
      ! TODO: difference meshes in/LL
      do iW = 1,p%nWings
         call InterpArray(m%s_LL(:,iW), Meshes(iW)%TranslationVel(1,:) ,m%s_CP_LL(:,iW), m%Vstr_LL(1,:,iW))
         call InterpArray(m%s_LL(:,iW), Meshes(iW)%TranslationVel(2,:) ,m%s_CP_LL(:,iW), m%Vstr_LL(2,:,iW))
         call InterpArray(m%s_LL(:,iW), Meshes(iW)%TranslationVel(3,:) ,m%s_CP_LL(:,iW), m%Vstr_LL(3,:,iW))
      enddo

   end subroutine Wings_Panelling

!       print*,'  Norm Tang '
!       print*, m%Norm(1:3,5,1)
!       print*, m%Tang(1:3,5,1)
!       print*,'       '
!       print*,'LE1',m%LE(1,:,1)
!       print*,'LE2',m%LE(2,:,1)
!       print*,'LE3',m%LE(3,:,1)
!       print*,''
!       print*,'TE1',m%LE(1,:,1)
!       print*,'TE2',m%LE(2,:,1)
!       print*,'TE3',m%LE(3,:,1)
!       print*,''
!       print*,'CP1',m%CP_LL(1,:,1)
!       print*,'CP2',m%CP_LL(2,:,1)
!       print*,'CP3',m%CP_LL(3,:,1)
! 


   !----------------------------------------------------------------------------------------------------------------------------------
   !>
   subroutine Wings_ComputeCirculation(t, Gamma_LL, Gamma_LL_prev, u, p, x, m, AFInfo, ErrStat, ErrMsg, iLabel)
      real(DbKi),                      intent(in   )  :: t           !< Current simulation time in seconds
      real(ReKi), dimension(:,:),      intent(inout)  :: Gamma_LL       !< Circulation on all the lifting lines
      real(ReKi), dimension(:,:),      intent(in   )  :: Gamma_LL_prev  !< Previous/Guessed circulation
      type(FVW_InputType),             intent(in   )  :: u              !< Parameters
      type(FVW_ParameterType),         intent(in   )  :: p              !< Parameters
      type(FVW_ContinuousStateType),   intent(in   )  :: x              !< Parameters
      type(FVW_MiscVarType),           intent(inout)  :: m              !< Initial misc/optimization variables
      type(AFI_ParameterType),         intent(in   )  :: AFInfo(:)      !< The airfoil parameter data
      integer(IntKi),                  intent(  out)  :: ErrStat        !< Error status of the operation
      character(*),                    intent(  out)  :: ErrMsg         !< Error message if ErrStat /= ErrID_None
      integer(IntKi), intent(in) :: iLabel
      ! Local
      integer(IntKi) :: iW
      ! Initialize ErrStat
      ErrStat = ErrID_None
      ErrMsg  = ""

!FIXME: Gamma_LL is currently stored as a constraint state.  This routine is called from places where constraint states are considered intent(in) only.
      if (p%CirculationMethod==idCircPrescribed) then 
         !print*,'>>>Prescribing circulation'
         do iW = 1, p%nWings !Loop over lifting lines
            Gamma_LL(1:p%nSpan,iW) = p%PrescribedCirculation(1:p%nSpan)
         enddo

      else if (p%CirculationMethod==idCircPolarData) then 
         ! ---  Solve for circulation using polar data
         !print*,'>>>>>>>>>>>>>>>>> Circulation solving with polar data >>>>>>>>>>>>>> CALL  ',iLabel
         CALL Wings_ComputeCirculationPolarData(t, Gamma_LL, Gamma_LL_prev, u, p, x, m, AFInfo, ErrStat, ErrMsg, iLabel)

      else if (p%CirculationMethod==idCircNoFlowThrough) then 
         ! ---  Solve for circulation using the no-flow through condition
         ! TODO
         print*,'Circulation method nor implemented', p%CirculationMethod
         STOP
      else
         print*,'Circulation method nor implemented', p%CirculationMethod ! Will never happen
         STOP
      endif

      if (t<p%FullCirculationStart) then
         ! The circulation is ramped up progressively, starting from 0 
         ! TODO use a smooth approximation of HeavySide function instead of linear
         print*,'Slow start'
         Gamma_LL = (t/p%FullCirculationStart)*Gamma_LL
      endif

   endsubroutine Wings_ComputeCirculation

   !----------------------------------------------------------------------------------------------------------------------------------
   !>
   subroutine Wings_ComputeCirculationPolarData(t, Gamma_LL, Gamma_LL_prev, u, p, x, m, AFInfo, ErrStat, ErrMsg, iLabel)
      real(DbKi),                      intent(in   )  :: t           !< Current simulation time in seconds
      real(ReKi), dimension(:,:),      intent(inout)  :: Gamma_LL       !< Circulation on all the lifting lines
      real(ReKi), dimension(:,:),      intent(in   )  :: Gamma_LL_prev  !< Previous/Guessed circulation
      type(FVW_InputType),             intent(in   )  :: u              !< Parameters
      type(FVW_ParameterType),         intent(in   )  :: p              !< Parameters
      type(FVW_ContinuousStateType),   intent(in   )  :: x              !< Parameters
      type(FVW_MiscVarType),           intent(inout)  :: m              !< Initial misc/optimization variables
      type(AFI_ParameterType),         intent(in   )  :: AFInfo(:)      !< The airfoil parameter data
      integer(IntKi),                  intent(  out)  :: ErrStat        !< Error status of the operation
      character(*),                    intent(  out)  :: ErrMsg         !< Error message if ErrStat /= ErrID_None
      integer(IntKi), intent(in) :: iLabel
      ! Local
      real(ReKi), dimension(:,:), allocatable :: DGamma        !< 
      real(ReKi), dimension(:,:), allocatable :: GammaLastIter !< 
      logical                                 :: bConverged    !< 
      integer(IntKi)                          :: iIter         !< iteration step number
      real(ReKi)                              :: MeanGamma
      real(ReKi), dimension(:,:,:), allocatable :: Vcst !< Part of the velocity that is constant 
      real(ReKi), dimension(:,:,:), allocatable :: Vvar !< Part of the velocity that is varies due to the solve
      integer(IntKi) :: iW, iSpan, iDepth, iWCP, nCPs
      real(ReKi), dimension(3) :: P1, P2, P3, P4
      real(ReKi) :: Gamm
      ! Error handling
      integer(IntKi)           :: ErrStat2
      character(ErrMsgLen)     :: ErrMsg2

      ! Initialize ErrStat
      ErrStat = ErrID_None
      ErrMsg  = ""

      !print*,'Parameters for circulation solv: ',p%CircSolvConvCrit ,p%CircSolvRelaxation ,p%CircSolvMaxIter   

      allocate(DGamma       (1:p%nSpan,1:p%nWings))
      allocate(GammaLastIter(1:p%nSpan,1:p%nWings))

      ! --- Last iteration circulation
      if (m%FirstCall) then
         ! We find a guess by looking simply at the Wind and Elasticity velocity
         m%Vtot_ll = m%Vwnd_LL - m%Vstr_ll
         call CirculationFromPolarData(GammaLastIter, p, m, AFInfo,ErrStat2,ErrMsg2);  if(Failed()) return;
      else
         GammaLastIter(1:p%nSpan,1:p%nWings) = Gamma_LL_prev(1:p%nSpan,1:p%nWings)
      endif

      if (any(x%r_NW(1,:,1:m%nNW+1,:)<-999)) then
         print*,'Wings_ComputeCirculationPolarData: Problem in input NW points'
         STOP
      endif


      ! --- Setting up Vcst: part of the velocity that is constant withing the iteration loop
      !   Vrel_ll_cst = U_u0 - U_body 
      call AllocAry(Vvar,  3, p%nSpan, p%nWings, 'Vvar',  ErrStat2, ErrMsg2);  if(Failed()) return;
      call AllocAry(Vcst,  3, p%nSpan, p%nWings, 'Vcst',  ErrStat2, ErrMsg2);  if(Failed()) return;

      ! Set m%Vind_LL Induced velocity from Known wake only (after iNWStart+1)
      call LiftingLineInducedVelocities(p, x, iNWStart+1, m, ErrStat2, ErrMsg2);  if(Failed()) return;

      Vcst = m%Vind_LL + m%Vwnd_LL - m%Vstr_ll

      if (any(m%Vind_LL(1:3,:,:)<-99)) then
         print*,'Wings_ComputeCirculationPolarData: Problem in induced velocity on LL points'
         STOP
      endif
      if (any(m%Vwnd_LL(1:3,:,:)<-99)) then
         print*,'Wings_ComputeCirculationPolarData: Problem in wind velocity on LL points'
         STOP
      endif

      ! --- Convergence loop until near wake gives induction coherent with circulation
      bConverged=.false.
      iIter=0
      do while (.not.(bConverged) .and. iIter<p%CircSolvMaxIter) 
          !print*,'------- ITERATION',iIter
          !print*,'Gamm: ',GammaLastIter(1:3, 1)
          ! --- The induced velocity from the profiles is different at each iteration:
          Vvar=0 
          nCPs=p%nSpan
          do iW=1,p%nWings
             do iSpan=1,p%nSpan
                do iDepth=1,iNWStart ! Two first panels
                   P1=x%r_NW(1:3,iSpan  ,iDepth  ,iW)
                   P2=x%r_NW(1:3,iSpan+1,iDepth  ,iW)
                   P3=x%r_NW(1:3,iSpan+1,iDepth+1,iW)
                   P4=x%r_NW(1:3,iSpan  ,iDepth+1,iW)
                   Gamm=GammaLastIter(iSpan, iW)
                   do iWCP=1,p%nWings
                      call ui_quad_n1(m%CP_LL(1:3,1:p%nSpan,iWCP), nCPs, P1, P2, P3, P4, Gamm, p%RegFunction, p%WakeRegFactor, Vvar(1:3,1:p%nSpan,iWCP))
                   enddo
                enddo
             enddo
          enddo
          ! Total velocity on the lifting line
          m%Vtot_ll = Vcst + Vvar
          !call print_mean_3d( Vvar(:,:,:), 'Mean induced vel. LL (var)')
          !call print_mean_3d( m%Vtot_LL(:,:,:), 'Mean relativevel. LL (tot)')
          ! --- Computing circulation based on Vtot_LL
          call CirculationFromPolarData(Gamma_LL, p, m, AFInfo,ErrStat2,ErrMsg2);  if(Failed()) return;

          ! --------------------------------------------- 
          ! Differences between iterations and relaxation
          DGamma=Gamma_LL-GammaLastIter 
          GammaLastIter=GammaLastIter+p%CircSolvRelaxation*DGamma
          !print*,'DGamm:',DGamma(1:3, 1)

          iIter=iIter+1
          MeanGamma  = sum(abs(GammaLastIter))/(p%nWings*p%nSpan)
          !print*,'Crit',maxval(abs(DGamma))/(MeanGamma)
          bConverged = maxval(abs(DGamma))/(MeanGamma)<p%CircSolvConvCrit

      end do ! convergence loop
      if (iIter==p%CircSolvMaxIter) then
         print*,'Maximum number of iterations reached: ',iIter
         Gamma_LL=GammaLastIter ! returning relaxed value if not converged
      else
         print'(A,I0,A,I0)','Circulation solve, call ',iLabel,', done after ........................ nIter: ', iIter
         ! We return Gamma_LL
      endif

      ! KEEP ME:
      !iW=1
      !call Output_Gamma(m%CP_ll(1:3,:,iW), Gamma_LL(:,iW), iW, m%iStep, iLabel, iIter)

      !call print_mean_3d( m%Vwnd_LL(:,:,:), 'Mean wind    vel. LL (cst)')
      !call print_mean_3d( m%Vstr_LL(:,:,:), 'Mean struct  vel. LL (cst)')
      !call print_mean_3d( m%Vind_LL(:,:,:), 'Mean induced vel. LL (cst)')
      !call print_mean_3d( Vvar(:,:,:)     , 'Mean induced vel. LL (var)')
      call print_mean_3d( Vvar+m%Vind_LL(:,:,:), 'Mean induced vel. LL (tot)')
      call print_mean_3d( m%Vtot_LL(:,:,:), 'Mean relativevel. LL (tot)')
      !print*,'m%Vind_LL',m%Vind_LL(1,:,:)
      !print*,'m%Vwnd_LL',m%Vwnd_LL(1,:,:)
      !print*,'m%Vcst_LL',Vcst(1,:,:)
      m%Vind_LL=-9999._ReKi !< Safety (the induction above was not the true one)
      m%Vtot_LL=-9999._ReKi !< Safety 
      !print*,'Gamm: ',Gamma_LL(1, 1), Gamma_LL(p%nSpan,1)
      !if (abs(Gamma_LL(1, 1)-Gamma_LL(p%nSpan,1))>0.01)  STOP
      !if (m%iStep==3) STOP
      call CleanUp()
   contains

      logical function Failed()
         call SetErrStat(ErrStat2, ErrMsg2, ErrStat, ErrMsg, 'Wings_ComputeCirculationPolarData')
         Failed =  ErrStat >= AbortErrLev
         if (Failed) call CleanUp()
      end function Failed
      subroutine CleanUp()
         if(allocated(DGamma       ))       deallocate(DGamma       )
         if(allocated(GammaLastIter))       deallocate(GammaLastIter)
         if(allocated(Vcst))                deallocate(Vcst)
         if(allocated(Vvar))                deallocate(Vvar)
      end subroutine
   end subroutine Wings_ComputeCirculationPolarData


   !>  Compute circulation based on polar data
   !! Uses m%Vtot_ll to compute Gamma_ll
   subroutine CirculationFromPolarData(Gamma_LL, p, m, AFInfo, ErrStat, ErrMsg)
      real(ReKi), dimension(:,:),      intent(inout)  :: Gamma_LL       !< Circulation on all the lifting lines
      type(FVW_ParameterType),         intent(in   )  :: p              !< Parameters
      type(FVW_MiscVarType),           intent(in   )  :: m              !< Initial misc/optimization variables
      type(AFI_ParameterType),         intent(in   )  :: AFInfo(:)      !< The airfoil parameter data
      integer(IntKi),                  intent(  out)  :: ErrStat        !< Error status of the operation
      character(*),                    intent(  out)  :: ErrMsg         !< Error message if ErrStat /= ErrID_None

      ! Local
      integer(IntKi) :: iW, iCP  !< Index on wings and spanwise control points
      real(ReKi), dimension(3) :: N, Tc      !<  Normal and Tangent vector
      real(ReKi), dimension(3) :: Vrel, Vrel_orth, Vjouk, Vjouk_orth
      real(ReKi)               :: Vrel_orth_norm, Vjouk_orth_norm
      real(ReKi)               :: alpha, Re, Cl, Cd, Cm
      type(AFI_OutputType)     :: AFI_interp
      integer(IntKi)           :: ErrStat2
      character(ErrMsgLen)     :: ErrMsg2

      ! Initialize ErrStat
      ErrStat = ErrID_None
      ErrMsg  = ""

      do iW=1,p%nWings 
         do icp=1,p%nSpan
            ! Aliases to shorten notations
            N    = m%Norm(1:3, icp, iW) 
            Tc   = m%Tang(1:3, icp, iW)
            Vrel = m%Vtot_LL(1:3,icp,iW)
            ! "Orth": cross sectional plane of the lifting line 
            Vrel_orth(1:3)  = dot_product(Vrel,N)*N + dot_product(Vrel,Tc)*Tc
            Vrel_orth_norm  = norm2(Vrel_orth(1:3))
            Vjouk(1:3)      = cross_product(Vrel,m%dl(1:3,icp,iW))
            Vjouk_orth(1:3) = dot_product(Vjouk,N)*N + dot_product(Vjouk,Tc)*Tc
            Vjouk_orth_norm = norm2(Vjouk_orth)

            alpha = atan2(dot_product(Vrel,N) , dot_product(Vrel,Tc) ) ! [rad]  
            Re = p%Chord(icp,iW) * norm2(Vrel) / p%KinVisc / 1.0E6

            if (p%CircSolvPolar==idPolarAeroDyn) then
                  ! compute steady Airfoil Coefs      ! NOTE: UserProp set to 0.0_ReKi (no idea what it does).  Also, note this assumes airfoils at nodes.
!TODO: AFindx is on the nodes, not control points.
               call AFI_ComputeAirfoilCoefs( alpha, Re, 0.0_ReKi,  AFInfo(p%AFindx(icp,iW)), AFI_interp, ErrStat2, ErrMsg2 ); if(Failed()) return;
               Cl = AFI_interp%Cl
               Cd = AFI_interp%Cd
               Cm = AFI_interp%Cm
            else if (p%CircSolvPolar==idPolar2PiAlpha) then
               Cl=TwoPi*alpha
            else if (p%CircSolvPolar==idPolar2PiSinAlpha) then
               Cl=TwoPi*sin(alpha)
            else
               print*,'Unknown CircSolvPolar value'
               STOP
            endif
            ! Simple method:
            !    Gamma_LL=(0.5 * Cl * Vrel_orth_norm*chord)
            ! VanGarrel's method:
            Gamma_LL(icp,iW) =(0.5_ReKi * Cl * Vrel_orth_norm**2*m%Area(icp,iW)/(Vjouk_orth_norm))
            !if ((iW==1).and.icp==3) then
            !   print*,'CL',Cl,alpha,Vrel_orth_norm,m%Area(icp,iW)
            !endif

         enddo
      enddo
   contains
      logical function Failed()
         character(25)              :: NodeText
         if (ErrStat2 /= ErrID_None) then
            NodeText = '(node '//trim(num2lstr(icp))//', blade '//trim(num2lstr(iW))//')'
            call SetErrStat(ErrStat2,ErrMsg2,ErrStat,ErrMsg,'CirculationFromPolarData'//trim(NodeText))
         end if
         Failed =  ErrStat >= AbortErrLev
      end function Failed
   end subroutine CirculationFromPolarData



end module FVW_Wings
