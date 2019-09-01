%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample)
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    load('BeadMask.mat'); % load bead mask to get tissue only
    
    %% Automated Tissue Segmentation
    img(BeadMask ==1) = 25; % 25 to blend in with the background this will be used based on calibration value
    imshow(img); 
    %pause(2); % pausing for 2 seconds to illustrate beadless tissue sample
    
    % thresh = graythresh(img); for Otsu method
    thresh = 0.09;
    TissueMask = imbinarize(img, thresh); % 0.9 is a hyperparameter
    TissueMask = bwareaopen(TissueMask, 30);
    TissueMask = bwareafilt(TissueMask, 50);
    overlay = imoverlay(img, TissueMask); % overlay of tissue region
    imshow(overlay);
    title('Yellow (Binary) Mask Representing Tissue');
    %pause(2);
    
    save('TissueMask.mat','TissueMask'); % saving tissue mask as a .mat file for further analysis
    
    cd('..'); % go back to tissue samples directory to run the next sample
    
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);