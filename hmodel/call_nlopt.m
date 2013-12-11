init_param;
sim('arm_model_pid');
torque_trajectories = taus;
lambda = 10^9;
% psi = 10^3;
step_interval = 75;
%Send this to fminsearch (booyeah)
options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);
seed_traj = taus.data(1:step_interval:end,:);
x0 = reshape(seed_traj, numel(seed_traj),1);
ub = 200*ones(size(x0));
lb = -200*ones(size(x0));
ref_taus = taus;
opt.algorithm = NLOPT_GN_DIRECT_L;
opt.min_objective = @(x) evaluate_cost(x, target, lambda, step_interval, ref_taus);
opt.lower_bounds = lb;
opt.upper_bounds = ub;
results = cell(100);
new_x0s = cell(100);
for i=1:numel(results)
    cost = 1e16;
    %Check if this is a valid seed!!!!
    while cost>1e13
        new_x0 = x0 + 10*randn(numel(x0),1);
        new_x0(new_x0>200) = 200;
        new_x0(new_x0<-200) = -200;
        cost = evaluate_cost(new_x0, target, lambda, step_interval, ref_taus);
    end
    new_x0s{i} = new_x0;
    %perform the optimization
    [xopt, fmin, retcode] = nlopt_optimize(opt,new_x0);
    results{i,1} = best_traj;
    results{i,2} = fval;
end