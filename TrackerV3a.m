Im1='20160707_Image1.png';
Vid1='20160707-f6-45.avi';

File= input('File Name: ');
FrameStart= input('First Video Frame: ');
Frames= input('Final Video Frame: ');
fs=FrameStart;

%  Fold=zeros(100*Frames,3);
%  Objects=zeros(150,1);
 Datax=[];
 Datay=[];
 Datat=[];
 

v = VideoReader(File);
% while hasFrame(v)
%     video = readFrame(v);
% end
% whos videoVid
vidObj = VideoReader(File);
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

for n=FrameStart:Frames
    video=read(v,n);
   
%     s = struct(File,zeros(vidHeight,vidWidth,3,'uint8'),...'colormap',[]);

    %a=double(imread(video));
    a=video(:,:,1);
   %a = (a(:,:,1)+a(:,:,2)+a(:,:,3))/3;
%     colormap('gray'),imagesc(a(:,:,1));
    %whos a

    %a=-200+a;
    %a=55-a;
    %a=255-a;
      %colormap('gray'),imagesc(a);  axis equal

    b=bpass(a,1,23);
    %     gconv = conv2(image_array,gaussian_kernel,same);
    %     gconv = conv2(a,gaussian_kernel,same);
   % figure
%     colormap('gray'),image(b); axis equal
%     xlabel('Pixels (X-axis)')
%     ylabel('Pixels (Y-axis)')
%     title('Tracker Program, Test Video, Frame 1, Centroid Labeled Blue')

    pk = pkfnd(b,90,23);
    hold on
    
    cnt = cntrd(b,pk,15);
%     plot(pk(:,1),pk(:,2),'ro')
%     plot(cnt(:,1),cnt(:,2),'bo')
    max(max(b));
    
    %whos cnt
    % 
    % hist(mod(cnt(:,1),1),20);
    % 
    % tr= tracl(pos_lst,3);
    % track(cnt(:,1:2),20)
%     xy=cnt(:,1:2);
  
    %[X,Y]=cnt()
        Datax=[Datax;cnt(:,1)];
        Datay=[Datay;cnt(:,2)];
        Datat=[Datat;n*ones(size(cnt,1),1)];
   % folder=zeros(vidHeight,vidWidth,Frames);
   %folder=zeros(size(xy,1),foldsize(xy,2),Frames);
   %folder=zeros(500,2,Frames);
   
%    Fold=zeros(200,2,Frames);
%    for n=1:Frames
%        toto=[xy(:,1),xy(:,2)];
%         Fold(1:size(toto,1),1:size(toto,1),n)=toto;
%    end
% 
%        Fold(1:size(xy,1),1,n)=(xy(:,1));
%        Fold(1:size(xy,1),2,n)=(xy(:,2));
%        Fold(1:size(xy,1),3,n)=(n);
%        Objects(n)=(size(xy,1));
       
%200 is the max number of tracked objects
%2 is the number of columns for (x, y)

end
TheMatrix=[Datax,Datay,Datat];

param = struct('mem',20,'dim',2,'good',20,'quiet',0)
T=track(TheMatrix,40,param);

figure;
CM=hsv(max(T(:,4))); %colormap

%subplot(1,2,1);hold on
figure;hold on
%imagesc(A);colormap('gray');
for i=1:max(T(:,4))
    index=find(T(:,4)==i);
    plot(T(index,1),T(index,2),'.-','color',CM(i,:)); axis equal
end
xlabel('Pixels (X-axis)')
ylabel('Pixels (Y-axis)')
title('Tracker Program, Test Video, Tracked Object Trajectories')

g=[T(:,4),T(:,1),T(:,2),T(:,3)];

% plot(Objects)
max(Objects);
% Fold2=Fold(:,1:2,:);
% 
% Foldall=[];

OrderT=[];
Mx=[];
My=[];
Mt=[];

hold on
for n=1:(max(T(:,4)))
    kiwi=find(T(:,4)==n);
    C1=T(kiwi,1);
    C2=T(kiwi,2);
    C3=T(kiwi,3);
    C4=T(kiwi,4);
    S=size(kiwi,1);
    Group=[C1,C2,C3,C4];
    OGroup=T(kiwi,:);
    
    OrderT(1:S,:,n)=T(kiwi,:);
    x=OrderT(:,1,n);
    y=OrderT(:,2,n);
    t=OrderT(:,3,n);
    plot3(x,y,t,'o');
    
    Mx=[Mx;x];
    My=[My;y];
    Mt=[Mt;t];
    M=[Mx,My,Mt];
    
end

v.Framerate;

%for n=1:size(M
