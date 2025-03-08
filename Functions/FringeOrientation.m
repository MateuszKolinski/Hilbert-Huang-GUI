function theta = FringeOrientation(Interf,n)
%Generates fringe orientation angle map with Yang algorithm for a given interferogram
%Interf - fringe pattern
%n - size of a neighborhood for the angle determination
%Maciej Wielgus 2010
%Faculty of Mechatronics
%Warsaw University of Technology
%"Processing of fringe patterns obtained using the time-average
%interference method for vibration analysis", MSc Thesis
%see [YANG] for details

if rem(n,2) == 0
    n = n+1;    
end             %n needs to be odd

[k,m] = size(Interf);
[b,c] = meshgrid(-(n-1)/2:(n-1)/2); %matrix for summing elements by convolution
%B = 12*conv2(Interf,b)/((n^2)*(n^2 - 1));
%C = 12*conv2(Interf,c)/((n^2)*(n^2 - 1)); %plane fitting parameters matrix
B = conv2(Interf,b,'same');
C = conv2(Interf,c,'same');

d = B.*C;
e = B.^2 - C.^2;

D = conv2(d,ones(n),'same');
E = conv2(e,ones(n),'same');

Orient = 0.5*atan(2*D./E);

temp = zeros(size(E));
temp(E>=0) = pi/2;
%Orient = Orient  + temp;

temp1 = zeros(size(E));
temp2 = zeros(size(E));
temp1((D>0)) = 1;
temp2(E<0) = 1;
%temp = temp1.*temp2;

%Orient = Orient + pi*temp;
Orient1 = Orient + temp + pi*temp1.*temp2;

%theta = Orient1(n:k+n-1,n:m+n-1 );
theta = Orient1;

theta = rem(-theta+ 3*pi/2,pi);
end

