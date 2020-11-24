function [ BASIS ] = LBwavelets( A, W, samples, ts, gi, bi )
    %LBWAVELETS Summary of this function goes here
    %   gi: valid vertices
    % bi: invalid vertices
    nScales = length(ts);
    
    nv = size(A,1);
    
%     a = sum(diag(A));
%     A = A/a;
    
    nScales = length(ts);
    
    wavelet_fun = {};

%     diracs = eye(nv);
%     diracs = diracs(:,samples);
    nSamples = length(samples);
    diracs = sparse(samples,1:nSamples,1,nv,nSamples);

    phi_tmp = diracs;
    
    A(bi,:) = [];
    A(:,bi) = [];
    W(bi,:) = [];
    W(:,bi) = [];
    phi_tmp(bi,:) = [];
    
    % Applying the Laplacian to obtain the Mother wavelet
    wavelet_fun{end+1} = A\(W*phi_tmp);
%     wavelet_fun{end+1} = sparseinv(A)*(W*phi_tmp);

    for i=2:nScales
        wavelet_fun{end+1} = (A+ts(i)*W)\(A*wavelet_fun{end});
%         wavelet_fun{end+1} = sparseinv(A+ts(i)*W)*(A*wavelet_fun{end});
    end


    wavelets = [];

    % MEXICAN HAT wavelets
    for i=1:nScales
        wavelets = [wavelets,wavelet_fun{i}];
    end

    % Removing the NaN values
    wavelets(isnan(wavelets)) = 1;
    
    wavelets_tmp = wavelets;
    wavelets = zeros(nv,nSamples*nScales);
    wavelets(gi,:) = wavelets_tmp;
    
    BASIS = struct;
    BASIS.basis = full(wavelets);
    
end

