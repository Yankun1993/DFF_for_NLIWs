# DFF_for_NLIWs

Creator: Yankun Gong (State Key Laboratory of Tropical Oceanography, South China Sea Institute of Oceanology, Chinese Academy of Sciences, Guangzhou 510301, China)
Email: gongyk@scsio.ac.cn

Description:
Three-dimensional and two-dimensional model input files to verify the DFF (directional Fourier filter) method applicability.

===================================================================================
1. File "2D_DFF_H_800m_gamma_1.50":

  An idealized 2D primitive equation ocean solver (MIT general circulation model, MITgcm) in the non-hydrostatic mode. The model domain length is 500 km with the horizontal grid cell size (∆x) of 100 m. A 50 km wide sponge boundary is imposed at both lateral boundaries to absorb outgoing IWs. 88 vertical layers are spaced in accordance with a hyperbolic tangent function profile (Stewart et al., 2017), namely ranging from 1 m near the surface to 20 m near the seabed at a water depth of 1000 m. To satisfy the vertical Courant-Friedrichs-Lewy (CFL) condition with small vertical grid spacings (∆z) and large vertical velocities, a time step of ∆t=5 s is imposed. The model is sampled every 6 min. The initial conditions are set to be horizontally homogenous and vertically stratified.

===================================================================================
