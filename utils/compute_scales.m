function [ scales_M, scales_N, scales_GT_M, scales_GT_N ] = compute_scales( M, N, nScales, ts_GT_max )
    %COMPUTE_SCALES Prepares scales for M and N.
    % Input:
    % M = full shape
    % N = partial shape
    % nScales = number of scales to produce
    % ts_GT_max = GT diffusion time to reach after nScales
    % Output:
    % scales_M = scales for our method on M
    % scales_N = scales for our method on N
    % scales_GT_M = GT scales for all other methods (real diffusion times) on M
    % scales_GT_N = GT scales for all other methods (real diffusion times) on N
    
    weighting_fun = ones(1,nScales);
    ts = ts_GT_max*ones(1,nScales).*weighting_fun/nScales;


    ratio = M.sqrt_area/N.sqrt_area;
    scales_N = ts/N.sqrt_area;
    scales_GT_N = cumsum(scales_N);
    
    scales_M = ratio*ts/M.sqrt_area;
    scales_GT_M = cumsum(scales_M);
end

