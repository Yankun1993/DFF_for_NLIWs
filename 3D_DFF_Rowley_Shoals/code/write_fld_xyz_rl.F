C $Header: /u/gcmpack/MITgcm/pkg/rw/write_fld_xyz_rl.F,v 1.5 2009/09/01 19:28:24 jmc Exp $
C $Name: checkpoint64e $

#include "RW_OPTIONS.h"

      SUBROUTINE WRITE_FLD_XYZ_RL(pref,suff,field,myIter,myThid )
C WRITE_FLD_XYZ_RL is a "front-end" interface to the low-level I/O
C routines. It assumes single record files.
      IMPLICIT NONE
C Global
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
C Arguments
      CHARACTER*(*) pref,suff
      _RL field(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr,nSx,nSy)
      INTEGER myIter
      INTEGER myThid
C Functions
      INTEGER ILNBLNK,IFNBLNK
C Common
      COMMON /RD_WR_FLD/ globalFile
      LOGICAL globalFile
C Local
      LOGICAL useCurrentDir
      _RS dummyRS(1)
      CHARACTER*(2) fType
      INTEGER nNz
      INTEGER iRec
      INTEGER s1Lo,s1Hi,s2Lo,s2Hi
      CHARACTER*(MAX_LEN_FNAM) fullName
C
C--   Build file name
C     Name has form 'prefix.suffix'
C     e.g. U.0000000100
      s1Lo = IFNBLNK(pref)
      s1Hi = ILNBLNK(pref)

      IF ( suff .EQ. ' ' ) THEN
       WRITE( fullName, '(A)' ) pref(s1Lo:s1Hi)
      ELSE
       s2Lo = IFNBLNK(suff)
       s2Hi = ILNBLNK(suff)
       WRITE( fullName, '(A,A)' ) pref(s1Lo:s1Hi),suff(s2Lo:s2Hi)
      ENDIF

      useCurrentDir = .FALSE.
      fType='RL'
      nNz=Nr
      iRec=1
#ifdef ALLOW_MDSIO
      CALL MDS_WRITE_FIELD(
     I                      fullName, writeBinaryPrec,
     I                      globalFile, useCurrentDir,
     I                      fType, nNz, 1, nNz, field, dummyRS,
     I                      iRec, myIter, myThid )
#endif
      RETURN
      END
      
C================================================================================
C Below are speical codes for station output modified from WRITE_FLD_XYZ_RL
C        by Lequan Chi 2013-11-09
C================================================================================

C $Header: /u/gcmpack/MITgcm/pkg/rw/write_fld_xyz_rl.F,v 1.5 2009/09/01 19:28:24 jmc Exp $
C $Name: checkpoint64e $

      SUBROUTINE WRITE_ST_FLD_XYZ_RL( 
     I      pref,suff,field,var_klevel,myIter,myThid )
C WRITE_FLD_XYZ_RL is a "front-end" interface to the low-level I/O
C routines. It assumes single record files.
      IMPLICIT NONE
C Global
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
C Arguments
      CHARACTER*(*) pref,suff
      _RL field(1-Olx:sNx+Olx,1-Oly:sNy+Oly,Nr,nSx,nSy)
      INTEGER myIter
      INTEGER myThid
      INTEGER var_klevel
C Functions
      INTEGER ILNBLNK,IFNBLNK
C Common
      COMMON /RD_WR_FLD/ globalFile
      LOGICAL globalFile
C Local
      LOGICAL useCurrentDir
      _RS dummyRS(1)
      CHARACTER*(2) fType
      INTEGER nNz
      INTEGER iRec
      INTEGER s1Lo,s1Hi,s2Lo,s2Hi
      CHARACTER*(MAX_LEN_FNAM) fullName
C
C--   Build file name
C     Name has form 'prefix.suffix'
C     e.g. U.0000000100
      s1Lo = IFNBLNK(pref)
      s1Hi = ILNBLNK(pref)
C------------------------------------------------by Lequan Chi ------
      WRITE( fullName, '(A)' ) pref(s1Lo:s1Hi)
C------original ----------
C      IF ( suff .EQ. ' ' ) THEN
C       WRITE( fullName, '(A)' ) pref(s1Lo:s1Hi)
C      ELSE
C       s2Lo = IFNBLNK(suff)
C       s2Hi = ILNBLNK(suff)
C       WRITE( fullName, '(A,A)' ) pref(s1Lo:s1Hi),suff(s2Lo:s2Hi)
C      ENDIF
C---------------------------------------------------------------------
C
      useCurrentDir = .FALSE.
      fType='RL'
      nNz=Nr
      iRec=1
#ifdef ALLOW_MDSIO
      CALL MDS_STATION_WRITE_FIELD(
     I                      fullName, writeBinaryPrec,
     I                      globalFile, useCurrentDir,
     I                      fType, nNz, 1, nNz, field, dummyRS,
     I                      iRec, var_klevel, myIter, myThid )
#endif
      RETURN
      END
