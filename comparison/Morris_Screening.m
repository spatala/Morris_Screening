% Morris Screening
% rewritten by Yinkai Lei @ NELT, email: yinkai.lei@netl.doe.gov
% Morris_Screening - main code for Morris Screening
% morris - generate path for morris screening
% funeval - evaluate functions at each point
% derive - evaluate the derivatives (element effects)

function [Mu Sig]=Morris_Screening(ifun, nparams, ntraj, delta)

    [xmat, indmat] = morris(nparams, ntraj, delta);

    fval = funeval(ifun, xmat, indmat);

    dfval = derive(fval, indmat, nparams, ntraj, delta);
   
    Mu = mean(abs(dfval), 1);

    Sig = std(dfval, 1);
       
end

function [xmat, indmat] = morris(k, r, delta)
% function [xmat, indmat] = morris(k,p,r)
%[MU SIGMA] = MORRIS(K,P,R)
% Method of Morris.
% Max D. Morris. 1991.
% ?Factorial Sampling Plans for Preliminary
% Computational Experiments.?
% Technometrics 33:161-174
%
% Input:
% k         : Number of variables (dimensions).
% r         : Number of paths.
% delta     : Bin-size
% p         : Number of bins, i.e. discretization of
%             scaled variable in the interval [0,1].
%
% Output:
% xmat      : Array of size `r(k+1) x k`. Defines the paths.
% indmat    : Array of size `r(k+1) x 3`.
%             Used to compute derviatives.
%

   % Get the delta value
   % delta = p/2/(p-1);
   % delta = 1/(p-1);
   p = 1/delta + 1;
   
   % Initial sample matrix B, (k+1,k),
   % strictly lower triangular matrix of 1's.
   B = tril(ones(k+1,k),-1);
   
   % Matrix J, (k+1,k) matrix of 1's.
   Jk = ones(k+1,k);
   
   % Get the set of x values, [0,1-delta].
   % xset = 0:1/(p-1):1-delta;
   xset = 0:delta:1-delta;
   
   % Initialize the elementary effects to zero.
   indmat = []; xmat = [];
   % Generate input data matrix.
   for i=1:r
       % Get the matrix D*, k-dimensional
       % diagonal matrix in which each
       % nonzero element is either +1 or
       % -1 with equal probability.
       Dstar = diag(sign(rand(k,1)*2-1));
       % Get matrix P*, (k,k) random
       % permutation matrix in which each
       % column contains one element equal to 1 and all others equal to 0 and
       % no two columns have 1s in the same position.
       I = eye(k);
       Pstar = I(:,randperm(k));
       % Get vector x*, k-dimensional ?base value?
       % of X. Elements are randomly drawn from
       % the allowed set.
       %     xstar = xset(ceil(rand(k,1)*floor(p/2)));
       xstar = xset(ceil(rand(k,1)*floor(p-1)));
   
       % Get matrix B*, (k+1,k) orientation matrix.
       % One elementary effect per input.
       Bstar = (Jk(:,1)*xstar+(delta/2)* ...
           ((2*B-Jk)*Dstar+Jk))*Pstar;
       % i?th component has been decreased by delta.
       [idec,jdec] = find(Dstar*Pstar<0);
       % i?th component has been increased by delta.
       [iinc,jinc] = find(Dstar*Pstar>0);
       % Build up an index matrix.
       indmat = [indmat;jdec idec idec+1; ...
           jinc iinc+1 iinc];
       % Store the x-values.
       xmat = [xmat;Bstar];
   end
end 

function fv = funeval(ifun, xmat, indmat)
% calculate function value along the trajectories
% Ouput: fv - function value matrix
% Input: ifun - function to calculate values
%        xmat - position matrix of trajectories
%        indmat - index matrix of trajectories
   fv=[];
   parfor i=1:size(xmat,1)
       x0 = xmat(i,:);
       v = ifun(x0);
       fv = [fv; v];
   end
end

function dv = derive(fv, indmat, nparams, ntraj, delta)
% calculate derivative functions along the trajectories
% Ouput: dv - derivative of function matrix
% Input: fv - function value matrix
%        indmat - index matrix of trajectories
%        nparams - number of parameters
%        ntraj - number of trajectories
%        delta - increment of parameters
   dv=[];
   fs=0;
   is=0; 
   for i=1:ntraj
       ff = fv(fs+1:fs+nparams+1, :);
       ind = indmat(is+1:is+nparams, :);

       ee = zeros(nparams, size(ff,2));
       ee(ind(:,1), :) = (ff(ind(:,2),:)-ff(ind(:,3),:))/delta;
       
      
       dv = [dv ; reshape(ee, [1 prod(size(ee))])]; 

       fs=fs+nparams+1;
       is=is+nparams;
   end
end 

