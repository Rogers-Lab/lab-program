function [fieldTotal] = HelmholtzFieldCalculatorV2(numberTurns)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
diameterWireAWG1thru24 = [7.348,6.544,6.544,5.827,5.189,4.621,4.115,3.665,3.264,2.906,2.588,2.305,2.053,1.828,1.628,1.450,1.291,1.150,1.024,0.912,0.812,0.723,0.644,0.573,0.511];
fieldLayer = 0;
fieldTotal = 0;
gaugePrompt = 'What is the AWG gauge of the wire (1-24)? ';
diameterWire = diameterWireAWG1thru24(input(gaugePrompt))*10^-3;
currentPrompt = 'What is the current in Amps? ';
current = input(currentPrompt);
radiusCylinderPrompt = 'What is the radius of the cylinder in mm? ';
radius = input(radiusCylinderPrompt)*10^-3;
zDistPrompt = 'What distance from the center of the system to the edge of the coil? ';
zDistance = input(zDistPrompt)*10^-3;
for n = 1:size(numberTurns)
    
    radiusAvg = ((radius - (diameterWire/2)) + radius + (diameterWire/2))/2;
    radiusUsed = radiusAvg*(1-((diameterWire/2)/radiusAvg)^2);
    zIncrement = 0;
    for k = 1:numberTurns(n)
        fieldLayer = fieldLayer + ((4*pi*10^-7)*radiusUsed^2*current)/(2*((zDistance+zIncrement)^2+radiusUsed^2)^(3/2));
        zIncrement = zIncrement+diameterWire;
    end
    fieldTotal = fieldTotal + fieldLayer;
    radius = radius + (diameterWire);
end
fieldTotal = 2*(fieldTotal*10^3);
fprintf('Units are in militesla\n');
end