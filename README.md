# CGF20_waveletsOnShapes
This repository contains the code for the paper "Wavelet-based Heat Kernel Derivatives: towards Informative Localized Shape Analysis" by Maxime Kirgo, Simone Melzi, Giuseppe Patanè, Emanuele Rodolà and Maks Ovsjanikov.

In this paper, we propose a new construction for the Mexican hat wavelets on shapes with applications to partial shape matching. Our approach takes its main inspiration from the well-established methodology of diffusion wavelets. This novel construction allows us to rapidly compute a multiscale family of Mexican hat wavelet functions, by approximating the derivative of the heat kernel. We demonstrate that this leads to a family of functions that inherit many attractive properties of the heat kernel (e.g., local support, ability to recover isometries from a single point, efficient computation).

<p align="center">
  <img align="center"  src="/figures/teaser.png", width=800>
</p>


Main Functions
--------------
```
M = compute_normalized_shape(path_to_off_file, boundary_condition, normalization_factor);

% Input:
%   path_to_off_file: the shape on which the wavelets are computed.
%   boundary_condition: the boundary condition applied at the shape boundary ('neumann' or 'dirichlet').
%   normalization_factor: Normalization factor to apply when computing the shape.
%
% Output:
%   M: the mesh structure.
```
```
[sampM,sampN,sample_idx] = compute_samples_from_landmarks(N,nSamples,landmarks_M,landmarks_N,sampling_method);

% Input:
%   N: the shape on which the samples are selected (partial shape in the case of partial shape matching).
%   nSamples: the number of samples to compute.
%   landmarks_M: the set of available landmarks for the shape M.
%   landmarks_N: the set of available landmarks for the shape N.
%   sampling_method: the sampling method used to generate the samples ('FPS_EUCLIDEAN').
%
% Output:
%   sampM: list of nSamples on the shape M.
%   sampN: list of nSamples on the shape N.
%   sample_idx: list of indices that were used in landmarks_N.
```
```
[scales_M,scales_N,scales_other_M,scales_other_N] = compute_scales(M,N,nScales,ts_GT_max);

% Input:
%   M: the structure for shape M.
%   N: the structure for shape N.
%   nScales: the number of scales to compute.
%   ts_GT_max: the ts_GT_max parameter value, corresponding to the maximum diffusion allowed.
%
% Output:
%   scales_M: the list of scales for shape M for our method.
%   scales_N: the list of scales for shape N for our method.
%   scales_other_M: alternative list of scales for shape M.
%   scales_other_N: alternative list of scales for shape N.
```
```
dict_M = compute_wavelet_dict(M,sampM,scales_M);

% Input:
%   M: the shape on which the wavelets are computed.
%   sampM: the vertex ids where to compute the wavelets.
%   scales_M: the set of scales used to compute the wavelets.
%
% Output:
%   dict_M: an array containing the wavelets computed at the specified samples and scales.
```

Comments
--------
- The script ```ex00_partial_shape_matching.m``` shows how to perform partial shape matching using our method.
- The script ```ex01_reproduce_fig07.m``` shows how to compute the data used to reproduce the Fig.7 of our paper.
- The script ```ex02_reproduce_fig07_plot.m``` plots the Fig.7 of our paper using the data produced with the script ```ex01_reproduce_fig07.m```.
If you have any question/comment about this work, please feel free to contact us: maximekirgo@gmail.com.


[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC%20BY--NC%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc/4.0/)

This work is licensed under a [Creative Commons Attribution-NonCommercial 4.0 International License](http://creativecommons.org/licenses/by-nc/4.0/). For any commercial uses or derivatives, please contact us (maximekirgo@gmail.com, melzismn@gmail.com, maks@lix.polytechnique.fr).
