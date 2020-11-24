function [ N ] = compute_normalized_shrec19shape( filePath, boundary_type,normalization_factor )
    %COMPUTE_NORMALIZED_SHREC19SHAPE Summary computes the mesh with all elements required for
    %the wavelet computations (also for all baselines).
    % boundary_type = 'neumann' or 'dirichlet'
    % /!\ Although the vertex positions are divided by sqrt_area, the value
    % of sqrt_area remains the original value (i.e. is not set to 1) /!\
    
    shrec19_data = load([filePath '.mat']);
    N.surface.VERT = shrec19_data.Shape_df.VERT;
    N.surface.TRIV = shrec19_data.Shape_df.TRIV;
    N.G = shrec19_data.G;
    N.name = convertCharsToStrings(shrec19_data.name);
    N.smpl_matches = shrec19_data.smpl_matches;
    
    N.nv = shrec19_data.Shape_df.n;
    N.nf = shrec19_data.Shape_df.m;
    
    N.surface.m = N.nf;
    N.surface.n = N.nv;
    N.surface.X = N.surface.VERT(:,1);
    N.surface.Y = N.surface.VERT(:,2);
    N.surface.Z = N.surface.VERT(:,3);
    
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
    
end

