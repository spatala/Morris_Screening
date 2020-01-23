%%
%  INTEGRATE THE SYSTEM USING 'ode45.m'* 
%  *NOTE: ODE45 IS BEST FOR NONSTIFF PROBLEMS AND OFFERS MEDIUM LEVEL OF ACCURACY ACCORDING TO
%  'https://www.mathworks.com/help/matlab/math/choose-an-ode-solver.html'
%=========================================================================>

  %SOLVES DERIVATIVE OF DEPENDENT VARIABLE 'Y' WITH RESPECT TO INDEPENDENT VARIABLE 't'
  function [t,Y] = hackathon_ode(inparams) 

  unm = unnormalize(inparams); %CALLS FUNCTION 'unnormalize.m' AND RETURNS VARIALBE 'unm' 

  filename = 'Hackathon/data/anode_0.5_0.13_1.txt'; %FILENAME OF DESIRED DATASET
  data = load(filename); %DATASET

  time_step = 500;
  t_data = data(:,1); %TIME DATA FROM GIVEN DATASET
  t_dense = linspace(min(t_data), max(t_data), time_step); %ODE SOLVER INTEGRATES OVER TIME INTERVAL WITH '500' DATA POINTS
  
  %step_i = 1e-4; %INTITIAL STEP SIZE FOR ODE SOLVER
  step_f = 1e-1; %MAXIMUM VALUE FOR STEP SIZE FOR ODE SOLVER
  
%=========================================================================>
%  SET THE INITIAL CONDITIONS

  R0 = 0.5778; %INITIAL VALUE FOR MEAN

  sigma0 = 0.1734; %INITIAL VALUE FOR VARIANCE
  
  Y0 = [R0; sigma0]; % INITIAL CONDITIONS FOR ODE SOLVER
  
  
  ode_options = odeset('RelTol',1e-6,'AbsTol',1e-6,'Stats','on',...
      'MaxStep',step_f,'NormControl','on',...'InitialStep',step_i,
      'NonNegative',2,'OutputFcn','odeplot'); %SET RELATIVE TOLERANCE OF ODE SOLVER 
  %ODE solver 'Refine' does not apply when 'length(tspan)>2%
  %ODE solver "'NonNegative',1" instructs that the first component be
  %nonNegative e.g. mean value 'A' will cannot be negative
  %ODE solver 'NormControl' defines error relative to the norm of the solutions (does not undo 'unnormalize' because that is based on the input and not the output) and not its absolute value 

%=========================================================================>
%  VARIABLES FED INTO FUNCTION 'OstRip.m'
 
  %R_g = 8.3145;
  T=1000;
  Ry_UN = 0.5;
  Sy_UN = 0.2;
  fNi=0.5;
  fY=0.13;

%=========================================================================>
%  SOLVE DIFFERENTIAL EQUATIONS
  
  %EACH ROW IN SOLUTION ARRAY 'Y' CORRESPONDS TO A VALUE RETURNED IN COLUMN VECTOR 't'
  [t,Y] = ode23t(@(t,y) OstRip(unm, y, T, Ry_UN, Sy_UN, fNi, fY, t), t_dense, Y0, ode_options); 
  

  
end