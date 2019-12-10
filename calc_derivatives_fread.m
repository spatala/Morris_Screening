clear all; clc;

num_var = 30; num_paths = 100000; delta = 0.1; tnum = 500;


mat_name = ['np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'_pathIDs.mat'];
s1 = load(mat_name);
full_paths = s1.full_paths;
n_fpaths = size(full_paths,1);

%%% Load xvals_fpaths.mat
mat_name = ['xvals_np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'_fp.mat'];
s1 = load(mat_name);
xmat_fp = s1.xmat_fp; indmat_fp = s1.indmat_fp;

dir1 = '/Users/srikanthpatala/Documents/Morris_Data/';
dir2 = [num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'/'];
dir = [dir1,dir2];



t1 = 100;
d_rmean = zeros(n_fpaths,num_var);
d_rmean_sig = zeros(n_fpaths,num_var);
for ct1 = 1:n_fpaths
    ct1
    npath = full_paths(ct1);
    rmean_fp = zeros(num_var+1,tnum);
    rmean_sig_fp = zeros(num_var+1,tnum);
    
    for nvar = 1:(num_var+1)
        res_id = (npath-1)*(num_var+1) + nvar;
        fstr = [dir,'res_',num2str(res_id)];
        fileID = fopen(fstr,'r');
        C = textscan(fileID,'%f %f %f');
        c_t = C{1}; t_rmean = C{3}; t_sig = C{2};
        rmean_fp(nvar,:) = t_rmean;
        rmean_sig_fp(nvar,:) = t_sig;
        fclose(fileID);
    end
    rmean_y = rmean_fp(:,t1); rmean_sig_y = rmean_sig_fp(:,t1);
    ind = indmat_fp(((ct1-1)*num_var)+1:ct1*num_var,:);
    d_rmean(ct1,:) = (rmean_y(ind(:,2))-rmean_y(ind(:,3)))/delta;
    d_rmean_sig(ct1,:) = (rmean_sig_y(ind(:,2))-rmean_sig_y(ind(:,3)))/delta;
end