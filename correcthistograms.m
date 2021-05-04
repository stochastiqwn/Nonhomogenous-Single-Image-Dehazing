function hzccim = correcthistograms(im, mask, oldMeans, targetSigmas, targetMeans)
%HZCOLORCORRECT Assumes the block has a gaussian distribution of pixel
%   intensities in each color channel
%   Assumes it is taking a floating image 0-1

    sz = size(im);
    px = sum(mask,'all');
    indices = find(mask(:));
    im = double(im(:));
       
    % Shift the means of each channel
%     disp(im(indices+numel(mask)));
    block_R = im(indices)-oldMeans(1)+targetMeans(1);
    block_G = im(indices+numel(mask))-oldMeans(2)+targetMeans(2);
    block_B = im(indices+2*numel(mask))-oldMeans(3)+targetMeans(3);

    % Create target histograms bounded by 0-1 (float image)
    edges = (0:255)/255;
    hgram_R = histcounts(randn(px,1)*targetSigmas(1) + targetMeans(1),edges); % Ideal histograms, before mean channel shifting
    hgram_G = histcounts(randn(px,1)*targetSigmas(2) + targetMeans(2),edges);
    hgram_B = histcounts(randn(px,1)*targetSigmas(3) + targetMeans(3),edges);

    % Apply histogram correction with the target histograms
    blockeq_R = histeq(block_R,hgram_R);
    blockeq_G = histeq(block_G,hgram_G);
    blockeq_B = histeq(block_B,hgram_B);
    
    % Fill in the color corrected image at the mask locations
    hzccim = zeros(size(im(:)));
    hzccim(indices) = blockeq_R;
    hzccim(indices+numel(mask)) = blockeq_G;
    hzccim(indices+2*numel(mask)) = blockeq_B;
    hzccim = reshape(hzccim,sz);

end

