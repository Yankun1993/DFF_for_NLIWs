C $Header: /u/gcmpack/MITgcm/pkg/obcs/obcs_prescribe_read.F,v 1.30 2011/05/24 14:31:14 jmc Exp $
C $Name: checkpoint64e $

# include "OBCS_OPTIONS.h"

CBOP
C     !ROUTINE: OBCS_PRESCRIBE_READ
C     !INTERFACE:
      SUBROUTINE OBCS_PRESCRIBE_READ (
     I                          myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *============================================================*
C     | SUBROUTINE OBCS_PRESCRIBE_READ
C     *============================================================*
C     | read open boundary conditions from file                           
C     | N.B.: * uses exf and cal routines for file/record handling        
C     |       * uses ctrl routines for control variable handling          
C     *============================================================*
C     \ev

C     !USES:
      IMPLICIT NONE

C     == global variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
C -------------------------- by Lequan Chi 2013-07-18--
#include "GRID.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"
C------------------------------------------------------

C     !INPUT/OUTPUT PARAMETERS:
C     myTime :: Simulation time
C     myIter :: Simulation timestep number
C     myThid :: my Thread Id. number
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

C ------------------------------------------ by Lequan Chi 2013-07-18----
C more detail see OBCS_PARAMS.h or OBCS_PARAMS_READ
      _RL launchfactor

C     !LOCAL VARIABLES:
C     bi, bj       :: tile indices
C     i,j,k        :: loop indices
C     iB, jB       :: local index of open boundary
C     msgBuf       :: Informational/error message buffer
      INTEGER bi, bj
      INTEGER i, j, k, iB, jB
      INTEGER td
      CHARACTER*(MAX_LEN_MBUF) msgBuf
C -----------------------------------------------------------------------

#ifdef ALLOW_OBCS_PRESCRIBE

C     !LOCAL VARIABLES:
CEOP

# ifdef ALLOW_EXF
      IF ( useEXF ) THEN
        CALL OBCS_EXF_LOAD( myTime, myIter, myThid )
      ENDIF
# endif /* ALLOW_EXF */

      IF ( .NOT. useEXF ) THEN
cph#ifndef ALLOW_AUTODIFF_TAMC
       CALL OBCS_FIELDS_LOAD( myTime, myIter, myThid )
cph#else
cph       STOP 'PH HAS DISABLED THIS RUNTIME OPTION FOR ALLOW_EXF'
cph#endif
      ENDIF

C------------- launch time by Lequan chi 2013-07-14 ---------------
      if ((launch_time .GT. 0.D0 ).and.(myTime .LT. launch_time)) then
         launchfactor = myTIme / launch_time

      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)

#ifdef ALLOW_OBCS_EAST
        IF ( tileHasOBE(bi,bj) ) THEN
         DO k=1,Nr
          DO j=1-OLy,sNy+OLy
           iB = OB_Ie(j,bi,bj)
           IF ( iB.NE.OB_indexNone ) THEN

             OBEu(j,k,bi,bj) = OBEu(j,k,bi,bj) * launchfactor 
     &                              * maskW(iB,j,k,bi,bj)

             OBEv(j,k,bi,bj) = OBEv(j,k,bi,bj) * launchfactor
     &                              * maskW(iB,j,k,bi,bj)
           ENDIF
          ENDDO
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS_EAST */

#ifdef ALLOW_OBCS_WEST
        IF ( tileHasOBW(bi,bj) ) THEN
         DO k=1,Nr
          DO j=1-OLy,sNy+OLy
           iB = OB_Iw(j,bi,bj)
           IF ( iB.NE.OB_indexNone ) THEN

             OBWu(j,k,bi,bj) = OBWu(j,k,bi,bj) * launchfactor 
     &                              * maskW(1+iB,j,k,bi,bj) 

             OBWv(j,k,bi,bj) = OBWv(j,k,bi,bj) * launchfactor
     &                              * maskW(1+iB,j,k,bi,bj) 

           ENDIF
          ENDDO
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS_WEST */

#ifdef ALLOW_OBCS_NORTH
        IF ( tileHasOBN(bi,bj) ) THEN
         DO k=1,Nr
          DO i=1-OLx,sNx+OLx
           jB = OB_Jn(i,bi,bj)
           IF ( jB.NE.OB_indexNone ) THEN

             OBNv(i,k,bi,bj) = OBNv(i,k,bi,bj) * launchfactor
     &                              * maskS(i,jB,k,bi,bj)

             OBNu(i,k,bi,bj) = OBNu(i,k,bi,bj) * launchfactor
     &                              * maskS(i,jB,k,bi,bj)

           ENDIF
          ENDDO
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS_NORTH */

#ifdef ALLOW_OBCS_SOUTH
        IF ( tileHasOBS(bi,bj) ) THEN
         DO k=1,Nr
          DO i=1-OLx,sNx+OLx
           jB = OB_Js(i,bi,bj)
           IF ( jB.NE.OB_indexNone ) THEN

             OBSv(i,k,bi,bj) = OBSv(i,k,bi,bj) * launchfactor
     &                              * maskS(i,1+jB,k,bi,bj)

             OBSu(i,k,bi,bj) = OBSu(i,k,bi,bj) * launchfactor
     &                              * maskS(i,1+jB,k,bi,bj)

           ENDIF
          ENDDO
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS_SOUTH */

       ENDDO
      ENDDO

      end if
C------------------------------------------------------------------



# ifdef ALLOW_OBCSN_CONTROL
      write(msgBuf,*) 'launch_time will not be used for ALLOW_OBCSN_CONTROL'
      CALL PRINT_ERROR(msgBuf, myThid)

      CALL CTRL_GETOBCSN ( myTime, myIter, mythid )
# endif

# ifdef ALLOW_OBCSS_CONTROL
      write(msgBuf,*) 'launch_time will not be used for ALLOW_OBCSN_CONTROL'
      CALL PRINT_ERROR(msgBuf, myThid)

      CALL CTRL_GETOBCSS ( myTime, myIter, mythid )
# endif

# ifdef ALLOW_OBCSW_CONTROL]
      write(msgBuf,*) 'launch_time will not be used for ALLOW_OBCSN_CONTROL'
      CALL PRINT_ERROR(msgBuf, myThid)

      CALL CTRL_GETOBCSW ( myTime, myIter, myThid )
# endif

# ifdef ALLOW_OBCSE_CONTROL
      write(msgBuf,*) 'launch_time will not be used for ALLOW_OBCSN_CONTROL'
      CALL PRINT_ERROR(msgBuf, myThid)

      CALL CTRL_GETOBCSE ( myTime, myIter, myThid )
# endif

#endif /* ALLOW_OBCS_PRESCRIBE */

      RETURN
      END
