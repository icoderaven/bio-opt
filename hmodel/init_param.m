clear all;

%Mass and lengths of upper arm and forearm resp.
m1 = 1.9;
m2 = 1.5;
g = 9.81;

L1 = 0.28;
L2 = 0.32;
target  = [0.5,0,0];


dest = find_ik_solution(target,[L1,L2]);

%Call muscle parameters
muscleParams;
% sim('arm_model_pid');  
