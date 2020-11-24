function [ dictionary ] = compute_HK_dict( S,samples,scales, varargin )
    %COMPUTE_HK_DICT
    
    useNorm = true;
    if nargin > 3
        if strcmp(varargin{1},'dontUseNorm')
            useNorm = false;
        end
    end
    
    numEigs = 300;
    
    try
        [evecs, evals] = eigs(S.W_NOR, S.A_NOR, numEigs, 1e-6);
    catch
        % In case of trouble make the laplacian definite
        [evecs, evals] = eigs(W - 1e-8*speye(S.nv), A, numEigs, 'sm');
    end
    evals = diag(evals);

    [evals, order] = sort(abs(evals),'ascend');
    evecs = evecs(:,order);
    
    dictionary = heatKernelMap(evecs, evals, scales, samples);
    

    if useNorm
        % Correct normalization:
        % First, divide by the L1 of each function
        dictionary = bsxfun(@rdivide,dictionary,sum(S.A_NOR*abs(dictionary)));
        % Then, normalize each function, so that its amplitude is 1.
        dictionary = dictionary./(max(dictionary)-min(dictionary));
    end
end

