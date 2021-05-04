function viewsuperpixelhaze(files,Nd,compactness)
%VIEWSUPERPIXELHAZE Summary of this function goes here
%   Detailed explanation goes here

hfig = figure;

I = length(files)-1;
i = 1;
n = 1;
[imhz, imgt] = loadimagepair(files(i+1).name, files(i).name, 0.25);
[imhz_seg, idx, L, N] = imprepsuperpixels(imhz,Nd,compactness);
R = size(imhz,1);
C = size(imhz,2);
subplot(2,2,1); imshow(imhz);
subplot(2,2,2); imshow(imgt);

while true    
    % Index the pixels of superpixel n
    rIdx = idx{n};
    gIdx = idx{n} + R*C;
    bIdx = idx{n} + 2*R*C;
    
    chan_R_hz = imhz(rIdx);
    chan_G_hz = imhz(gIdx);
    chan_B_hz = imhz(bIdx);
    
    chan_R_gt = imgt(rIdx);
    chan_G_gt = imgt(gIdx);
    chan_B_gt = imgt(bIdx);
    
    % Calculate intensity mean and standard deviation of superpixel n
    [mu_hz, sigma_hz, hz] = superpixelstats(chan_R_hz, chan_G_hz, chan_B_hz);
    [mu_gt, sigma_gt, gt] = superpixelstats(chan_R_gt, chan_G_gt, chan_B_gt);
    
    % Determine the boundary of superpixel n
    bw_n = boundarymask(L==n);
    
    % Update plot
    subplot(2,2,1); imshow(imoverlay(imhz, bw_n,'r')); title('Hazy'); % plot overlay
    subplot(2,2,2); imshow(imoverlay(imgt, bw_n,'r')); title('Truth'); % plot overlay
    subplot(2,2,3); imshow(imoverlay(imhz_seg, bw_n,'r')); % plot overlay
    title(['N = ' num2str(N)]);
    a = subplot(2,2,4); cla(a);
    rgbhistshow(hz,'m'); % plot histograms
    rgbhistshow(gt,'k');
    title('Histograms');
%     title(['\sigma_{gt} = ' num2str(sigma_gt)...
%            ' \mu_{gt} = ' num2str(mu_gt)...
%           ' \sigma_{hz} = ' num2str(sigma_hz)...
%           ' \mu_{hz} = ' num2str(mu_hz)]);
      
    % Keyboard controls for the plot
    % Right/Left Arrow: cycle through superpixels
    % Up/Down Arrow: cycle through images
    waitforbuttonpress;
    if strcmp(get(hfig,'CurrentKey'), 'rightarrow')
        n = min(N,n + 1);
    elseif strcmp(get(hfig,'CurrentKey'), 'leftarrow')
        n = max(1,n - 1);
    elseif strcmp(get(hfig,'CurrentKey'), 'uparrow')
        i = min(I,i + 2);
        [imhz, imgt] = loadimagepair(files(i+1).name, files(i).name, 0.25);
        [imhz_seg, idx, L, N] = imprepsuperpixels(imhz,Nd,compactness);
        R = size(imhz,1);
        C = size(imhz,2);
        subplot(2,2,1); imshow(imhz);
        subplot(2,2,2); imshow(imgt);
    elseif strcmp(get(hfig,'CurrentKey'), 'downarrow')
        i = max(1,i - 2);
        [imhz, imgt] = loadimagepair(files(i+1).name, files(i).name, 0.25);
        [imhz_seg, idx, L, N] = imprepsuperpixels(imhz,Nd,compactness);
        R = size(imhz,1);
        C = size(imhz,2);
        subplot(2,2,1); imshow(imhz);
        subplot(2,2,2); imshow(imgt);
    elseif strcmp(get(hfig,'CurrentKey'), 'k')
        Nd = Nd + 15;
        [imhz_seg, idx, L, N] = imprepsuperpixels(imhz,Nd,compactness);
    elseif strcmp(get(hfig,'CurrentKey'), 'j')
        [imhz_seg, idx, L, N] = imprepsuperpixels(imhz,Nd,compactness);
        Nd = max(1,Nd - 15);
    end
end

    function [overlaid, indices, L, N] = imprepsuperpixels(im,Nd,compactness)
        [L, N] = superpixels(im,Nd,'Compactness',compactness,'NumIterations',20);
        bw = boundarymask(L);
        overlaid = imoverlay(im,bw,'k');
        indices = label2idx(L);
    end
end

