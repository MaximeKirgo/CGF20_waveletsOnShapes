function [ b_idx ] = get_boundary_idx( M,r )
    %GET_BOUNDARY_IDX Summary of this function goes here
    %   Detailed explanation goes here
    bd = calc_boundary_edges(M.surface.TRIV);
    bd_vert = unique(bd(:));

    d = pdist2(M.surface.VERT(bd,:), M.surface.VERT);
    [i,j] = find(d<r);

    is_close_to_boundary = false(M.nv,1);
    is_close_to_boundary(j) = true;
    
    b_idx = find(is_close_to_boundary);
    b_idx = b_idx';
end

