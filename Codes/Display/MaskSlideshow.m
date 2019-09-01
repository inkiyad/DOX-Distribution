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
    load('SmuDrugTissueMask.mat'); % load drug tissue mask to get tissue only
    load('TissueMask2.mat');
    load('BeadMask.mat');
    img(TissueMask == 0) = 0;
    img(BeadMask == 1) = 255;
    %img = ind2rgb(img, pink);
    overlay = imoverlay(img, DrugTissueMask, 'yellow');
    figure(3);
    imshow(overlay);
    pause(2);
    
    cd('..');
    
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);