clear all; clc;
%%%%%
num_var = 30; num_paths = 100000; delta = 0.1; tnum = 500;

dir1 = '/Users/srikanthpatala/Documents/Morris_Data/';
% dir2 = [num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'/'];
% dir = [dir1,dir2];
% dir1 = '/Users/patala/Desktop/Morris_Screening/output_100K_take2/';
dir2 = [num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'/'];
dir = [dir1, dir2];

IDs = zeros(num_paths*(num_var+1),1);
tol_max = 1e3;

n1_paths = num_paths;
ind_vals = sparse(n1_paths, num_var+1);

% ct_npaths = 0;
parfor npath = 1:n1_paths
%     npath
    for nvar = 1:(num_var+1)
        res_id = (npath-1)*(num_var+1) + nvar;
        % display(res_id);
        fstr = [dir,'res_',num2str(res_id)];
        if isfile(fstr)
            % display(fstr)
            fileID = fopen(fstr,'r');
            C = textscan(fileID,'%f %f %f');
            c_t = C{1}; t_rmean = C{3}; t_sig = C{2};
            fclose(fileID);
            
            ind1 = find(isnan(t_sig) | t_sig<0);
            
            if ((numel(ind1) > 0) || (numel(c_t) < 500))
                ind_vals(npath, nvar) = 1;
                % npath
                break;
            else
                % if ((mean(t_sig)>tol_max) || mean(t_rmean)>tol_max)
                if ((any(t_sig>tol_max)) || any(t_rmean>tol_max))
                    ind_vals(npath, nvar) = 1;
                    break;
                end
            end
        else
            ind_vals(npath, nvar) = 2;
%             ct_npaths = ct_npaths + 1;
            break;
        end
    end
end

ind_paths = zeros(n1_paths,1);
for ct1=1:n1_paths
    ind_paths(ct1) = ~(any(ind_vals(ct1,:)));
end

size(find(ind_paths))
full_paths = find(ind_paths);
mat_name = ['np_',num2str(num_paths),'_binsz_',num2str(delta,'%5.4f'),'_pathIDs.mat'];
save(mat_name, 'full_paths');