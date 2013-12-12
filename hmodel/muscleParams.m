% **************** %
% MUSCLE MECHANICS %
% **************** %

% -------------------------------
% Shared Muscle Tendon Parameters
% -------------------------------

% excitation-contraction coupling
preA =  0.01; %[] preactivation
tau  =  0.01; %[s] delay time constant

% contractile element (CE) force-length relationship
w    =   0.56; %[lopt] width
c    =   0.05; %[]; remaining force at +/- width

% CE force-velocity relationship
N    =   1.5; %[Fmax] eccentric force enhancement
K    =     5; %[] shape factor

% Series elastic element (SE) force-length relationship
eref =  0.04; %[lslack] tendon reference strain




% --------------------------
% Muscle-Specific Parameters
% --------------------------

% vasti muscles
FmaxVAS    = 300;%6000; % maximum isometric force [N]
loptVAS    = 0.13;%0.08; % optimum fiber length CE [m]
vmaxVAS    =   12; % maximum contraction velocity [lopt/s]
lslackVAS  = 0.23; % tendon slack length [m]


% ---------------------
% 1.6 Joint Soft Limits
% ---------------------

% angles at which soft limits engages
phi23_UpLimit  = 155*pi/180; %[rad]
% soft block reference joint stiffness
c_jointstop     = 0.3 / (pi/180);  %[Nm/rad]
% soft block maximum joint stop relaxation speed
w_max_jointstop = 1 * pi/180; %[rad/s]


% VAStus group attachement
rVAS       =       0.03; % [m]   constant lever contribution 
phimaxVAS  = 90*pi/180; % [rad] angle of maximum lever contribution (From http://elibrary.rajavithi.go.th/homelibrary/EBook_data/page29/Operative%20Elbow%20Surgery/3.pdf)
phirefVAS  = 60*pi/180; % [rad] reference angle at which MTU length equals 
rhoVAS     =        3;;%0.7; %       sum of lopt and lslack 