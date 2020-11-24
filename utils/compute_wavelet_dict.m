function [ dictionary ] = compute_wavelet_dict( S,samples,scales )
    %COMPUTE_WAVELET_DICT
    
    % Adding extra time scale to compensate for the mother wavelet
    % computation
    BASIS = LBwavelets( S.A_NOR, S.W_NOR, samples, [0 scales], S.valid_vertices,S.invalid_vertices );
    
    % Removing mother wavelet
    dictionary = BASIS.basis(:,length(samples)+1:end);
    
%     % Old normalizations:
%     dictionary = dictionary./(max(dictionary)-min(dictionary));
%     dictionary = bsxfun(@rdivide,dictionary,sum(S.A*abs(dictionary)));
%     dictionary = bsxfun(@rdivide,dictionary,sum(S.A_NOR*abs(dictionary)));

%     % Other attempt:
%     dict_plus = subplus(dictionary);
%     dict_plus = dict_plus./max(dict_plus);
%     dict_neg = subplus(-dictionary);
%     dict_neg = -dict_neg./max(dict_neg);
%     dictionary = S.nv*(0.9*dict_plus+0.1*dict_neg);

    % Correct normalization:
    % First, divide by the L1 of each function
    dictionary = bsxfun(@rdivide,dictionary,sum(S.A_NOR*abs(dictionary)));
    % Then, normalize each function, so that its amplitude is 1.
    dictionary = dictionary./(max(dictionary)-min(dictionary));
end

