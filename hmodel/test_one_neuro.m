lambda = 10^5;
% psi = 10^3;
step_interval = 100;


%Send this to fminsearch (booyeah)
options = optimset('Display', 'iter', 'PlotFcns', @optimplotfval);
ub = 200*ones(1000/step_interval,3);
lb = -200*ones(1000/step_interval,3);
seed_traj = taus.data(1:step_interval:end,:);
% seed_traj = zeros(11,3);
best_traj = fminsearch(@(x) evaluate_cost(x, target, lambda, step_interval), seed_traj, options)