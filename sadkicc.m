function sadkicc()

%ADD RELEVENT DIRECTORIES TO MATLAB SEARCH PATH
addpath(genpath('morris_screening/mat_npaths_1000/')); %PATH TO '*.mat' FILES
addpath(genpath('Hackathon/data/')); %PATH TO TIME VARIABLES USED IN 'hackathon_ode.m'

for ii = 1:10

bin_01 = load(['morris_screening/mat_npaths_1000/np_10000_binsz_0.01/xvals_np_1000_binsz_0.0100_tot_num_10000_' num2str(ii) '.mat']);
bin_1 = load(['morris_screening/mat_npaths_1000/np_10000_binsz_0.1/xvals_np_1000_binsz_0.1000_tot_num_10000_' num2str(ii) '.mat']);

%s0 = bin_01;
%s1 = bin_1;
%s1=load('xvals.mat');

xmat = bin_01.xmat;
xmat1 = bin_1.xmat;

% Number of parameters
k = size(xmat,2);
% Number of paths
r = size(xmat,1)/(k+1);

parfor i=1:2%size(xmat,1)

    file = sprintf('res_%d',i);
    x0 = xmat(i,:);
    [t,Y] = hackathon_ode(x0);
    %myFile = fullfile('output','mat_npaths_1000','np_10000_binsz_0.01',int2str(ii),file); 
    myFolder = cd(['output/mat_npaths_1000/np_10000_binsz_0.01/' int2str(ii)]);
    dlmwrite(file, [t Y], ' ')
    
    cd(myFolder)
    
    x1 = xmat1(i,:);
    [t,Y] = hackathon_ode(x1);
    %myFile = fullfile('output','mat_npaths_1000','np_10000_binsz_0.1',int2str(ii),file);   
    myFolder = cd(['output/mat_npaths_1000/np_10000_binsz_0.1/' int2str(ii)]);
    dlmwrite(file, [t Y], ' ')
  
    cd(myFolder)
end
end
    zip('output.zip','output/mat_npaths_1000');
end
