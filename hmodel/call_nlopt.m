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

%Call nlopt now
opt.algorithm = NLOPT_GN_DIRECT_L;
opt.min_objective = @(x) evaluate_cost(x, target, lambda, step_interval, ref_taus);
opt.lower_bounds = reshape(lb, numel(lb), 1);;
opt.upper_bounds = reshape(ub, numel(ub), 1);

%perform the optimization
[xopt, fmin, retcode] = nlopt_optimize(opt,reshape(seed_traj, numel(seed_traj),1));