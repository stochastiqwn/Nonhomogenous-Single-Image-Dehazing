function [imcc, imseg] = dehaze(imhz,method,alpha,beta,K,statdict)
% alpha = 12;
% beta = 4.8;

R = size(imhz,1);
C = size(imhz,2);

% Extract k means segmentation
imhz_lab = rgb2lab(imhz);
imhz_lab = single(imhz_lab);
L = imsegkmeans(imhz_lab,K,'NumAttempts',2);

% Initialize dehazed image and segmentation map
imcc = zeros(size(imhz));
imseg = zeros(size(imhz));

for k = 1:K
    % Get the pixels in each channel
    idx = find(L == k);
    rIdx = idx;
    gIdx = idx + R*C;
    bIdx = idx + 2*R*C;

    chan_R_hz = imhz(rIdx);
    chan_G_hz = imhz(gIdx);
    chan_B_hz = imhz(bIdx);
    
    % Create a binary mask of the cluster
    mask = L == k;
    
    if method == "statistics"
        % Get region statistics
        [mu_hz_, ~, ~] = regionstats(chan_R_hz, chan_G_hz, chan_B_hz,'gray');
        [mu_hz, sigma_hz, ~] = regionstats(chan_R_hz, chan_G_hz, chan_B_hz,'rgb');
        
        % Calculate the new mean and std
        shiftMean = -(mu_hz_)^2/alpha;
        shiftSigma = max(1,abs(shiftMean)/beta);
        
        % Create target means and sigmas
        targetMeans = mu_hz + [0, -9.182, -29.643]/255 + shiftMean;
        targetSigmas = sigma_hz.*shiftSigma;

    elseif method == "dictionary"
        % Get region statistics
        [mu_hz, sigma_hz] = regionstats(chan_R_hz,chan_G_hz,chan_B_hz,'rgb');
        
        % Search dictionary for true region statistics
        [targetMeans, targetSigmas] = searchhazedict(mu_hz,sigma_hz,statdict);
    
    else
        error ([method 'Not Implemented']);
        
    end
    
    % Apply histogram correction to the region
    imcc = imcc + correcthistograms(imhz,mask,mu_hz,targetMeans,targetSigmas);
    
    % Fill in the segmentation map
    imseg(rIdx) = mean(chan_R_hz);
    imseg(gIdx) = mean(chan_G_hz);
    imseg(bIdx) = mean(chan_B_hz);

end

end

