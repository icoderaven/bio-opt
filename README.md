bio-opt
=======

A class project to optimize the trajectory for a reaching task for a simple three DoF human arm

---

Investigates what trajectory would be obtained by minimizing the rate of change of torque in getting an arm to a specific target position. This is attempted by using a Simulink model of the arm, that is first moved using a PD controller to roughly the desired position and then using midpoints in this trajectory to optimize a cost function determined as 

 u'*u + \lambda*||x_f - x(t_f) \\_2 + \psi ||v(t_f)||
 
 where u is the rate of change of torque, x_f is the target location, and x and v are trajectory functions.
