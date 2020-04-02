%Take input video of snake robot and auto-output 500-point body spline
% clear all
clear
close all
clc

com = true;

disps=false;
pad = true;

wID = 'MATLAB:polyfit:RepeatedPointsOrRescale';
warning('off',wID);
wID2 = 'images:initSize:adjustingMag';
warning('off',wID2);
marking = true;
timing = false;

dirname = 'E:\scattering\sandvscarpet\rug_tests_070616\gray';
cd(dirname); 
dest = [dirname '\outs'];

if ~exist( dest ,'dir')
    mkdir(dest)
end



list = dir(strcat(dirname,'\*.avi'));     % was '\*.mat', hope this works for avi videos
numFiles = size(list,1);
complete = {};
totalTime = tic;
for ii=1:numFiles;
    FileName = list(ii).name;
    Obj = VideoReader(FileName);
nFrames = Obj.NumberOfFrames;

snum  = str2double(strtok(FileName,'_'));
switch snum
    case 21
        corn = true;
    case 22 
        corn = true;
    otherwise 
        corn = false;
end
if snum>117 && snum<133
   chion = true;
else
    chion = false;
end

vidyes=1;

if strcmp(FileName(end-5:end-4),'_t')
FileName(end-5:end-4)='';
elseif strcmp(FileName(end-6:end-4),'_th') || strcmp(FileName(1:end-3),'_tr')
FileName(end-6:end-4)='';
elseif strcmp(FileName(end-10:end-4),'_thresh')
FileName(end-10:end-4)='';
end

if vidyes==1
    if marking == true
    FileName2=strrep([dest, '\', FileName],'.avi','_splineout_marked.avi');
%     FileName2=strrep(FileName,'.xvid','_splineout');
    else
         FileName2=strrep([dest, '\', FileName],'.avi','_splineout.avi');
    end
    writerObj = VideoWriter(FileName2,'Uncompressed AVI');
    open(writerObj);
end 
%dstore(1:1080,1:1920,1:nFrames)=0;
tic
lengthError = zeros(1,nFrames-1);
for k = 1 : nFrames-1
    clearvars -except FileName FileName2 pad chion snum disps numP extra corn nFrames tottime timing dest elapsed dirname list numFiles MS complete totaltime Obj PathName ii writerObj k MS vidyes dstore totalTime tottime marking lengthError
    try
    A=read(Obj,k);
    thresh=graythresh(A)/2;
    B=im2bw(A,thresh);
    B=imcomplement(B);
    if pad
        padsize = [100 100];
    B = padarray(B,padsize);
    end
    B = imfill(B,'holes');
    B=bwmorph(B,'majority',100);
    if snum==22 
    B=bwmorph(bwmorph(B,'dilate',7),'erode',6);
    se = strel('disk',12);  
    elseif strcmp('4s',FileName(5:6))
    B=bwmorph(bwmorph(B,'dilate',4),'erode',6);
    se = strel('disk',10);    
    elseif snum<133 && snum>119                      %CHIONACTIS
     B=bwmorph(bwmorph(B,'dilate',20),'erode',17);
    se = strel('disk',10); 
    else  
        
    B=bwmorph(bwmorph(B,'dilate',1),'erode',5);
    
    se = strel('disk',1);        %%%%%%%%% was 10
    end
    B = imclose(B,se);
    L = bwlabel(B);
    stats=regionprops(L,'Area','BoundingBox');
    [c,i]=max([stats.Area]);
    a=stats(i).BoundingBox;
    a(a==0.5)=3;
    C=B(floor(a(2))-2:floor(a(2))+ceil(a(4))+2,floor(a(1))-2:floor(a(1))+ceil(a(3))+2);
    %Find any other objects in the bounding box and eliminate them
    L = bwlabel(C);
    stats=regionprops(L,'Area','BoundingBox');
    while size(stats,1)>1
        [c,i]=min([stats.Area]);
        ab=stats(i).BoundingBox;
        ab(ab==0.5)=1;
        C(floor(ab(2)):floor(ab(2))+ceil(ab(4)),floor(ab(1)):floor(ab(1))+ceil(ab(3)))=0;
        L = bwlabel(C);
        stats=regionprops(L,'Area','BoundingBox');
    end
    D=bwmorph(C,'thin',100);
    %dstore(floor(a(2))-2:floor(a(2))+ceil(a(4))+2,floor(a(1))-2:floor(a(1))+ceil(a(3))+2,k)=D;
    t=bwmorph(D,'branchpoints');
    bc=sum(sum(t));
   
    E=D;
    
        
    while bc>0
        %disp(bc);
        E=bwmorph(E,'spur');
        E=bwmorph(E,'skel');
        t=bwmorph(E,'branchpoints');
        bc=sum(sum(t));
    end
    E=bwmorph(E,'clean');

    %Get points from the skeleton
    Etemp=E;
    F=bwmorph(Etemp,'endpoints');
    L = bwlabel(F);
    stats=regionprops(L,'Centroid');
    %Locate head and tail - head is always further to the right (higher x) than
    %tail
    if stats(2).Centroid(1)>stats(1).Centroid(1)
        head=stats(2).Centroid;
    else
        head=stats(1).Centroid;
    end
    headtemp=head;
    npts=sum(sum(Etemp));
    pct=1;
    while npts>0
        %locate endpoints
        F=bwmorph(Etemp,'endpoints');
        L = bwlabel(F);
        stats=regionprops(L,'Centroid');
        %find one closest to anterior end, add to X and Y
        if size(stats,1)==2 
            s1dist=((stats(1).Centroid(1)-headtemp(1))^2+(stats(1).Centroid(2)-headtemp(2))^2)^0.5;
            s2dist=((stats(2).Centroid(1)-headtemp(1))^2+(stats(2).Centroid(2)-headtemp(2))^2)^0.5;
            if s1dist<s2dist
                tr(pct)=pct-1;  %Body position index for splining
                rawX(pct)=stats(1).Centroid(1);
                rawY(pct)=stats(1).Centroid(2);
                headtemp=stats(1).Centroid;
                Etemp(headtemp(2),headtemp(1))=0;
                %Etemp(headtemp(2)-1:headtemp(2)+1,headtemp(1)-1:headtemp(1)+1)=0;

                pct=pct+1;
                npts=sum(sum(Etemp));
            end
            if s2dist<s1dist
                tr(pct)=pct-1;  %Body position index for splining
                rawX(pct)=stats(2).Centroid(1);
                rawY(pct)=stats(2).Centroid(2);
                headtemp=stats(2).Centroid;
                Etemp(headtemp(2),headtemp(1))=0;
                %Etemp(headtemp(2)-1:headtemp(2)+1,headtemp(1)-1:headtemp(1)+1)=0;
                pct=pct+1;
                npts=sum(sum(Etemp));
            end        
        else    
            Etemp(headtemp(2),headtemp(1))=0;
            npts=0;
        end   

    end
    
    %use upper-left corner of bounding box to convert back to full video
    %coordinates
    rawX=rawX+floor(a(1))-2;
    rawY=rawY+floor(a(2))-2;
    
    
    
    %linearly extend head and tail (based on first and last TIPN points) to edge of image, adjust tr
    %appropriately
    TIPN=10;
    [hx,~]=polyfit(tr(1:TIPN),rawX(1:TIPN),1);
    sheadX2=polyval(hx,tr(1:TIPN));
    [hy,~]=polyfit(tr(1:TIPN),rawY(1:TIPN),1);
    sheadY2=polyval(hy,tr(1:TIPN));
    %plot(rawX,rawY,'Marker','o');hold on;plot(sheadX2,sheadY2,'LineWidth',2);
    
    detector=1;
    inc=-1;
    while detector==1
        headtestX=polyval(hx,inc);
        headtestY=polyval(hy,inc);
        detector=B(round(headtestY),round(headtestX));
        inc=inc-1;
    end
    
    theadext=[inc:size(tr,2)];
    nl=size(theadext,2);
    rawX2(1:(abs(inc)+TIPN+1))=polyval(hx,theadext(1:(abs(inc)+TIPN+1)));
    rawY2(1:(abs(inc)+TIPN+1))=polyval(hy,theadext(1:(abs(inc)+TIPN+1)));
    rawX2((abs(inc)+TIPN+2):nl)=rawX((TIPN+1):size(tr,2));
    rawY2((abs(inc)+TIPN+2):nl)=rawY((TIPN+1):size(tr,2));
    
    TIPN=60;
    [hx,~]=polyfit(theadext(nl-TIPN:nl),rawX2(nl-TIPN:nl),1);
    stailX2=polyval(hx,theadext(nl-TIPN:nl));
    [hy,~]=polyfit(theadext(nl-TIPN:nl),rawY2(nl-TIPN:nl),1);
    stailY2=polyval(hy,theadext(nl-TIPN:nl));
    %plot(rawX2,rawY2,'Marker','o');hold on;plot(stailX2,stailY2,'LineWidth',2);
    
    detector=1;
    inc=nl+1;
    while detector==1
        tailtestX=polyval(hx,inc);
        tailtestY=polyval(hy,inc);
        detector=B(round(tailtestY),round(tailtestX));
        inc=inc+1;
    end
    
    theadext2=[min(theadext):inc];
    nl2=size(theadext2,2);
    rawX3(1:nl)=rawX2(1:nl);
    rawX3(nl+1:nl2)=polyval(hx,theadext2(nl+1:nl2));
    rawY3(1:nl)=rawY2(1:nl);
    rawY3(nl+1:nl2)=polyval(hy,theadext2(nl+1:nl2));

%     conv = 142.7;  % pix/cm
 pixpercm= 80.8;

switch corn
    case false
    len = 760;%was 600%440;  % snout to vent in pix    % not neck to vent???
    headLen = 1;  % snout to neck distance to cut off 19?
    case true
    len = 560;%560;  % snout to vent in pix    % not neck to vent???  440 for garter -NO!
    headLen = 0;  % snout to neck distance to cut off 19?
end

if chion == true                                                                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                                                                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                          
len = 4.0 * pixpercm  ; % 3.5 for chion on blue %450pix;                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                      
   headLen = 50;      %NOT USED                                                                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
end                         
% if snum == 133
%     len = 2000;
% end
    extra = 25;
    numP = 500+extra;
    
    redo = true;
    safety = 1;
   fudge = .75;
    add =1;
    
    while redo==true;                       %%% redo spline until length is within 0.75 pix of specified
    tr0=theadext2+abs(min(theadext2));  
    t2=tr0/max(tr0);
    t3=linspace(0,1,numP);
    [px,Sx] = polyfit(t2,rawX3,25);
    pvx=polyval(px,t3);
    [py,Sy] = polyfit(t2,rawY3,25);
    pvy=polyval(py,t3);
    
    hn = [];
    pd = zeros(1,numP);
    for n = 1:numP-1
        dx = ( pvx(n)-pvx(n+1) );
        dy = ( pvy(n)-pvy(n+1) );
        pd(n) = sqrt(dx^2 + dy^2);
       if sum(pd) <= len
           N=n;
       end
       if sum(pd) >= headLen
           hn(end+1) = n; %#ok<SAGROW>
       end  
    end
    hN= hn(1);

                 %%%THIS MAY NOT WORK AT ALL
      N2 = round(N+(extra)*(N-hN)/numP)*.988;
   
    t3=linspace(hN/numP,N2/numP,numP);          %%%  hopefully?
    [px,Sx] = polyfit(t2,rawX3,25);
    pvx=polyval(px,t3);
    [py,Sy] = polyfit(t2,rawY3,25);
    pvy=polyval(py,t3);
   
    pvx = pvx(1:500);
    pvy = pvy(1:500);
    
    for n = 1:499              %%% check length
        dx = ( pvx(n)-pvx(n+1) );
        dy = ( pvy(n)-pvy(n+1) );
        pd(n) = sqrt(dx^2 + dy^2);
    end
    
    if disps
    if k<=5
    disp([k sum(pd) len sum(pd)-len])
    end
    end

    if safety>5
        fudge = fudge*1.5;
        add = round(add*.75);
        safety = 2;
    end
    if sum(pd)>len+fudge
        extra = extra-add;
    elseif sum(pd)<len-fudge
        extra = extra+add;
    else
        redo = false;
    end
    safety = safety+1;
    end
    
    lengthError(k) = sum(pd)-len;
    
    if pad
        pvx = pvx-100; pvy = pvy-100;
    end
    
   paws = 2;
    %output to video
    if vidyes==1
        if marking==true;       %was line width 3
            himage=imshow(A);hold on;plot(pvx,pvy,'g','LineWidth',2);plot(pvx(125),pvy(125),'ro','LineWidth',2,'MarkerSize',5);plot(pvx(2*125),pvy(2*125),'ro','LineWidth',2,'MarkerSize',5);plot(pvx(3*125),pvy(3*125),'ro','LineWidth',2,'MarkerSize',5);
            plot(pvx(1),pvy(1),'ro','LineWidth',2,'MarkerSize',5);plot(pvx(500),pvy(500),'ro','LineWidth',2,'MarkerSize',5);
        else
            himage=imshow(A);hold on;plot(pvx,pvy,'g','LineWidth',2);
        end
            hfig=imgcf;
        MF=getframe(hfig);
        writeVideo(writerObj,MF);
        if k <= 5
        pause(paws)
        end
        close(hfig);
    end
    
    %Convert to real units (cm)
%     pixpercm= 13; % we want pixels?  %pixpercm=12.92; %-alex %pixpercm=12.75; %Based on measurements on 4/27/15
    pxcm=pvx/pixpercm;
    pycm=pvy/pixpercm;
        
    %Convert to Miguel-style spline(numpoints,axis,frame)
    MS(:,1,k)=pxcm;
    MS(:,2,k)=pycm;
    MS(:,3,k)=1;
        
    if timing==true
    if mod(k,25) == 0 
        
    pdon = k/(nFrames-1);
        if mod(k+99,100)==0
          elapsed = toc-paws.*5;
         tottime = elapsed./pdon;
           %sec_left = round(tottime-elapsed);
      elseif k==10
          elapsed = toc-paws.*5;
          tottime = elapsed./pdon;
          %sec_left = round(tottime-elapsed);
      elseif k==30
         elapsed = toc-paws.*5;
         tottime = elapsed./pdon;
         %sec_left = round(tottime-elapsed);
      end
    sec_left = round((1-pdon).*tottime + 1);
    
    mins = floor(sec_left/60);
    secs = mod(sec_left,60);
    if sec_left ==1
    timeLeft = sprintf('Time Remaining for this video: %d second',secs);
    elseif mins == 0
    timeLeft = sprintf('Time Remaining for this video: %d seconds',secs);
    elseif secs ==1;
    timeLeft = sprintf('Time Remaining for this video: %d minutes and %d second',mins,secs);
    else
    timeLeft = sprintf('Time Remaining for this video: %d minutes and %d seconds',mins,secs);
    end
    
    kk = sprintf('Video %d / %d - Frame %d / %d', ii,numFiles,k, nFrames);
    disp(kk);
    disp(timeLeft);
    else
    kk = sprintf('Video %d / %d - Frame %d / %d', ii,numFiles,k, nFrames);
        if k<10
            disp(kk);
        
        end
    end
    elseif k<5 || mod(k,100)==0 || k == nFrames-1
        kk = sprintf('Video %d / %d - Frame %d / %d', ii,numFiles,k, nFrames);
     disp(kk);
    end
    %disp(time_left);
    catch me
        nFrames = k;
        fprintf('Error: Ending spline process at frame %d: %s\n  Line %d\n',k,me.message,me.stack.line);
        close(writerObj);
        break
    end
end


% for k=1:nFrames-1
%         SplineLength(k)=0;
%         for j=2:500
%             SplineLength(k)=SplineLength(k)+(((MS(j,1,k)-MS(j-1,1,k))^2+(MS(j,2,k)-MS(j-1,2,k))^2+(MS(j,3,k)-MS(j-1,3,k))^2)^0.5);
%         end
% end
% plot(SplineLength)
% ylim([0 100])

%%

FileName4 = [dest '\' FileName(1:end-4) '_table.avi'];
FileName3=strrep(FileName4,'xvid','FinalSpline');
FileName3=strrep(FileName3,'avi','mat');
save(FileName3,'MS')

smoothF = 7;
for f = 1: 500; %(numP-extra) -1
    MS1(f,1,:) = smooth(squeeze(MS(f,1,:)),smoothF);
    MS1(f,2,:) = smooth(squeeze(MS(f,2,:)),smoothF);
    
end
MS0 = MS;
MS2 = MS;
for f = 1: 500; %(numP-extra) -1
    MS2(f,1,:) = smooth(squeeze(MS1(f,1,:)),smoothF);
    MS2(f,2,:) = smooth(squeeze(MS1(f,2,:)),smoothF);
    
end

FileName4 = [dest '\' FileName(1:end-4) '_table.avi'];
FileName3=strrep(FileName4,'xvid','FinalSpline');
FileName3=strrep(FileName3,'avi','mat');
save(FileName3,'MS')

FileName4 = [dest '\' FileName(1:end-4) '_table_smooth.avi'];
FileName3=strrep(FileName4,'xvid','FinalSpline');
FileName3=strrep(FileName3,'avi','mat');
MS = MS1;
save(FileName3,'MS')

FileName5 = [dest '\' FileName(1:end-4) '_table_smooth2.avi'];
FileName6=strrep(FileName5,'xvid','FinalSpline');
FileName6=strrep(FileName6,'avi','mat');
MS = MS2;
save(FileName6,'MS')


if vidyes==1
    close(writerObj);
end
disp(sprintf('Average length deviation:   %d',sum(lengthError)./(k)));
disp(sprintf('Maximum length deviation:   %d', max(lengthError)));
disp([FileName '   Video and Params Matrix have saved. ']);
disp(' ');disp(' ');

complete{ii,1} = [FileName, '    ', num2str(k), ' frames of ', num2str(nFrames), ' written.'];

%     totalTime(ii) = toc;


end
disp(complete);
jjjj;
tot = toc(totalTime);
 mins = floor(sum(tot/60));
 secs = round(mod(sum(tot),60));
 hrs = floor(mins/60);
 minss = mod(mins,60);
 AllTime = sprintf('Total Elapsed Time: %d hours, %d minutes, and %d seconds',hrs,minss,secs);
disp(sprintf('Completed in %s',AllTime));