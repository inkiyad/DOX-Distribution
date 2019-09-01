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
    load(fullfile('TissueMask.mat'));
    load(fullfile('BeadMask.mat'));
    img = imread(fullfile(filename)); % reading the image file
    
    %% This section will add up all the binary layers from multiple
    % thresholds above 2 STD of avg blank intensity to show a concentration
    % gradient
    DrugLayerMask = zeros([size(img),8]); % Blank matrix for DrugLayerMask
                                        % it optimizes the code also
                                        % prevents the code from crashing 
    layers = 0:.5:3; 
    for l=1:length(layers)
        load(fullfile(['SmuDrugTissueMask_STD_' num2str(2+layers(l)) '.mat']))
        DrugLayerMask(:,:,l) = DrugTissueMask;
    end
    
    %% Saving the multilayerDrugMask
    DrugLayerMask = sum(DrugLayerMask, 3);
    save('MultilayerDrugMask.mat', 'DrugLayerMask', '-v7');
    % overlay = imoverlay(img, DrugTissueMask, 'yellow');
    
    %% Display -- comment out the section if visualization isn't required
    load(fullfile('SmuDrugTissueMask_STD_2.mat'));
    
    DrugLayer = zeros(size(img));
    red = cat(3, ones(size(img)), DrugLayer, DrugLayer);
    white = cat(3, ones(size(img)),ones(size(img)),ones(size(img)));
    
    img(TissueMask == 0) = 0;
    img(BeadMask == 1) = 255;
    %img = ind2rgb(img, gray);
    %img(:,:,[1 2]) = 0; 
    DrugLayer = DrugLayerMask./8; % 255 because 255 is max intensity
                                               % 8 because there are 8 layers
                                               % including background
    figure(1);
    imshow(img); % Background image
    hold on
    h = imshow(red); % red overlay and variable h is used for setting transparency 
    hold on
    w = imshow(white);
    hold off
    
    set(h, 'AlphaData', DrugLayer); % Druglayer is the transparency data
    set(w, 'AlphaData', BeadMask);                               

    pause(1);
    
    cd('..');
    
    %% Progress - Just to see the progress of the code
    s = i
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);