


clear all
close all
pkg load image
%flip image, if image is upside down on spectrum, then set this to zero
% and re-run matlab script
flip_image = 1;




h = 1080;
w = 1920;
[filename, pathname, filterindex] = uigetfile('*.*','Pick a Image file','c:\FFT_Image');
b = [pathname filename];
x = imread(b);
xsize = size(x);
xl = length(xsize);

if xl > 2
x = rgb2gray(x);
end

x = double(x);
x = x / max( x(:) );

x = imresize(x,[h w] );

if flip_image == 1
    x = x(end:-1:1,:);
end

phmx = randn(h,w);
phmx = 23 * phmx;
phmx = exp(1i*phmx);
x = x .* phmx;
x = ifftshift(x,2);
x = ifft(x,[],2);
x = [x x ];



x = reshape(x.',1,[] );


x = x / max(abs(x));

scale = 32767;
x = scale * x;
%x = int16(x);
x = round(x);


% create file name and path to save
[filename, pathname ] = uiputfile( 'Spectrum_IQ.C16', 'Save IQ  File  As:  ');

fid = fopen ([pathname filename], 'w', 'l');




    x = [ real(x) ; imag(x) ];
    x = reshape(x,1,[]);

    % write int16 vector to file
    fwrite(fid, x, 'int16'  );



fclose (fid);




