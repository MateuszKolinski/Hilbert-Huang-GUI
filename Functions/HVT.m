function [modulation, norm, realpart, space]=HVT(fringe)

[RowNum, ColNum] = size( fringe );
[x y]=meshgrid(linspace(-pi,pi,ColNum), linspace(-pi,pi,RowNum));
fi=(((atan2(x,y))));
% creation of the 2D signum function
% dx = 1;
% u = -ColNum/2 * dx : dx : (ColNum/2-1) * dx;
% v = -RowNum/2 * dx : dx : (RowNum/2-1) * dx;
% u = padarray( u, [RowNum-1 0], 'replicate','post' );
% v = padarray( v', [0 ColNum-1], 'replicate','post' );
% fi = atan2( u, v );
%   fi1=binar(fi,0);
%   obrazek(fi1);
%   fi=fi.*fi1;
%   obrazek(fi);
% fi = rot90(fi) .* fi;
signum2d = exp( -i*(fi) );
spectrum = fftshift( fft2( fringe ) );
% inverse Fourier transform of the spectrum multiplied by signum function
space = ifft2( fftshift( spectrum.*signum2d ) );  
% modulation distribution
modulation=abs(fringe + i*real(space));
% normalization
norm=fringe./modulation;

%real part
realpart=real(space);

