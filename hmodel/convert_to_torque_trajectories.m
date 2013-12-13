 step_interval = 75;
 sim('arm_model_pid');
 torque_trajectories = taus;
 torque_trajectories.data = interp1(taus.time(1:step_interval:end),  best_traj, taus.time, 'pchip');