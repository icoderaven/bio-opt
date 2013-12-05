function [ cost] = evaluate_cost( torque_trajectory , target,lambda, step_interval, ref_taus, input_trajectory_name)
%EVALUATE_COST Evaluate the cost of following the particular trajectory
%use only mid points - every step_interval ms
%Use a time series
%Linearly interpolate between provided points
ts = ref_taus;
torque_trajectory= reshape(torque_trajectory, numel(torque_trajectory)/3,3);
ts.signals.values = interp1(ts.time(1:step_interval:end), torque_trajectory, ts.time, 'pchip');

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

end_pos.signals.values(end, :)
if size(taus.signals.values,1) < size(ref_taus.signals.values,1)
    display '!'
    cost = 1e13*norm(size(taus.signals.values,1) - size(ref_taus.signals.values,1));
else
    angles = trajectory.signals.values;
    positions = end_pos.signals.values;
    dt = ts.time(2) - ts.time(1);
    
    %Find the derivative of the commanded torques
    us = diff(taus.signals.values)./dt;
    
    %Expressing the cost function as
    % u'*u + \lambda*||x_f - x(t_f) \\_2 + \psi ||v(t_f)||
    u_val = us.^2;
%     lambda*norm(end_pos.data(end,:) - target)
%     lambda * norm(positions(end,:) - positions(end-1,:))/dt
%     sum(u_val(:))
    cost = sum(u_val(:)) + lambda*norm(end_pos.signals.values(end,:) - target) + lambda * norm(positions(end,:) - positions(end-1,:))/dt;
    
end
end
