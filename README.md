# DFF_for_NLIWs

Creator: Yankun Gong

Email: gongyk@scsio.ac.cn

Affiliation: State Key Laboratory of Tropical Oceanography, South China Sea Institute of Oceanology, Chinese Academy of Sciences, Guangzhou 510301, China.

Descriptions:
Two-dimensional idealized model and three-dimensional realistic model input files to verify the DFF (directional Fourier filter) method applicability.

===========================================================================
1. File "2D_DFF_H_800m_gamma_1.50"

  An idealized 2D primitive equation ocean solver (MIT general circulation model, MITgcm) in the non-hydrostatic mode. The model domain length is 500 km with the horizontal grid cell size (∆x) of 100 m. A 50 km wide sponge boundary is imposed at both lateral boundaries to absorb outgoing IWs. 88 vertical layers are spaced in accordance with a hyperbolic tangent function profile (Stewart et al., 2017), namely ranging from 1 m near the surface to 20 m near the seabed at a water depth of 1000 m. To satisfy the vertical Courant-Friedrichs-Lewy (CFL) condition with small vertical grid spacings (∆z) and large vertical velocities, a time step of ∆t=5 s is imposed. The model is sampled every 6 min. The initial conditions are set to be horizontally homogenous and vertically stratified.

===========================================================================

2. File "3D_DFF_Rowley_Shoals"

  The model domain is composed of 2000 (cross-shore)×1500 (along-shore) cells, in which we mainly consider the region with relatively shallow water (<1500 m). The horizontal grid step is set as 100 m. 80 vertical layers are divided in total with the layer thicknesses ranging from 5 m near the surface to 50 m near the seabed. A double-pycnocline stratification is applied as an initial condition in accordance with the local field observations in April 2019 and the bathymetry data can be found in Gong (2020). A 10 s time step is set to satisfy the Courant-Friedrichs-Lewy conditions both in vertical and horizontal directions. The model starts to temporally sample every 10 min from the 9th model day. Therefore, the model outputs satisfy both spatial and temporal requirements of the DFF method for decomposing NLIWs with a characteristic half-width of 100 m. The model is driven by both the M2 barotropic tides (TPXO8-atlas data) at all boundaries and the mode-1 M2 internal tides (south-eastward components derived from the HRET product, Zaron, 2019) at the offshore boundary. A 10 km wide sponge layer is imposed at each lateral boundary to absorb IWs and avoid energy reflection back to the inner domain.
  
===========================================================================

3. References

Zaron, E.D., 2019. Baroclinic Tidal Sea Level from Exact-Repeat Mission Altimetry. J. Phys. Oceanogr. 49, 193–210. https://doi.org/10.1175/jpo-d-18-0127.1

Gong, Y. (2020). The Effects of Remotely-generated Internal Tides on Internal Waves on a Continental Shelf (Doctoral dissertation, The University of Western Australia).

Gong, Y., Rayson, M. D., Jones, N. L., & Ivey, G. N. (2021). Directional decomposition of internal tides propagating from multiple generation sites. Ocean Modelling, 162, 101801.


