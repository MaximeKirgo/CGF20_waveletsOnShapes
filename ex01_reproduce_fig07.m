close all; clear all;

utils_path = './utils/';
data_path = './data/bones_remeshed/';

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

addpath(genpath(utils_path));


shape_path = sprintf('%s/mat/',data_path);

load([shape_path 'shape_pairs.mat']);

save_path_root = './data/reproduce_fig07_mat/';
%%
ts_values = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,5,7,8,9,10,11,12,13,14,15,20,25,50,100];
nSamples = 10;
nScales = 25;
lmk_max_idx = 24;% consistent landmark count: 24
thresh = 0:0.001:0.50;

data_tag = sprintf('ts_%.2e-%02d-%.2e_nSamp_%02d_nScales_%02d_lmkmaxidx_%02d',ts_values(1),length(ts_values),ts_values(end),nSamples,nScales,lmk_max_idx);

save_path = [save_path_root data_tag '/'];

if ~exist(save_path)
    mkdir(save_path)
end

methods = {'wavelet','HK','HQ12'};

meta_data.ts_values = ts_values;
meta_data.nSamples = nSamples;
meta_data.lmk_max_idx = lmk_max_idx;
meta_data.nScales = nScales;
meta_data.thresh = thresh;
meta_data.methods = methods;

save([save_path 'meta_data.mat'],'-struct','meta_data');
    
%%
for meth_idx=1:length(methods)
    cur_meth = methods{meth_idx};
    for sh=1:length(shape_pairs)
        pair = shape_pairs{sh};
        sh_M = pair(1);
        sh_N = pair(2);
        M = compute_normalized_shrec19shape(sprintf('%s/%s',shape_path,sh_M),'neumann',1);
        nor_fac = M.sqrt_area;
        M = compute_normalized_shrec19shape(sprintf('%s/%s',shape_path,sh_M),'neumann',nor_fac);
        landmarks_M = M.smpl_matches(1:lmk_max_idx);
        N = compute_normalized_shrec19shape(sprintf('%s/%s',shape_path,sh_N),'neumann',M.sqrt_area);
        landmarks_N = N.smpl_matches(1:lmk_max_idx);
        %%

        [l_M,l_N,samples_idx] = compute_samples_from_landmarks(N,nSamples,landmarks_M,landmarks_N,'FPS_EUCLIDEAN');

        eval_M = landmarks_M;
        eval_N = landmarks_N;
        eval_M(samples_idx) = [];
        eval_N(samples_idx) = [];

        mean_errs = NaN*ones(length(ts_values),1);
        for i=1:length(ts_values)
            ts_GT_max = ts_values(i);
            [scales_ours_M,scales_ours_N,scales_others_M,~] = compute_scales(M,N,nScales,ts_GT_max);



            compute_cur_dict = str2func(sprintf('compute_%s_dict',cur_meth));

            dict_M = compute_cur_dict(M,l_M,scales_ours_M);
            dict_N = compute_cur_dict(N,l_N,scales_ours_N);
            p2p = knnsearch(dict_M,dict_N);
            c_matches = p2p(eval_N);
            c_gt_matches = eval_M;

            [err,curve,err_raw,curve_raw] = compute_errors_and_curves_shrec19(M,thresh,c_matches,c_gt_matches);
            cur_mean = mean(err);
            mean_errs(i) = cur_mean;
            fprintf(sprintf('[%s] Pair %i/%i: computed ts %i/%i. Mean = %.2e\n',cur_meth, sh,length(shape_pairs),i,length(ts_values),cur_mean));
        end
        save([save_path sprintf('%s_%s_%s_mean_errs.mat',cur_meth,sh_M,sh_N)],'mean_errs');
    end
end
