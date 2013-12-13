function [ cost] = evaluate_cost( torque_trajectory , target,lambda, step_interval, ref_taus, input_trajectory_name)
%EVALUATE_COST Evaluate the cost of following the particular trajectory
%use only mid points - every step_interval ms
%Use a time series
%Linearly interpolate between provided points
ts = ref_taus;
torque_trajectory= reshape(torque_trajectory, numel(torque_trajectory)/3,3);
ts.data = interp1(ts.time(1:step_interval:end), torque_trajectory, ts.time, 'pchip');

if nargin==5
    input_trajectory_name='torque_trajectories';
    
end
if input_trajectory_name=='torque_trajectories'
    clear torque_trajectories
    torque_trajectories = ts;
    assignin('base', 'torque_trajectories', torque_trajectories);
elseif input_trajectory_name=='stim_trajectories'
    clear stim_trajectories
    stim_trajectories = ts;
end


%Simulate the model now
clear taus;
clear end_pos;
clear trajectory;
sim('arm_model');
%Penalize premature stopping REALLY high


%Get the data output from simulink
% trajectory = evalin('base', 'trajectory');
% end_pos = evalin('base', 'end_pos');

end_pos.data(end, :)
if size(taus.data,1) < size(ref_taus.data,1)
    display '!'
    cost = 1e16*size(taus.data,1)/norm(size(taus.data,1) - size(ref_taus.data,1));
else
    angles = trajectory.data;
    positions = end_pos.data;
    dt = ts.time(2) - ts.time(1);
    
    %Find the derivative of the commanded torques
    us = diff(taus.data)./dt;
    
    %Expressing the cost function as
    % u'*u + \lambda*||x_f - x(t_f) \\_2 + \psi ||v(t_f)||
    u_val = us.^2;
    %     lambda*norm(end_pos.data(end,:) - target)
    %     lambda * norm(positions(end,:) - positions(end-1,:))/dt
    %     sum(u_val(:))
    cost = sum(u_val(:)) + lambda*norm(end_pos.data(end,:) - target) + lambda * norm(positions(end,:) - positions(end-1,:))/dt;
    
end

%For safety to interruptions, store the called seed_traj in base workspace
last_best_cost = evalin('base', 'last_best_cost');
if cost<last_best_cost
    assignin('base', 'last_pooled_x', torque_trajectory);
    torque_trajectory
    assignin('base', 'last_best_cost', cost);
end

end
