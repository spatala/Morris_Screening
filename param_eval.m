clear all; clc;

%%%%%
% k: Number of parameters
% r: Number of paths
% p: Number of bins (p-1) from 0 to 1
k = 30; r = 2; p = 11; 

%%%%
% xmat - size (k) x (r*(k+1))
%      - Each row has values between 0 to 1
%      - Each row is a vector of values for all the k-parameters
%      (normalized)
xmat = morris(k,p,r);