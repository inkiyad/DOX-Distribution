%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
BlankDirectory = '../../Data/Tissue Samples/Blanks/';
load([BlankDirectory 'BlankIntensityStats.mat']); % Load blank intesity stats

directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample)
    % Implementing for loop to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    load('TissueMask.mat'); % load bead mask to get tissue only
    
    %% Smoothing the samples
    img(TissueMask == 0) = 0;
    
    H = fspecial('disk',10); % mean filter with kernel radius of 10 pixels
    BlurImg = roifilt2(H,img,TissueMask); % applying filter only in TissueMask
                                          % that way the vessels won't be
                                          % filtered with the tissue region
    
    imshow(BlurImg);
    imwrite(BlurImg, ['Smu13mm_' filename]); % saving blurred image
    
    cd('..');
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);