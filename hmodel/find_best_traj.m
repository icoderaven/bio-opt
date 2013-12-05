%Given a seed trajectory, find the trajectory that gets to the destination
%point with minimum cost with the cost function given in evaluate_cost.m

%Get a reference trajectory from the PID controller
init_param;
 sim('arm_model_pid');
 torque_trajectories = taus;
lambda = 10^9;
% psi = 10^3;
step_interval = 75;
%Send this to fminsearch (booyeah)
options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);
ub = 200*ones(1000/step_interval,3);
lb = -200*ones(1000/step_interval,3);
seed_traj = taus.data(1:step_interval:end,:);
ref_taus = taus;
% seed_traj = zeros(11,3);
best_traj = fminsearch(@(x) evaluate_cost(x, target, lambda, step_interval, ref_taus), seed_traj, options)