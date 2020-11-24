function [ dictionary ] = compute_HQ12_dict( S,samples,scales, varargin )
    %HEATKERNEL Summary of this function goes here
    %   Detailed explanation goes here
    %%
    useNorm = true;
    if nargin > 3
        if strcmp(varargin{1},'dontUseNorm')
            useNorm = false;
        end
    end
    
    nsamples = length(samples);
    nscales = length(scales);
    k = 300; % number of LB eigenfunctions used in HQ12
    
    
    S = MESH.compute_LaplacianBasis(S,k);
    
    
    laplaceBasis = S.evecs;
    eigenvalues = S.evals;
    
    lamb_k = abs(eigenvalues(1:k));
    
    dictionary = zeros(S.nv,nscales*nsamples);
    
    for scale_idx=1:nscales
        ts = scales(scale_idx);
        for sample_idx=1:nsamples
            segment = zeros(size(laplaceBasis,1),1);
            segment(samples(sample_idx)) = 1;
  
            T = lamb_k.*exp(-lamb_k*ts);
            dict_sample = T.*(laplaceBasis' * segment);
            dict_sample  = laplaceBasis*dict_sample;

            dictionary(:,sample_idx+(scale_idx-1)*nsamples) = dict_sample;
        end
    end
%     % Old normalizations:
%     dictionary = dictionary./(max(dictionary)-min(dictionary));
%     dictionary = bsxfun(@rdivide,dictionary,sum(S.A*abs(dictionary)));
%     dictionary = bsxfun(@rdivide,dictionary,sum(S.A_NOR*abs(dictionary)));


    if useNorm
        % Correct normalization:
        % First, divide by the L1 of each function
        dictionary = bsxfun(@rdivide,dictionary,sum(S.A_NOR*abs(dictionary)));
        % Then, normalize each function, so that its amplitude is 1.
        dictionary = dictionary./(max(dictionary)-min(dictionary));
    end
end

