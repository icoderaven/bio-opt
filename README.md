bio-opt
=======

A class project to optimize the trajectory for a reaching task for a simple three DoF human arm

---

Investigates what trajectory would be obtained by minimizing the rate of change of torque in getting an arm to a specific target position. This is attempted by using a Simulink model of the arm, that is first moved using a PD controller to roughly the desired position and then using midpoints in this trajectory to optimize a cost function determined as 

 u'*u + \lambda*||x_f - x(t_f) \\_2 + \psi ||v(t_f)||
 
 where u is the rate of change of torque, x_f is the target location, and x and v are trajectory functions.

-----

arm_model.slx contains the generic kinematic arm model that takes in a three term time series of torques and actuates the joints as per theses. The time period between every consecutive entry should be 0.005 seconds. This model is simulated for evaluating the cost function

arm_model_pid.slx contains the same mechanism, but actuated by PD controllers

arm_muscle.slx is the analogue of arm_model but with the forearm actuated by a time series of stimulation trajectories. This file is called in the evaluate_neuro_cost methof

bi_muscle.slx is the arm_model with two muscles actuating the arm. This is currently very buggy.

init_param.m initializes the parameters for the models. This needs to be run before running any model.

call_*.m are scripts that set up the solvers and try to minimize the objective functions. The ones useefull are call_nlopt.m, call_nomad.m, find_best_lower_arm.m (for the muscle actuated version. Note that this currently gets stuck during minimization)

convert_to_torque_trajectories is a helper script to take a keypoint trajectory and convert it into a complete torque_trajectories to be used in arm_model

init.m was an initial attempt at using openRAVE instead of Simulink. The data folder contains the OpenRAVE XML file corresponding to the arm linkage
