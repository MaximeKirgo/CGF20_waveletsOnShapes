function [ N ] = compute_normalized_shape( filePath, boundary_type,normalization_factor )
    %COMPUTE_NORMALIZED_SHAPE Summary computes the mesh with all elements required for
    %the wavelet computations (also for all baselines).
    % boundary_type = 'neumann' or 'dirichlet'
    % /!\ Although the vertex positions are divided by sqrt_area, the value
    % of sqrt_area remains the original value (i.e. is not set to 1) /!\
    
    N = MESH.preprocess(filePath);
    N.surface.m = N.nf;
    N.surface.n = N.nv;
    
    [N.W,~,N.A] = calc_LB_FEM_bc(N.surface,boundary_type);% Neumann = good
    % % When using Dirichlet BC, A has singular values = bad for the
    % % computation of the laplacian mother wavelet.
    N.sqrt_area = sqrt(sum(diag(N.A)));
    
    N.surface.VERT = N.surface.VERT/normalization_factor;%/N.sqrt_area; % shape normalization
    N.surface.X = N.surface.X/normalization_factor;%/N.sqrt_area;
    N.surface.Y = N.surface.Y/normalization_factor;%/N.sqrt_area;
    N.surface.Z = N.surface.Z/normalization_factor;%/N.sqrt_area;
    
    % Normalized A and W
    [N.W_NOR,~,N.A_NOR] = calc_LB_FEM_bc(N.surface,boundary_type);
    
    N.invalid_vertices = find(~diag(N.A_NOR));
    N.valid_vertices = setdiff(1:N.nv,N.invalid_vertices);
    
%     % A and W for [Pat13]
%     [N.W_Pat13,N.A_Pat13]=fem_weights_PG(N.surface.VERT, N.surface.TRIV);
    
end

