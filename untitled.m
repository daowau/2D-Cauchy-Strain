%% Input positions

% original
A = [0, 0];
B = [2, 0];
C = [0, 2];

% Deformed
Ad = [0, 0];
Bd = [2.2, 0];
Cd = [0, 2.4];

% axes angle in degrees
theta = 0; 

%% Prepare variables

% displacement matrix
M = [A(1), A(2), 1;
    B(1), B(2), 1;
    C(1), C(2), 1];

%% Calculate

% displacements
uA = Ad - A;
uB = Bd - B;
uC = Cd - C;

% separate displacements into x & y
ux = [uA(1); uB(1); uC(1)];
uy = [uA(2); uB(2); uC(2)];

% displacement coefficients
x = M \ ux;  
y = M \ uy;  

% deformation gradient
F = [1+x(1), x(2);
    y(1),   1+y(2)];

% polar decomposition
[U, S, V] = svd(F);
R = U * V';

% calculate angle
rotation_angle = atan2d(R(2,1), R(1,1));

% correct using angle
F_corrected = R' * F;

% calculate corrected strain tensor
epsilon = 0.5 * (F_corrected + F_corrected') - eye(2);

% rotate strain tensor if necessary
theta_radians = theta * pi/180
Q = [cos(theta_radians), -sin(theta_radians); sin(theta_radians), cos(theta_radians)]

epsilon_new = Q' * epsilon * Q;

%% Print results

disp("[ " + epsilon_new(1, 1) + " " + epsilon_new(1, 2) + " ]")
disp("[ " + epsilon_new(2, 1) + " " + epsilon_new(2, 2) + " ]")
