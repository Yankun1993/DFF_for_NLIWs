C $Header: /u/gcmpack/MITgcm/pkg/obcs/obcs_add_tides.F,v 1.2 2012/11/15 20:46:52 dimitri Exp $
C $Name: checkpoint64e $

#include "OBCS_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: OBCS_ADD_TIDES

C     !INTERFACE:
      SUBROUTINE OBCS_ADD_TIDES( myTime, myIter, myThid )

C     !DESCRIPTION:
C     *==========================================================*
C     | SUBROUTINE OBCS_ADD_TIDES
C     | o Modify OB normal flow to add tidal forcing
C     *==========================================================*

C     !USES:
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "OBCS_PARAMS.h"
#include "OBCS_GRID.h"
#include "OBCS_FIELDS.h"

C     !INPUT/OUTPUT PARAMETERS:
      _RL myTime
      INTEGER myIter
      INTEGER myThid
CEOP

#ifdef ALLOW_OBCS
#ifdef ALLOW_OBCS_TIDES

C     !FUNCTIONS:

C     !LOCAL VARIABLES:
C     bi, bj       :: tile indices
C     i,j,k        :: loop indices
C     iB, jB       :: local index of open boundary
C     msgBuf       :: Informational/error message buffer
      INTEGER bi, bj
      INTEGER i, j, k, iB, jB
      INTEGER td
C------------- launch time by Lequan chi 2013-07-14 ---------------
C     launchfactor : launch time factor = 1 when myTime > launch_time; 
C                      otherwise, launchfactor = myTime/launch_time
      _RL launchfactor 
C------------------------------------------------------------------


#ifdef ALLOW_DEBUG
      IF (debugMode) CALL DEBUG_ENTER('OBCS_ADD_TIDES',myThid)
#endif

C------------- launch time by Lequan chi 2013-07-14 ---------------
      if ((launch_time .GT. 0).and.(myTIme .LT. launch_time)) then
         launchfactor = myTIme / launch_time
      else
         launchfactor = 1.0
      end if
C------------------------------------------------------------------


C--   Add tidal currents:
      DO bj=myByLo(myThid),myByHi(myThid)
       DO bi=myBxLo(myThid),myBxHi(myThid)

#ifdef ALLOW_OBCS_EAST
        IF ( tileHasOBE(bi,bj) ) THEN
         DO k=1,Nr
          DO j=1-OLy,sNy+OLy
           iB = OB_Ie(j,bi,bj)
           IF ( iB.NE.OB_indexNone ) THEN
            DO td=1,tidalComponents
             OBEu(j,k,bi,bj) = OBEu(j,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskW(iB,j,k,bi,bj) * OBEUam(j,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBEUph(j,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
             OBEv(j,k,bi,bj) = OBEv(j,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskW(iB,j,k,bi,bj) * OBEVam(j,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBEVph(j,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
            ENDDO
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
            DO td=1,tidalComponents
             OBWu(j,k,bi,bj) = OBWu(j,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskW(1+iB,j,k,bi,bj) * OBWUam(j,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBWUph(j,td,bi,bj)) /
     &                   tidalPeriod(td) )

C------------- Add a certain baroclinic signal on the west boundary -------------

              OBWu(j,k,bi,bj) = OBWu(j,k,bi,bj) +
     &               maskW(1+iB,j,k,bi,bj) * 
     &               BCWUam(j,tidalComponents*(k-1)+td,bi,bj) * 
     &     SIN (2.D0 * PI * 
     &    ( myTime-BCWUph(j,tidalComponents*(k-1)+td,bi,bj))/
     &                   tidalPeriod(td) )

C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
             OBWv(j,k,bi,bj) = OBWv(j,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskW(1+iB,j,k,bi,bj) * OBWVam(j,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBWVph(j,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
            ENDDO
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
            DO td=1,tidalComponents
             OBNv(i,k,bi,bj) = OBNv(i,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskS(i,jB,k,bi,bj) * OBNVam(i,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBNVph(i,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
             OBNu(i,k,bi,bj) = OBNu(i,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskS(i,jB,k,bi,bj) * OBNUam(i,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBNUph(i,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
            ENDDO
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
            DO td=1,tidalComponents
             OBSv(i,k,bi,bj) = OBSv(i,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskS(i,1+jB,k,bi,bj)* OBSVam(i,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBSVph(i,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
             OBSu(i,k,bi,bj) = OBSu(i,k,bi,bj) +
C--------------- launch time by Lequan Chi 2013-07-14 ---
     &              launchfactor *  
C--------------------------------------------------------
     &              maskS(i,1+jB,k,bi,bj)* OBSUam(i,td,bi,bj) *
     &              SIN( 2.D0 * PI * (myTime-OBSUph(i,td,bi,bj)) /
     &                   tidalPeriod(td) )
C--------------------------------------------------------
            ENDDO
           ENDIF
          ENDDO
         ENDDO
        ENDIF
#endif /* ALLOW_OBCS_SOUTH */

       ENDDO
      ENDDO

#ifdef ALLOW_DEBUG
      IF (debugMode) CALL DEBUG_LEAVE('OBCS_ADD_TIDES',myThid)
#endif

#endif /* ALLOW_OBCS_TIDES */
#endif /* ALLOW_OBCS */

      RETURN
      END
