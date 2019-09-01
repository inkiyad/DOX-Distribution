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
    file = dir('*Smu*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    load('TissueMask.mat'); % load bead mask to get tissue only
    
    %% DrugTissue Mask generation
    Tissue = img;
    Tissue(TissueMask == 0) = 0;
    DrugTissue = Tissue;
    
    % Setting threshold for drug tissue distribution avg + 2 std of the
    % blank intensity: 
    % Making multiple threshold based on std to visualize spatial drug
    % concentration
    layers = 0:.5:3; % 8 layers = 3 but
    for l=1:length(layers)
        thresh = (2+layers(l))*StdBlankIntensity; % setting threshold for drug
        DrugTissue(DrugTissue < AvgBlankIntensity + thresh) = 0;
        DrugTissueMask = imbinarize(DrugTissue);
        DrugTissueMask = bwareafilt(DrugTissueMask, [10 inf]); % filtering out ROI that are a cluster < 10 pixels
        overlay = imoverlay(Tissue, DrugTissueMask);
        
        imshow(overlay); title(['Tissue With Doxorubicin Threshold STD > ' num2str(2+layers(l))]);
        
        save(['SmuDrugTissueMask_STD_' num2str(2+layers(l)) '.mat'], 'DrugTissueMask');
        
        % pause(1);
    end
    
    cd('..');
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);

end

cd(CodeDir);