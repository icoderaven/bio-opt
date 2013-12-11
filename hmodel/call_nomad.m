init_param;
sim('arm_model_pid');
torque_trajectories = taus;
lambda = 10^9;
% psi = 10^3;
step_interval = 75;
%Send this to fminsearch (booyeah)
seed_traj = taus.data(1:step_interval:end,:);
x0  = reshape(seed_traj, numel(seed_traj),1);
ub = 200*ones(size(x0));
lb = -200*ones(size(x0));
ref_taus = taus;


fun =   @(x) evaluate_cost(x, target, lambda, step_interval, ref_taus);

min_fval = 1e12;

results = cell(100);
for i=1:100
    new_x0 = x0 + 10*randn(numel(x0),1);
    new_x0(new_x0>200) = 200;
    new_x0(new_x0<-200) = -200;
    % Build optiprob structure (intermediate structure)
    prob = optiprob('fun',fun,'bounds',lb,ub,'x0',new_x0);
    % Setup solver options
    opts = optiset('solver','nomad');
    nomad_options = nomadset( 'vns_search',0.8);%,'model_search',0);
    % Build OPTI objects
    Opt = opti(prob,opts,nomad_options);
    % Solve the GNLP problems
    [best_traj,fval] = solve(Opt, new_x0);
    results{i,1} = best_traj;
    results{i,2} = fval;
end