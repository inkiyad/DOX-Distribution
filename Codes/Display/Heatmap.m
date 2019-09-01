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
    
%% Display -- comment out the section if visualization isn't required
    load(fullfile('SmuDrugTissueMask_STD_2.mat'));
    
    DrugLayer = zeros(size(img));
    DrugLayerMask = sum(DrugLayerMask, 3);
    imgx = length(img(1,:));
    imgy = length(img(:,1));
    %img([imgy-500:imgy-480],[imgx-3000:imgx-1500]) = 155; % scale bar for imagej 1.3µm = 1 px
                                                          % Here we used
                                                          % 1500 px which
                                                          % is 2000 µm 
    
    DrugLayer = uint8(DrugLayerMask.*(255/7)); % 255 because 255 is max intensity
                                               % 8 because there are 8 layers
                                               % including background
    DrugLayer = ind2rgb(DrugLayer, jet(255));
    img = ind2rgb(gray2ind(img), gray);
    
    %DrugLayer(DrugLayer == 0) = nan;
    %alpha = (~isnan(DrugLayer));
    fig = figure(1);
    Drug = imshow(DrugLayer); % heatmap
    
    % Scalebar labels
    concentration = [0:0.002:0.016];
    for k = 1:length(concentration)
        scale{k} = num2str(concentration(k));
    end
    scale{k} = '>0.14';
    
    cbr = colorbar('v');
    set(cbr,'YTick',[0,32:32:256]./256);
    set(cbr,'YTickLabel', scale);
    ylabel(cbr, 'Concentration (µg/ml)', 'FontSize', 16);
    
    hold on

    im = imshow(img); % background img
    colormap jet;
    set(im, 'AlphaData', ~DrugTissueMask);
    
    hold off
                                 

    pause(1);
    
    saveas(fig, 'HeatMapScaleBar.tiff');
    
    cd('..');
    
    %% Progress - Just to see the progress of the code
    s = i
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);