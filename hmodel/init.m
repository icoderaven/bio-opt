clear all;
robotfile = '/home/icoderaven/CMU/BiomechanicsAndMotorControl/project/hmodel/data/human_arm.xml';
orEnvLoadScene('',1);
robotid = orEnvCreateRobot('robot',robotfile);
% bodies = orEnvGetBodies();
% celldisp(bodies);
% robotid = bodies{1}.id;
% robotname = 'human_arm';
manipid = orEnvCreateProblem('basemanipulation', 'human_arm')
probid = orEnvCreateProblem('ikfast');
s = orProblemSendCommand(['LoadIKFastSolver robot Translation3D'],probid);
manips = orRobotGetManipulators(robotid);
manipname = manips{1}.name;
orRobotSetActiveManipulator(robotid,manipname);

armdof = length(manips{1}.armjoints);
links = orBodyGetLinks(robotid);

Thand = reshape(links(:,manips{1}.eelink+1),[3 4]);
Tee = [Thand; 0 0 0 1]*[manips{1}.Tgrasp; 0 0 0 1];

orProblemSendCommand(['IKTest robot robot ikparam 855638019 0.2 0 0.3'], probid);

% orProblemSendCommand(['movetohandposition matrix ' sprintf('%f ',Tee(1:12))], manipid)

trajectory = orPlannerPlan(planner)