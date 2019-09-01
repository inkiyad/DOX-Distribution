%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

cd(sample(1).name); % change directory to [sample directory] with image
file = dir('W*.tif'); % locate all images that has name starting with W
filename = file.name; % extracting string from a struct
img = imread(fullfile(filename)); % reading the image file

% Otsu method to get the graythreshold
L = graythresh(img); % Run this line when you are trying to find the
%                       otsu trheshold from a tissue image that has beads

%% Saving bead segmentation threshold
cd(CodeDir);
save('OtsuThresholdBead.mat', 'L');