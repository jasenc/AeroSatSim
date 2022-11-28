%% DSMC Simulation for LEO CubeSat using MATLAB
clear

%% Constants
R = 250000; %m altitude of orbit
G = 6.67e-11; %m^3/(kg*s^2) gravitational constant
Me = 5.9742e24; %kg mass of earth
Re = 6387100; %m radius of earth
MEWe = G*Me; % standard graviational parameter for earth
Msat = 1.33; %kg mass of satellite
Rsat = Re + R; %m radius of CubeSat orbit from center of earth
Vsat = sqrt(MEWe/Rsat); %Initial orbital velocity
E = Vsat^2/2-MEWe/Rsat; %Energy of the satellite
P = 2*pi*sqrt((Rsat)^3/MEWe); %Period of the satellite for one orbit
deltaT = 0.001; %s change in time for calculation of impulse equation
rho = (5.94e-08); %g/m^3 mass of particles found at 250km
PartTot = 1.7e15; %number of particles found at 250km per m^3
Mpart = rho/PartTot; %average mass of a particle at 250km
AreaS = 100/10000; %area of typical CubeSat in m^3
MperS = rho*(AreaS)*Vsat; %mass of particles hitting satellite per second
MdT = MperS*deltaT; %mass of particles hitting satellite per deltaT
SatDist = 2*pi*Rsat; %circumference of the satellite's orbit
s = 100; %sampling rate
%% Nose Cones
reply = input('Press 1 for no nose cone, 2 for a half cylinder, 3 for a double wedge,\n      or 4 for a revolving four sided CubeSat or 5 for on corner \n     ');
if reply == 1
    alpha = 90*(pi/180); %radians angle between sat and x-axis
elseif reply == 2
    alpha = 0;
elseif reply == 3
    alpha = 32*(pi/180); %radians angle between sat and x-axis 
elseif reply == 4
    disp(' ')
    disp('This is strictly a best case scenerio for a worst case orientation.')
    disp('Meaning I do not account for particles being trapped inside the wedges.')
    AreaS = 1.707*AreaS; %This design has 2.8 times more surface area
    %because there are now four double wedges, they stick out on either
    %side. Because we are looking at this from a corner, and the wedge's
    %are 10cm long by 10 cm wide, the overall width of the satellite 
    %becames sqrt(200)+sqrt(200) = 28.28 whereas the single nose cone is
    %simply 10cm wide.
    MperS = rho*(AreaS)*Vsat;
    MdT = MperS*deltaT;
    %So now we need to have this question "If a particle hits a 30 degree
    %slope at a 45 degree angle, what angle does the particle experience?"
    %Well, we know that the angle of the wedge is 30 degrees and we know
    %that the angle the particle is incoming is 45 degrees, so if we
    %multiply 30*sin(45) we get the angle the particle will experience 
    %along the axis parallel to the flow of the free molecules.
    alpha = ((45+2*(30*sin(pi/4)))/3); %Averages the corner angle along 
    %with the two angles from the wedges that are now in view. Need to fix 
    %the 64
    alpha = alpha*(pi/180); %average radians angle between sat and x-axis
elseif reply == 5
    AreaS = (((7.07*7.07)*3)/100)*AreaS;
    MperS = rho*(AreaS)*Vsat;
    MdT = MperS*deltaT;
    alpha = ((45+2*(45*sin(pi/4)))/3);
    alpha = alpha*(pi/180);
end
%% Calculations
i = 0;
Ftot = 0;
Vsati = Vsat;
dT = P/s; %Period divided by sampling rate
while i < dT
    i = i + deltaT;
    if reply == 2
        beta = normrnd(0,3.3333333,1)*(pi/180); %radians randomly generated
        %number from a normal distribution to calculate beta - the angle
        %between the incoming particle and the x-axis
        alpha = randi(90)*(pi/180);
    else
        beta = normrnd(0,3.3333333,1)*(pi/180); %radians randomly generated
        %number from a normal distribution to calculate beta - the angle
        %between the incoming particle and the x-axis
    end
    Vpart = 1150; %m/s randomly generated number
        %from a normal distribution to calculate the velocity of the 
        %incoming particle
    v1 = [Vpart*cos(beta);Vpart*sin(beta)]; % Vpart needs to be randomized 
    theta = alpha + beta; %radians angle of incidence
    phi = 2*pi - 2*theta;
    Rot = [cos(phi) -sin(phi);sin(phi) cos(phi)]; %rotational matrix
    v2 = Rot*v1;
    deltaVpart = v2-v1; %m/s change in velocity of particle from impact
    deltaV = deltaVpart(1);
    F = (MdT*abs(deltaV))/deltaT; % force from impulse
    deltaVsat = (F*deltaT)/(Msat); % change in velocity from impact
    % figure out two dimensional perfectly elastic collision
    Vsat = Vsat - abs(deltaVsat); %m/s new sat velocity
    Ftot = Ftot + F; %the total force over the given period
end
dVsat = Vsati - Vsat;

%% Caluclating the lifespan of the satellite
dx = SatDist/s;
t = 0;
while R > 100
    dE = (Ftot)*(dx); %Calculates the energy of the sate after one interval
    E = E - dE; %Find the new over energy
    V = Vsati - dVsat; %the current velocity
    R = MEWe/(V^2/2-E); %the new range
    t = t + dT; % the time the satellite lasted in seconds
end 
t/(3600*24) %prints the number of days to the screen