function [imf avd] = FABEMD1(Im, par1, NumIMF)
%This is a very efficient Matlab implementation of the FABEMD algorithm. 
%Delaunay triangulation is used for the adjacent extrema distances calculations
%and image morphology is used for the extrema location as well as for the
%statistical filters implementation. 
%par1 is the type of the statistical filter. We consider par1 = 5,
%corresponding to mean distance between the adjacent extrema, to be the most
%reasonable case (it is the default option). With par1 >= 6 the distances 
%are not calculated, mean distance is estimated from the number of extrema
%Example:
%Decomposition = FABEMD(Image);
%This code can be used freely for research purposes, but
%please cite some adequate paper of mine, you may find a list here:
%www.mwielgus.cba.pl
%Maciek Wielgus
%Institute of Micromechanics and Photonics
%Warsaw University of Technology, February 2013

global m0 n0 MaxW
[m0,n0] = size(Im);

if nargin <3
    NumIMF = 20;
    if nargin < 2
    par1 = 5;
    end
end
MaxW = max(m0,n0)/1; %Stop condition for the filter size
   
%---Preparing data with the mirroring procedure

ext = round(min(m0,n0)/10); %extension thickness 10%
% f1 = flipud(Im(1:ext,:)) ;
% f2 = flipud(Im(m0-ext+1:m0,:));
% f3 = fliplr(Im(:,1:ext));
% f4 = fliplr(Im(:,n0-ext+1:n0)) ;
% f5 = Im(1:ext,1:ext);
% f6 = Im(1:ext,n0-ext+1:n0);
% f7 = Im(m0-ext+1:m0,1:ext);
% f8 = Im(m0-ext+1:m0,n0-ext+1:n0);
% Im = [fliplr(rot90(f5)), f1, f6'; f3, Im, f4; f7', f2, fliplr(rot90(f8))];
%---------------------------------------------
sig=expand(Im,ext);
% figure, imagesc(sig);
cou = 1;
% sig = Im;
w=1;

%----FABEMD main loop-------------
while w <= MaxW && cou <= NumIMF 

   [mini, maxi,Number] = getExtrema2(sig(ext+1:m0+ext ,ext+1:n0+ext)); 
   %extrema with morphology
   
  %[mini, maxi,Number] = getExtrema(sig(ext+1:m0+ext ,ext+1:n0+ext)); 
  %extrema without morphology
  
  if  Number(1) > 3 %only if we can do the triangulation

    [Eav,w] = FABEMDloop(sig, par1,w,mini, maxi);
%    w,
   avd(cou)=w;
           if w > MaxW
              break
           end
    temp = sig - Eav;
    imf{cou} = temp(ext+1:m0+ext ,ext+1:n0+ext);
    sig = Eav;
    cou = cou+1;  
    
  else break
  end
   
end
%----------------------------------
imf{cou} = sig(ext+1:m0+ext ,ext+1:n0+ext); %saving the residue

end

function [Eav,w] = FABEMDloop(Im, par1,LastW, mini, maxi)
%The loop of FABEMD algorithm.
%www.mwielgus.cba.pl
%Maciek Wielgus
%Institute of Micromechanics and Photonics
%Warsaw University of Technology, February 2013
%LastW - filter size w in the previous iteration

global m0 n0 MaxW

if par1 < 6
%-----Calculating distances between minima---------------------------
p = mini;
tri=delaunay(p(:,1),p(:,2));
tri=tri(:,[1:end 1]);
dx = diff(reshape(p(tri,1),size(tri)),1,2);
dy = diff(reshape(p(tri,2),size(tri)),1,2);
dminmin = sqrt(min(dx(:).^2+dy(:).^2));

if par1 >= 3
    
    distNmin = size(Im,1)*ones(size(p,1),1);
    for cou = 1:size(tri,1)
    for cou2 = 1:3
        
        odl = sqrt(dx(cou,cou2).^2 + dy(cou,cou2).^2);
        if distNmin(tri(cou,cou2)) > odl
        distNmin(tri(cou,cou2)) = odl;
        end
        if distNmin(tri(cou,cou2+1)) > odl
        distNmin(tri(cou,cou2+1)) = odl;
        end
    end
    end
    
end

%------------------------------------------------------------
%-----Calculating distances between maxima--------------------------
p = maxi;
tri=delaunay(p(:,1),p(:,2));
tri=tri(:,[1:end 1]);
dx = diff(reshape(p(tri,1),size(tri)),1,2);
dy = diff(reshape(p(tri,2),size(tri)),1,2);
dminmax = sqrt(min(dx(:).^2+dy(:).^2));

if par1 >=3
    
    distNmax = size(Im,1)*ones(size(p,1),1);
    for cou = 1:size(tri,1)
    for cou2 = 1:3
        
        odl = sqrt(dx(cou,cou2).^2 + dy(cou,cou2).^2);
        if distNmax(tri(cou,cou2)) > odl
        distNmax(tri(cou,cou2)) = odl;
        end
        if distNmax(tri(cou,cou2+1)) > odl
        distNmax(tri(cou,cou2+1)) = odl;
        end
    end
    end
    
end

%------------------------------------------------------------
else
meanN = max(0.5*(size(maxi)+size(mini)));   
    w = sqrt(m0.*n0/meanN);
    %this is case 6, estimating the value of w
end

%--choose order statistics filter width selection method
switch par1

    case 1
        w=min(dminmin,dminmax);
    case 2
        w=max(dminmin,dminmax);
    case 3
        w=min(max(distNmax),max(distNmin));
    case 4
        w=max(max(distNmax),max(distNmin));
    case 5
        w=0.5*(mean(distNmax) + mean(distNmin));
        %and case 6 is for estimated value of w
end;
%------------------------------------------------------------
w = max(LastW+2,w);
%---make sure that w is an odd number
    if mod(ceil(w),2)==0
      w=ceil(w)+1;
    else
      w=ceil(w);
    end;
%-----------------------------------

    if w <= MaxW
    AvMask = ones(w,w);
 
   % EU = -ordfilt2(-Im,1,ones(w,w),'zeros'); %upper envelope
    %EL = ordfilt2(Im,1,ones(w,w), 'zeros'); %lower envelope
 
    maskDil = strel('rectangle',[w,w]);
    EU = imdilate(Im,maskDil); %MAX filtration = upper envelope
    EL = -imdilate(-Im,maskDil); %MIN filtration = lower envelope
    Eav = conv2(0.5*(EU+EL),AvMask,'same')/(size(AvMask,1).^2); %mean envelope
    else Eav = 0;
   
    end
   
end

function [mini, maxi, N] = getExtrema(Im)
%Quite fast extrema location algorithm in 3x3 pixel neighborhood
%Nothing fancy but it is significantly faster than naive checking location
%after location
%This code can be used freely for research purposes, but
%please cite some adequate paper of mine, you may find a list here:
%www.mwielgus.cba.pl
%Maciek Wielgus
%Institute of Micromechanics and Photonics
%Warsaw University of Technology, February 2013

[m,n] = size(Im);
Im2 = zeros(m,n);
ImA =Im2; ImB = Im2; ImC = Im2; ImD = Im2; ImE = Im2; ImF = Im2; ImG = Im2; ImH = Im2;
Im2(2:m-1,2:n-1) = Im(2:m-1,2:n-1);
ImA(1:m-2,2:n-1) = Im(2:m-1,2:n-1); ImA = sign(ImA - Im2);
ImB(3:m,2:n-1) = Im(2:m-1,2:n-1);   ImB = sign(ImB - Im2);
ImC(2:m-1,1:n-2) = Im(2:m-1,2:n-1); ImC = sign(ImC - Im2);
ImD(2:m-1,3:n) = Im(2:m-1,2:n-1);   ImD = sign(ImD - Im2);
ImE(3:m,1:n-2) = Im(2:m-1,2:n-1);   ImE = sign(ImE - Im2);
ImF(1:m-2,1:n-2) = Im(2:m-1,2:n-1); ImF = sign(ImF - Im2);
ImG(3:m,3:n) = Im(2:m-1,2:n-1);     ImG = sign(ImG - Im2);
ImH(1:m-2,3:n) = Im(2:m-1,2:n-1);   ImH = sign(ImH - Im2);

Decyd = ImA + ImB + ImC + ImD + ImE + ImF + ImG + ImH;

[row,col] = find(Decyd == 8);
[row2, col2] = find(Decyd == -8);

maxi = [row2 col2];
mini = [row col];

N = min(size(maxi),size(mini));

end

function [mini, maxi, N] = getExtrema2(Im)
%Fast extrema location in 3x3 regions with morphological dilation
%This code can be used freely for research purposes, but
%please cite some adequate paper of mine, you may find a list here:
%www.mwielgus.cba.pl
%Maciek Wielgus
%Institute of Micromechanics and Photonics
%Warsaw University of Technology, February 2013

maskExt = strel('square',3);
MaxDil = imdilate(Im,maskExt); %MAX filtration
MinDil = -imdilate(-Im,maskExt); %MIN filtration
MaxMap = (Im - MaxDil); %binary map of maxima
MinMap = (Im - MinDil); %binary map of minima


[row,col] = find(~MinMap);
[row2, col2] = find(~MaxMap);

maxi = [row2 col2];
mini = [row col];

N = min(size(maxi),size(mini));
end

