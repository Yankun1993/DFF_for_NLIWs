C $Header: /u/gcmpack/MITgcm/model/src/ini_fields.F,v 1.25 2011/12/08 22:36:20 jmc Exp $
C $Name: checkpoint64e $

#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: INI_FIELDS

C     !INTERFACE:
      SUBROUTINE INI_FIELDS( myThid )

C     !DESCRIPTION:
C     Initial conditions of the model state variables are set here. For
C     continuation runs a restart file will be used. For original runs
C     custom rules can be included here.

C     !USES:
      IMPLICIT NONE
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"

C     !INPUT PARAMETERS:
      INTEGER myThid
CEOP

C     Set model variables to initial/restart conditions
      IF ( startTime .EQ. baseTime .AND.  nIter0 .EQ. 0
     &     .AND. pickupSuff .EQ. ' ' ) THEN
        CALL INI_VEL( myThid )
        CALL INI_THETA( myThid )
        CALL INI_SALT( myThid )
        CALL INI_PSURF( myThid )
        CALL INI_PRESSURE( myThid )
        CALL INI_StationMask( myThid )
#ifdef INCLUDE_EP_FORCING_CODE
        CALL INI_EP( myThid )
#endif
      ELSEIF ( .NOT.useOffLine ) THEN
        CALL READ_PICKUP( nIter0, myThid )
C Station Mask File will not be written into any pickup files
        CALL INI_StationMask( myThid )

c       IF (pickup_write_immed) THEN
c         CALL WRITE_PICKUP(
c    I                       .TRUE., startTime, nIter0, myThid )
c       ENDIF

      ENDIF

#ifdef ALLOW_NONHYDROSTATIC
      IF ( nonHydrostatic ) THEN
        CALL INI_NH_FIELDS( myThid )
      ENDIF
#endif /* ALLOW_NONHYDROSTATIC */

#ifdef NONLIN_FRSURF
# ifndef DISABLE_SIGMA_CODE
      IF ( selectSigmaCoord.NE.0 ) THEN
        CALL UPDATE_ETAWS( startTime, nIter0, myThid )
      ENDIF
# endif /* DISABLE_SIGMA_CODE */
#endif /* NONLIN_FRSURF */

      RETURN
      END


C-------------independent SpongeThickness for N/S/W/E by Lequan chi-----------
C read Station Mask.
C          referenced from INI_PSURF( myThid )


C $Header: /u/gcmpack/MITgcm/model/src/ini_psurf.F,v 1.11 2009/06/14 21:45:12 jmc Exp $
C $Name: checkpoint64e $


C     !ROUTINE: INI_PSURF
C     !INTERFACE:
      SUBROUTINE INI_StationMask( myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE INI_PSURF                                     |
C     | o Set model initial StationMask.                         |
C     |          based on NI_PSURF
C     *==========================================================*
C     | There are several options for setting the initial        |
C     | surface displacement (r unit) field.                     |
C     |  1. Inline code                                          |
C     |  2. Two-dimensional data from a file.                    |
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
#include "SURFACE.h"
#ifdef ALLOW_CD_CODE
#include "CD_CODE_VARS.h"
#endif

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     myThid ::  Number of this instance of INI_PSURF
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     bi,bj  :: tiles indices
C     I,J    :: Loop counters
      INTEGER bi, bj
      INTEGER  I,  J
CEOP

C--   Initialise surface position anomaly to zero
      DO bj = myByLo(myThid), myByHi(myThid)
       DO bi = myBxLo(myThid), myBxHi(myThid)
        DO J=1-Oly,sNy+Oly
         DO I=1-Olx,sNx+Olx
          StationMask(I,J,bi,bj) = 0. _d 0
         ENDDO
        ENDDO
       ENDDO
      ENDDO
C     Read an initial state
      IF (StationMaskFile .NE. ' ') THEN
       CALL READ_FLD_XY_RL(StationMaskFile,' ',StationMask,0,myThid)
C      fill the overlap (+ BARRIER)
       _EXCH_XY_RL(StationMask, myThid)
      ENDIF

      RETURN
      END


C-----------------------------------------------------------------------------
