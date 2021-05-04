function [imhz, imgt] = loadImagePair(fn_imhz, fn_imgt, scale1, scale2)
    % outputs a floating image 0-1
    imhz = imread(fn_imhz);
    imgt = imread(fn_imgt);

    imhz = imresize(imhz,scale1);
    imgt = imresize(imgt,scale2);

    imhz = double(imhz)/max(double(imhz(:)));
    imgt = double(imgt)/max(double(imgt(:)));
    
%     imhz = imrotate(imhz,90);
%     imgt = imrotate(imgt,90);
end
