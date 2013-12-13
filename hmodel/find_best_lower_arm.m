init_param;
lambda = 10^9;
% psi = 10^3;


%Load the hand demonstrated trajectory
%First torque trajectories for the upper arm
load('init_lower_muscle.mat');
%Generate torque_trajectories
convert_to_torque_trajectories;
step_interval = 200;
%And now generate seed trajectory 
stim_trajectories = taus;
stim_trajectories.data = 0.05*ones(size(taus.time,1),1);
seed_traj = stim_trajectories.data(1:step_interval:end,:);

% seed_traj = taus.data(1:step_interval:end,:);
x0 = reshape(seed_traj, numel(seed_traj),1);
ub = 1*ones(size(x0));
lb = -1*ones(size(x0));
opt.algorithm = NLOPT_GN_DIRECT_L;
opt.min_objective = @(x) evaluate_neuro_cost(x, target, lambda, step_interval, stim_trajectories);
opt.lower_bounds = lb;
opt.upper_bounds = ub;
results = cell(100);
new_x0s = cell(100);
costs = cell(100);
for i=1:numel(results)
    cost = 1e16;
    %Check if this is a valid seed!!!!
    while cost>1e13
        new_x0 = x0+ 0.05.*randn(numel(x0),1);
        new_x0(new_x0>1) = 1;
        new_x0(new_x0<-1) = -1;
        cost = evaluate_neuro_cost(new_x0, target, lambda, step_interval, stim_trajectories);
    end
    costs{i} = cost;
    new_x0s{i} = new_x0;
end

%Find the min cost traj, use that as seed for minimization
index = min(costs);
x0 = new_x0s{index};
for i=1:numel(results)
    cost = 1e16;
    %Check if this is a valid seed!!!!
    while cost>1e13
        new_x0 = x0 + 0.05.*randn(numel(x0),1);
        new_x0(new_x0>1) = 1;
        new_x0(new_x0<-1) = -1;
        cost = evaluate_neuro_cost(new_x0, target, lambda, step_interval, stim_trajectories);
    end
    new_x0
    new_x0s{i} = new_x0;
    %perform the optimization
    [xopt, fmin, retcode] = nlopt_optimize(opt,new_x0);
    results{i,1} = best_traj;
    results{i,2} = fval;
end