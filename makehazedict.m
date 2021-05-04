function dictionary = makehazedict(fn_hz,fn_gt,K)

j = 1;
for i = 1:length(fn_hz)
    [imhz, imgt] = loadimagepair(fn_hz(i).name,fn_gt(i).name,0.25,0.25);
    R = size(imhz,1);
    C = size(imhz,2);
    im_hz_lab = rgb2lab(imhz);
    im_hz_lab = single(im_hz_lab);
    L = imsegkmeans(im_hz_lab,K,'NumAttempts',4);
    for k = 1:K
        % Chan RGB using kmeans
        idx = find(L == k);
        rIdx = idx;
        gIdx = idx + R*C;
        bIdx = idx + 2*R*C;
        
        chan_R_hz = imhz(rIdx);
        chan_G_hz = imhz(gIdx);
        chan_B_hz = imhz(bIdx);

        chan_R_gt = imgt(rIdx);
        chan_G_gt = imgt(gIdx);
        chan_B_gt = imgt(bIdx);

        dictionary(j).hazy_means = [mean(chan_R_hz), mean(chan_G_hz), mean(chan_B_hz)];
        dictionary(j).hazy_sigmas = [std(chan_R_hz), std(chan_G_hz), std(chan_B_hz)];
        dictionary(j).truth_means = [mean(chan_R_gt), mean(chan_G_gt), mean(chan_B_gt)];
        dictionary(j).truth_sigmas = [std(chan_R_gt), std(chan_G_gt), std(chan_B_gt)];
        
        j = j + 1;
    end
end
end

