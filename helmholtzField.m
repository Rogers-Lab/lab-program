function [field] = helmholtzField(zdistance, radius, numberTurns,current,diameterWire)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
field = 0;
radius = radius*10^-3;
zdistance = zdistance*10^-3;
diameterWire = diameterWire*10^-3;
for n = 1:size(numberTurns)
    radiusAvg = ((radius - (diameterWire/2)) + radius + (diameterWire/2))/2;
    radiusUsed = radiusAvg*(1-((diameterWire/2)/radiusAvg)^2);
        
    field = field + ((4*pi*10^-7)*(numberTurns(n)*(current)*(radiusUsed^2))/(2*(zdistance^2 + radiusUsed^2)^(3/2)) + ((4*pi*10^-7)*(numberTurns(n))*(current)*(radiusUsed^2))/(2*((radius-zdistance)^2 + radiusUsed^2)^(3/2)));
        
    radius = radius + (diameterWire);
end
field = field*10^3;
fprintf('Units are in militesla\n');
end