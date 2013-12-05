function [thetas] = find_ik_solution(displacement, arm_lengths)
%Given a x,y,z location for the arm, first look at the out of plane rotation 
%required and then approach it as a standard 2 DoF IK problem


%X IS ALONG INITIAL DIRECTION!!! For simulink, this is along -ve y axis.
%Thus we need to rotate CW 90 degrees
displacement(1:2) = [-displacement(2) displacement(1)];



thetas = zeros(3,1);

%Now, since the arm is in the X-Y plane at 0 out of plane angle
thetas(3) = atan2(displacement(3),sqrt(displacement(1)^2 + displacement(2)^2));
if thetas(3) <0 
    error 'Negative theta_3!!!'
    return;
end

%Now we're just restricted to the 2D plane at this orientation

%The effective link lengths are now different
ll = arm_lengths.*cos(thetas(3));

%Check if the point is too far away
x = displacement(1);
y = displacement(2);
if (ll(1)+ll(2)) < sqrt(x^2+y^2)
    display 'Point not reachable!'
    return;
end
%Get the last angle
last_angles(1) = 2*atan2(sqrt( (ll(1) + ll(2))^2 - (x^2 + y^2)), sqrt( x^2+y^2 - (ll(1) -ll(2))^2) );
last_angles(2) = -last_angles(1);
%There are two solutions though, because of the square root inside.
%Therefore check both conditions
first_angles = atan2(y,x).*[1 1] - atan2(ll(2).*sin(last_angles), ll(1).*[1 1] + ll(2).*cos(last_angles));
%Check if out of range
if first_angles(1) > deg2rad(180) || first_angles(1) < deg2rad(-45) || last_angles(1) > deg2rad(150) || last_angles(1) < 0
    if first_angles(2) > deg2rad(180) || first_angles(2) < deg2rad(-45) || last_angles(2) > deg2rad(150) || last_angles(2) < 0
        error 'Joint limits prohibit solution!'
        
    end
    thetas(1:2) = [first_angles(2);last_angles(2)];
else
    thetas(1:2) = [first_angles(1);last_angles(1)];
end
end