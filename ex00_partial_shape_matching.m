close all; clear all;

utils_path = './utils/';
data_path = './data/';

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

addpath(genpath(utils_path));
%% Parameters
seed = 2;

ts_GT_max = 1;
nSamples = 20;

nScales = 5;

%% load the meshes
M_name = 'cuts_wolf_shape_3_null';
N_name = 'cuts_wolf_shape_3';
fprintf('Test pair: %s -> %s \n',M_name, M_name);
M = compute_normalized_shape([data_path, M_name, '.off'],'neumann',1);
nor_fac = full(M.sqrt_area);
M = compute_normalized_shape([data_path, M_name, '.off'],'neumann',nor_fac);
N = compute_normalized_shape([data_path, N_name, '.off'],'neumann',nor_fac);

%% Compute Euclidean dist mat (for evaluation)
M = compute_minkowski_dist_mat(M);
N = compute_minkowski_dist_mat(N);
M.Gamma = M.D;
N.Gamma = N.D;
%% load the ground-truth correspondence
lmks_obj = load([data_path,M.name]);
landmarks_M = lmks_obj.landmarks;
lmks_obj = load([data_path,N.name]);
landmarks_N = lmks_obj.landmarks;

eval_lmkM = landmarks_M;
eval_lmkN = landmarks_N;
%%
[sampM,sampN,sample_idx] = compute_samples_from_landmarks(N,nSamples,landmarks_M,landmarks_N,'FPS_EUCLIDEAN');

[scales_M,scales_N,~,~] = compute_scales(M,N,nScales,ts_GT_max);

t_1 = tic;
dict_M = compute_wavelet_dict(M,sampM,scales_M);
time_1 = toc(t_1);

t_2 = tic;
dict_N = compute_wavelet_dict(N,sampN,scales_N);
time_2 = toc(t_2);

% Evaluation of p2p map
fprintf('computing T12...');
T12 = knnsearch(dict_N,dict_M);
fprintf('done.\n');
fprintf('computing T21...');
T21 = knnsearch(dict_M,dict_N);
fprintf('done.\n');
%% Plot the p2p maps
figure;
MESH.PLOT.visualize_map_colors(M,N,T12,'IfShowCoverage',false);
view([-90 0]);
figure;
MESH.PLOT.visualize_map_colors(N,M,T21,'IfShowCoverage',false);
view([-90 0]);
%% p2p map evaluation
err12 = eval_pMap(M, N, T12, [eval_lmkM,eval_lmkN])*full(N.sqrt_area);
err21 = eval_pMap(N, M, T21, [eval_lmkN,eval_lmkM])*full(M.sqrt_area);

mean_err12 = mean(err12);
mean_err21 = mean(err21);
fprintf(sprintf('mean 1->2: %.2e, mean 2->1: %.2e\n',mean_err12,mean_err21));
