addpath('./NH-HAZE');
addpath('./hazeline_preprocessed/');
fn_truth = dir('./NH-Haze/*GT*.png');

% Choose method and haze line usage
method = "dictionary"; % "dictionary" "statistics"
usehazelines = 0; % True(1) or False(0)

% Constants. See paper for parameter vs. metric plots
K = 9;
alpha = 2.5;
beta = 0.326;

% Get hazy images
if usehazelines
    fn_hazy = dir('./hazeline_preprocessed/*.png');
    % If using haze line preprocessed images, make sure to unzip
    % the hazeline_preprocessed folder in the main directory
else
    fn_hazy = dir('./NH-Haze/*hazy*.png');
end

% Make dictionary
if method == "dictionary"
    statdict = makehazedict(fn_hazy,fn_truth,2*K);
else
    statdict = [];
end

% Iterate through all images in the dataset
for i = 1:length(fn_hazy)
    % Load Image
    [imhz, imgt] = loadimagepair(fn_hazy(i).name,fn_truth(i).name,0.25,0.25);
    
    % Dehaze the image
    [dehazed, segmentation] = dehaze(imhz,method,alpha,beta,K,statdict);
    
    % Write the results
    imwrite(dehazed,['./val/',strrep([fn_truth(i).name],'GT','val')]);
    imwrite(segmentation,['./val/',strrep([fn_truth(i).name],'GT','val_seg')]);
end