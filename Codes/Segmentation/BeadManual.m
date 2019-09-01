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
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    
    figure(1);
    imshow(img); title({[filename ' Bead Mask Comparison']}); 
    load(fullfile('BeadMask.mat')); % loads up beads mask from otsu segmentation variable b
    
    %% Manual Masking edits
    % Use MaskSubtract or MaskAdd as necessary
    
    figure_num = 2;
    BeadMask = MaskSubtract(img, BeadMask, figure_num);
    
    
    save('BeadMask.mat','BeadMask');
    
    cd('..');
    
    
end

disp('All Done!')

cd(CodeDir);