%%
clear all
close all
clc

addpath('./tools/')

M = load_off('./cat10_partial.off');

bd = calc_boundary_edges(M.TRIV);
bd_vert = unique(bd(:));

r = 5; % WARNING: this is an absolute radius

d = pdist2(M.VERT(bd,:), M.VERT);
[i,j] = find(d<r);

is_close_to_boundary = false(M.n,1);
is_close_to_boundary(j) = true;

figure
trisurf(M.TRIV,M.VERT(:,1),M.VERT(:,2),M.VERT(:,3),double(is_close_to_boundary))
hold on
plot_boundary_edges(M, bd, 'r', 2)
axis equal
shading interp
colorbar
