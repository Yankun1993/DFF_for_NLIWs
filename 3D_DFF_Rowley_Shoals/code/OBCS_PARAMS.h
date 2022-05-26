C $Header: /u/gcmpack/MITgcm/pkg/obcs/OBCS_PARAMS.h,v 1.4 2012/11/15 15:55:42 dimitri Exp $
C $Name: checkpoint64e $
C v tide for West/East and u tide for North/South are added by Lequan Chi
C independent sponge thinkness for N/S/W/E is added by Lequan Chi

#ifdef ALLOW_OBCS

CBOP
C     !ROUTINE: OBCS_PARAMS.h
C     !INTERFACE:
C     #include "OBCS_PARAMS.h"

C     !DESCRIPTION:
C     *==========================================================*
C     | OBCS_PARAMS.h
C     | o Header file containing OBCS parameters
C     *==========================================================*
C     | o Note: does not (and should not) contain any conditional
C     |   statement that depends on OBCS options ; therefore
C     |   can be safely included without OBCS_OPTIONS.h
C     *==========================================================*
CEOP

C tidalComponents  :: number of tidal components to be applied
      INTEGER tidalComponents
      PARAMETER ( tidalComponents = 1 )

C--   COMMON /OBC_PARM_I/ OBCS integer-type parameter
C OBCS_u1_adv_T    :: >0: use 1rst O. upwind adv-scheme @ OB (=1: only if outflow)
C OBCS_u1_adv_S    :: >0: use 1rst O. upwind adv-scheme @ OB (=1: only if outflow)
C OBCS_monSelect   :: select group of variables to monitor
C spongeThickness  :: number grid points that make up the sponge layer (def=0)
      COMMON /OBC_PARM_I/
     & OBCS_u1_adv_T, OBCS_u1_adv_S,
     & OBCS_monSelect,
C     & spongeThickness,
C-------------independent SpongeThickness for N/S/W/E by Lequan chi-----------
C set independent spongeThickness in North/South/West/East,
C "spongeThickness" will still and only be used for sponge boundary for ice
     & spongeThicknessN,
     & spongeThicknessS,
     & spongeThicknessW,
     & spongeThicknessE
C-----------------------------------------------------------------------------

      INTEGER OBCS_u1_adv_T, OBCS_u1_adv_S
      INTEGER OBCS_monSelect
C      INTEGER spongeThickness
C-------------independent SpongeThickness for N/S/W/E by Lequan chi-----------
C set independent spongeThickness in North/South/West/East, 
C by Lequan Chi 2013-04-28
      INTEGER spongeThicknessN
      INTEGER spongeThicknessS
      INTEGER spongeThicknessW
      INTEGER spongeThicknessE
C------------------------------------------------------------------------------
C

C--   COMMON /OBC_PARM_L/ OBCS logical-type parameter
C useOrlanskiNorth/South/East/West
C                  :: specify Orlanski boundary conditions for northern/
C                     southern/eastern/Western
C useStevensNorth/South/East/West
C                  :: use open boundary computations following Stevens (1990)
C useStevensPhaseVel
C                  :: use phase velocity contribution for open boundary
C                     computations following Stevens (1990), default = true
C useStevensAdvection
C                  :: use advective contribution for open boundary
C                     computations following Stevens (1990), default = true
C useOBCSsponge    :: turns on sponge layer along boundary (def=false)
C useOBCSbalance   :: balance the volume flux through boundary
C                     at every time step
C useOBCStides     :: modify OB normal flow to add tidal forcing
C useOBCSprescribe :: read boundary conditions from a file
C                      (overrides Orlanski and other boundary values)
C OBCSprintDiags   :: print boundary values to STDOUT (def=true)
C OBCSfixTopo      :: check and adjust topography for problematic gradients
C                     across boundaries (def=true)

      COMMON /OBC_PARM_L/
     & useOrlanskiNorth,useOrlanskiSouth,
     & useOrlanskiEast,useOrlanskiWest,
     & useStevensNorth,useStevensSouth,
     & useStevensEast,useStevensWest,
     & useStevensPhaseVel, useStevensAdvection,
     & useOBCSsponge, useOBCSbalance, useOBCStides, useOBCSprescribe,
     & OBCSprintDiags,
     & OBCSfixTopo
      LOGICAL useOrlanskiNorth
      LOGICAL useOrlanskiSouth
      LOGICAL useOrlanskiEast
      LOGICAL useOrlanskiWest
      LOGICAL useStevensNorth
      LOGICAL useStevensSouth
      LOGICAL useStevensEast
      LOGICAL useStevensWest
      LOGICAL useStevensPhaseVel
      LOGICAL useStevensAdvection
      LOGICAL useOBCSsponge
      LOGICAL useOBCSbalance
      LOGICAL useOBCStides
      LOGICAL useOBCSprescribe
      LOGICAL OBCSprintDiags
      LOGICAL OBCSfixTopo

C--   COMMON /OBC_PARM_R/ OBCS real-type parameter
C OBCS_balanceFacN/S/E/W  :: weighting factor for balancing OB normal flow
C OBCS_uvApplyFac         :: multiplying factor to U,V normal comp. when applying
C                            OBC to 2nd column/row (for backward compatibility).
C OBCS_monitorFreq        :: monitor output frequency (s) for OB statistics
C U/Vrelaxobcsinner/bound :: relaxation time scale (in seconds) on the boundary
C                            (bound) and at the innermost grid point of the sponge
C                            layer (inner); relaxation time scales in-between
C                            are linearly interpolated from these values
C T/SrelaxStevens         :: relaxation time scale (in seconds) for T/S-points
C                            for Stevens boundary conditions
C tidalPeriod             :: tidal period (s)
      COMMON /OBC_PARM_R/
     &     OBCS_balanceFacN, OBCS_balanceFacS,
     &     OBCS_balanceFacE, OBCS_balanceFacW,
     &     OBCS_uvApplyFac,
     &     OBCS_monitorFreq,
     &     tidalPeriod,
     & Urelaxobcsinner,Urelaxobcsbound,
     & Vrelaxobcsinner,Vrelaxobcsbound,
     & TrelaxStevens, SrelaxStevens,
C------------- launch time by Lequan chi 2013-07-14 --------------------------
C set launch time, boundary u/v will be 0 at 0s, and increased linearly to what it should 
C    be according to prescribe/tide params at launchtime.
C In simple word, boundary from tide and prescribe will be set to 
C    (mytime/launchtime)*u0 when mytime < launch_time, or u0 when mytime > launch_time,
C    u0 is what u used to be in original MITgcm codes.
C
C    !NOTICE: This is only used for tide or prescribe u/v, sponge/steven/Orlanski/balance/ice
C    will not be influenced.
C
C    ! launch_time should be set to -1 when it is useless
     & launch_time
C-----------------------------------------------------------------------------
      _RL OBCS_balanceFacN, OBCS_balanceFacS
      _RL OBCS_balanceFacE, OBCS_balanceFacW
      _RL OBCS_uvApplyFac
      _RL OBCS_monitorFreq
      _RL tidalPeriod(tidalComponents)
      _RS Urelaxobcsinner
      _RS Urelaxobcsbound
      _RS Vrelaxobcsinner
      _RS Vrelaxobcsbound
      _RS TrelaxStevens
      _RS SrelaxStevens
C------------- launch time by Lequan chi 2013-07-14 --------------------------
      _RL launch_time
C------------------------------------------------------------------------------

C--   COMMON /OBC_FILES/ OBCS character-type parameter
C insideOBmaskFile   :: File to specify Inside OB region mask (zero beyond OB).
C OB[N,S,E,W][u,v,w,t,s,eta,am,ph]File :: Files with boundary conditions,
C                                         the letter combinations mean:
C                     N/S/E/W   :: northern/southern/eastern/western boundary
C                     u/v/w/t/s :: ocean u/v/w velocities, temperature/salinity
C                     eta       :: sea surface height
C                     am/ph     :: tidal amplitude (m/s) / phase (s)
      COMMON /OBC_FILES/
     &      OBNuFile,  OBSuFile,  OBEuFile,  OBWuFile,
     &      OBNvFile,  OBSvFile,  OBEvFile,  OBWvFile,
     &      OBNwFile,  OBSwFile,  OBEwFile,  OBWwFile,
     &      OBNtFile,  OBStFile,  OBEtFile,  OBWtFile,
     &      OBNsFile,  OBSsFile,  OBEsFile,  OBWsFile,
     &      OBNetaFile,OBSetaFile,OBEetaFile,OBWetaFile,
C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
C  original :
C     &      OBNamFile, OBSamFile, OBEamFile, OBWamFile,
C     &      OBNphFile, OBSphFile, OBEphFile, OBWphFile,
C  new:
     &       OBNVAmFile, OBSVAmFile, OBEUAmFile, OBWUAmFile,
     &       OBNVPhFile, OBSVPhFile, OBEUPhFile, OBWUPhFile,
     &       OBNUAmFile, OBSUAmFile, OBEVAmFile, OBWVAmFile,
     &       OBNUPhFile, OBSUPhFile, OBEVPhFile, OBWVPhFile,
     &       BCNRatFile, BCNAmpFile, BCNGphFile,
C--------------------------------------------------------
     &      insideOBmaskFile
      CHARACTER*(MAX_LEN_FNAM)
     &      OBNuFile,  OBSuFile,  OBEuFile,  OBWuFile,
     &      OBNvFile,  OBSvFile,  OBEvFile,  OBWvFile,
     &      OBNwFile,  OBSwFile,  OBEwFile,  OBWwFile,
     &      OBNtFile,  OBStFile,  OBEtFile,  OBWtFile,
     &      OBNsFile,  OBSsFile,  OBEsFile,  OBWsFile,
     &      OBNetaFile,OBSetaFile,OBEetaFile,OBWetaFile,
C--------------------------------------------------------
C  full tide obcs boundary : by Lequan Chi
C  original :
C     &      OBNamFile, OBSamFile, OBEamFile, OBWamFile,
C     &      OBNphFile, OBSphFile, OBEphFile, OBWphFile,
C  new:
     &       OBNVAmFile, OBSVAmFile, OBEUAmFile, OBWUAmFile,
     &       OBNVPhFile, OBSVPhFile, OBEUPhFile, OBWUPhFile,
     &       OBNUAmFile, OBSUAmFile, OBEVAmFile, OBWVAmFile,
     &       OBNUPhFile, OBSUPhFile, OBEVPhFile, OBWVPhFile,
     &       BCNRatFile, BCNAmpFile, BCNGphFile,
C--------------------------------------------------------
     &      insideOBmaskFile

#endif /* ALLOW_OBCS */
