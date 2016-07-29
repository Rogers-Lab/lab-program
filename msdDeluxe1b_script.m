% function [ msd ] = msd(T)
TM=input('Tracking Matrix: ');
msd=[];
dtMax=max(TM(:,3)-1);
for dt=1:dtMax %Loop through time displacements
    fprintf('dt at %d out of %d\n',dt,dtMax)
    msd(dt,1)=dt;
    xsq = 0;
    ysq = 0;
    numTerms = 0;
    
    for t=1:dtMax-dt+1 %Loop through initial times
        m1=find(TM(:,3)==t); %All collumn indexes with time t
        m2=find(TM(:,3)==t+dt); %All collumn indexes with time t+dt
        [C,ia,ib]=intersect(TM(m1,4),TM(m2,4)); %Identify ID's that exist at both these times
        xsq=xsq+sum((TM(m1(ia),1)-TM(m2(ib),1)).^2); %Find x displacements, square, sum
        ysq=ysq+sum((TM(m1(ia),2)-TM(m2(ib),2)).^2); %Find y displacements, square, sum
        numTerms = numTerms + length(m1);
    end
    msd(dt,2)=(xsq+ysq)./numTerms; %Compute MSD
end

hold on
%conv=60/680;
%rate=25.004;
conv=1;
rate=1;
%Plot junk for fun
v.framerate; %frames per second
Rate=1/v.framerate; %seconds per frame
um2pix=60/680; %microns per pixel
x=(Rate)*msd(:,1);
y=(um2pix)*msd(:,2);
msdxy=[x,y];
scatter(x(:,1),y(:,1),'.')

maxf=ceil((size(msd,1))*Rate);
f01=ceil((size(msd,1)-1)*Rate)-1;
%scatter(msd(:,1)/rate,msd(:,2)*conv,'.')
%Add a fit to linear looking part for the hell of it

% pfit1=polyfit(x(1:f01,1),y(1:f01,1),1)
% plot([0,maxf],[0,maxf]*pfit1(1)+pfit1(2))
% 
% pfit2=polyfit(x(1:f01,1),y(1:f01,1),2)
% plot([0:maxf],[0:maxf].^2*pfit2(1)+[0:maxf]*pfit2(2)+pfit2(3))

pfit1=polyfit(x(:,1),y(:,1),1)
plot([0,maxf],[0,maxf]*pfit1(1)+pfit1(2))

pfit2=polyfit(x(:,1),y(:,1),2)
plot([0:maxf],[0:maxf].^2*pfit2(1)+[0:maxf]*pfit2(2)+pfit2(3))

xlabel('Lag time (Seconds)')
ylabel('MSD (Microns)')
title('Tracked Particle MSD, 0.05% w/v 2.4um diameter PS microbead, 15x obj, 1000 frames, 65C')
%ylim([0,1.1*max(msd(:,2))])
annotation('textbox',[0.2,0.7,.075,.15],'String',{'Fit line slope:',pfit1(1),'Quadratic coeficients:',pfit2})
hold off