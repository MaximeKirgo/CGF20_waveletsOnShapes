function [samples_M,samples_N,samples_idx] = get_fps_samples_from_landmarks(N,nSamples,landmarks_M,landmarks_N,strategy)
%GET_SAMPLES_FROM_LANDMARKS Summary of this function goes here
%   Detailed explanation goes here
    if nargin<5
        strategy = 'FPS_EUCLIDEAN';
    end
    [~,idx] = ismember(landmarks_N,N.invalid_vertices);
    idx2keep = idx==0;
    landmarks_N = landmarks_N(idx2keep);
    landmarks_M = landmarks_M(idx2keep);
    
    VERT_landmarks_N = N.surface.VERT(landmarks_N,:);
    
    switch strategy
        case 'FPS_EUCLIDEAN'
            samples_idx = MESH.fps_euclidean(VERT_landmarks_N,nSamples,1);
        case 'FPS_GEODESIC'
            samples_idx = geodesic_fps_SHREC19(N,landmarks_N,nSamples,1);
        case 'RANDOM'
            samples_idx = randperm(length(landmarks_N),nSamples);
        case 'POISSON_DISK'
            [samples,~,~] = random_points_on_mesh(N.surface.VERT,N.surface.TRIV,nSamples,'Color','blue');
            samples_idx = knnsearch(N.surface.VERT(landmarks_N,:),samples);
    end
    
    samples_N = landmarks_N(samples_idx);
    samples_M = landmarks_M(samples_idx);
end

