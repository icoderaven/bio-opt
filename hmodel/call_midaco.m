%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     This is an Example Call of MIDACO 4.0
%     -------------------------------------
%
%     Author(C): Dr. Martin Schlueter           
%                Information Initiative Center,
%                Division of Large Scale Computing Systems,
%                Hokkaido University, Japan.
%
%        Email:  info@midaco-solver.com
%        URL:    http://www.midaco-solver.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clear all; clear mex; clc;
  init_param;
 sim('arm_model_pid');
 torque_trajectories = taus;
lambda = 10^9;
% psi = 10^3;
step_interval = 75;
%Send this to fminsearch (booyeah)
options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);

seed_traj = taus.data(1:step_interval:end,:);
ub = 200*ones(size(seed_traj));
lb = -200*ones(size(seed_traj));
ref_taus = taus;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Specify MIDACO License-Key
  key = 'MIDACO_LIMITED_VERSION___[CREATIVE_COMMONS_BY-NC-ND_LICENSE]';  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Problem definition     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1.A : Define name of problem function (by function handle symbol '@')
  problem.func = @(x) evaluate_cost(x, target, lambda, step_interval, ref_taus); % Call is: [f,g] = problem_function(x) 
  
% Step 1.B : Define problem dimensions
  problem.n  = numel(seed_traj); % Number of variables (in total)
  problem.ni = 0; % Number of integer variables (0 <= nint <= n)
  problem.m  = 0; % Number of constraints (in total)
  problem.me = 0; % Number of equality constraints (0 <= me <= m)
     
% Step 1.C : Define lower and upper bounds 'xl' and 'xu' for 'x'
  problem.xl   = reshape(lb, numel(lb), 1);
  problem.xu   = reshape(ub, numel(ub), 1); 

% Step 1.D : Define starting point 'x'
  problem.x  = reshape(seed_traj, numel(seed_traj),1); % Here for example: 'x' = lower bounds 'xl'
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: Choose stopping criteria and printing options    %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 2.A : Decide maximal runtime by evalution and time budget
  option.maxeval  = 80000;  % Maximum number of function evaluation (e.g. 1000000)
  option.maxtime  = 60*60*24; % Maximum time limit in Seconds (e.g. 1 Day = 60*60*24)

% Step 2.B : Choose printing options
  option.printeval  = 80;   % Print-Frequency for current best solution (e.g. 1000)
  option.save2file  = 1;      % Save SCREEN and SOLUTION to TXT-files [ 0=NO/ 1=YES]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: Choose MIDACO parameters (ONLY FOR ADVANCED USERS)    %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  option.param(1) =  0;  %  ACCURACY      (default value is 0.001)
  option.param(2) =  0;  %  RANDOM-SEED   (e.g. 1, 2, 3,... 1000)
  option.param(3) =  0;  %  FSTOP
  option.param(4) =  0;  %  AUTOSTOP      (e.g. 1, 5, 20, 100,... 500) 
  option.param(5) =  0;  %  ORACLE 
  option.param(6) =  0;  %  FOCUS         (e.g. +/- 10, 500,... 100000) 
  option.param(7) =  0;  %  ANTS          (e.g. 2, 10, 50, 100,... 500)
  option.param(8) =  0;  %  KERNEL        (e.g. 2, 5, 15, 30,... 100) 
  option.param(9) =  0;  %  CHARACTER
  
% Note: The default value for all parameters is 0.   
%       See the MIDACO User Manual for more details.  

  option.parallel = 1; % Define the MIDACO parallelization factor 'P'
                       % If option.parallel <= 1   ---> MIDACO runs in serial mode
                       % If option.parallel >= 2   ---> MIDACO runs in parallel mode

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Call MIDACO solver   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [ solution ] = midaco( problem, option, key);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   End of Example    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

