%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples/Blanks'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
file = dir('W*.tif'); % locate all images that has name starting with W

for i=1:length(file)
    %% Analyzing pixel intensity for blank tissue samples
    filename = file(i).name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    
    TissueMask = imbinarize(img, 0.09); % 0.1 is a hyperparameter
    
    figure(1);
    imshow(img); title({[filename ' Tissue Mask Comparison']}); 
    
    figure_num = 2; % If needed, can always press [Y] to move on
    TissueMask = MaskSubtract(img, TissueMask, figure_num);
    
    %figure_num = 2; % If needed, can always press [Y] to move on
    %TissueMask = MaskAdd(img, TissueMask, figure_num);
    
    
    save(['TissueMask_blank_' filename '.mat'] , 'TissueMask');
    
    % load(['TissueMask_Blank_' filename '.mat']); - Only Use to debug
    
    TissueOnly = img(TissueMask==1);
    TissueCELL{:,i} = TissueOnly(:)'; % Apostrophe for transposing
    
    
end

AvgBlankIntensity = mean(double([TissueCELL{:,:}])); % [ ] makes the cell to a vector
StdBlankIntensity = std(double([TissueCELL{:,:}]));
save('BlankIntensityStats.mat', 'AvgBlankIntensity', 'StdBlankIntensity');

cd(CodeDir);