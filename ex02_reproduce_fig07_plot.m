close all; clear all;

utils_path = './utils/';
data_path = './data/bones_remeshed/';

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

addpath(genpath(utils_path));


shape_path = sprintf('%s/mat/',data_path);

landmarks_path = sprintf('%s/Landmarks/',data_path);

gamma_path = sprintf('%s/Gammas/',data_path);

load([shape_path 'shape_pairs.mat']);

save_path_root = './data/reproduce_fig07_mat/';
%%
data_tag = 'ts_1.00e-06-21-1.00e+02_nSamp_10_nScales_25_lmkmaxidx_24'
data_path = [save_path_root data_tag '/'];
load([data_path 'meta_data.mat']);

methods = {'wavelet','HK','HQ12'};
%%
fig = figure;
for meth_idx=1:length(methods)
    cur_meth = methods{meth_idx};
    all_mean_errs = NaN*zeros(length(shape_pairs),length(ts_values));
    for sh=1:length(shape_pairs)
        pair = shape_pairs{sh};
        load([data_path sprintf('%s_%s_%s_mean_errs.mat',cur_meth,pair(1),pair(2))]);
        all_mean_errs(sh,:) = mean_errs(:,1);
    end

    v = mean(all_mean_errs,1);
    [m,m_idx] = min(v);

    plot(ts_values,v,'lineWidth',2);hold on;
    %scatter(ts_values(m_idx),m,'r','filled');
    %text(ts_values(m_idx)+1, m, sprintf('(%.2e,%.2e)',ts_values(m_idx),m),'Color','r');
    
end
xlabel('t max value');
ylabel('geo. err.');
grid on;
legend(methods{:});
title('10 samples (GT), 25 scales, all bones (remeshed to 1k vertices)')
