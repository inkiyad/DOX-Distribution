%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample) % can control how many images to be manually segmented per session
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('*W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    
    figure(1);
    imshow(img); title({[filename ' Tissue Mask Comparison']}); 
    load(fullfile('TissueMask.mat')); % loads up prior auto segmented tissue mask
    load(fullfile('BeadMask.mat')); % loads up beads mask
    
    %% Manual Masking edits
    % Use MaskSubtract or MaskAdd as necessary
    
    figure_num = 2;
    TissueMask(BeadMask == 1) = 0; % Set tissue mask with bead region to be 0
    TissueMask = MaskSubtract(img, TissueMask, figure_num); % This will overwrite the automask
    
    
    save('TissueMask.mat','TissueMask');
    
    cd('..');
    
    
end

disp('All Done!');

cd(CodeDir);