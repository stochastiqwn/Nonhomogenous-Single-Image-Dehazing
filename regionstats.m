function [mus, sigmas, reg] = regionstats(chan_R, chan_G, chan_B,typ)
    % Assumes channel data is a floating image 0-1
    % Outputs stats on a scale 0-1
    reg = zeros(length(chan_R),1,3);
    reg(:,:,1) = chan_R;
    reg(:,:,2) = chan_G;
    reg(:,:,3) = chan_B;
    
    if typ == "gray"
        reg_gray = rgb2gray(reg);
%         disp(reg_gray);
        mus = mean(reg_gray(:));
        sigmas = std(reg_gray(:));
        
    elseif typ == "rgb"
        mus = [mean(chan_R(:)), mean(chan_G(:)), mean(chan_B(:))];
        sigmas = [std(chan_R(:)), std(chan_G(:)), std(chan_B(:))];
        
    else
        error([typ ' Not Implemented']);
        
    end
end

