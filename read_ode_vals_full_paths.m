clear all; clc;

num_var = 30; num_paths = 100000; delta = 0.1; tnum = 500;


mat_name = ['np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'_pathIDs.mat'];
s1 = load(mat_name);
full_paths = s1.full_paths;
n_fpaths = size(full_paths,1);

dir1 = '/Users/srikanthpatala/Dropbox/NCSU_Research/Repos/esms/morris_screening/data_files/';
dir2 = ['mat_np_',num2str(num_paths),'/'];
mname = ['xvals_np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'.mat'];
mat_name = [dir1,dir2,mname];
s1 = load(mat_name);
indmat1 = s1.indmat;
xmat1 = s1.xmat;

indmat_fp = zeros(num_var*n_fpaths,3);
xmat_fp = zeros((num_var+1)*n_fpaths,30);

rmean_fp = zeros((num_var+1)*n_fpaths,tnum);
sig_fp = zeros((num_var+1)*n_fpaths,tnum);

dir1 = '/Users/srikanthpatala/Documents/Morris_Data/';
dir2 = [num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'/'];
dir = [dir1,dir2];


for ct1 = 1:n_fpaths
    ct1
    npath = full_paths(ct1);
    i1 = (npath-1)*num_var+1; i2 = npath*num_var;
    indmat_fp((ct1-1)*num_var+1:ct1*num_var,:) = indmat1(i1:i2,:); 
    
    i1 = (npath-1)*(num_var+1)+1; i2 = npath*(num_var+1);
    xmat_fp((ct1-1)*(num_var+1)+1:ct1*(num_var+1),:) = xmat1(i1:i2,:);
end




%%% Save xvals_fpaths.mat
mat_name = ['xvals_np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'_fp.mat'];
save('xvals.mat','xmat_fp','indmat_fp');


% %%% Save calc_vals_fpaths.mat
% for ct1 = 1:n_fpaths
%     ct1
%     npath = full_paths(ct1);
%     i1 = (npath-1)*num_var+1; i2 = npath*num_var;
%     indmat_fp((ct1-1)*num_var+1:ct1*num_var,:) = indmat1(i1:i2,:); 
%     
%     i1 = (npath-1)*(num_var+1)+1; i2 = npath*(num_var+1);
%     xmat_fp((ct1-1)*(num_var+1)+1:ct1*(num_var+1),:) = xmat1(i1:i2,:); 
%     
% %     for nvar = 1:(num_var+1)
% %         res_id = (npath-1)*(num_var+1) + nvar;
% %         fstr = [dir,'res_',num2str(res_id)];
% %         fileID = fopen(fstr,'r');
% %         C = textscan(fileID,'%f %f %f');
% %         c_t = C{1}; t_rmean = C{3}; t_sig = C{2};
% %         ind1 = (ct1-1)*(num_var+1) + nvar;
% %         rmean_fp(ind1,:) = t_rmean;
% %         sig_fp(ind1,:) = t_sig;
% %     end
% end
