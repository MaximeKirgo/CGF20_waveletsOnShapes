function [M] = compute_minkowski_dist_mat(M,varargin)
%COMPUTE_EUCLIDEAN_DIST_MAT Summary of this function goes here
%   Detailed explanation goes here
    p = inputParser;
    addParameter(p,'order',2,@isnumeric);
    parse(p,varargin{:});
    order = p.Results.order;
    
    D = zeros(M.nv,M.nv);
    for i=1:M.nv
        D(:,i) = (sum(abs(M.surface.VERT-M.surface.VERT(i,:)).^order,2)).^(1/order);
    end
    M.D = D;
end

