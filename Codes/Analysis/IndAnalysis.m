%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

conversion = 1.29; % microns in 1 pixel
micro2centi = 1/10000; % microns in 1 cm

    DrugIntTumor = {};
for i=1:length(sample)
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    file = dir('W*.tif'); % locate all images that has name starting with W
    filename = file.name; % extracting string from a struct
    img = imread(fullfile(filename)); % reading the image file
    
    %% Area positive
    load(fullfile('SmuDrugTissueMask_STD_2.5.mat'));
    DrugArea = sum(DrugTissueMask(:))*(conversion^2)*(micro2centi^2);
    DrugVolume = sum(DrugTissueMask(:))*(10/1.3)*(conversion^3)*(micro2centi^3); % ml^3
    
    % Percent area positive
    load(fullfile('TissueMask2.mat'));
    TissueArea = sum(TissueMask(:))*(conversion^2)*(micro2centi)^2;
    PercentDrugArea = 100*(DrugArea/TissueArea);
    
    
    %% Mean intensity (concentration) of eluted drug
    % mean pixel intensity in tissue mask (without beads)
    MeanDrugIntensity = mean(img(DrugTissueMask==1));
    StdDrugIntensity = std(double(img(DrugTissueMask==1)));
    
    %% Conversion from pixel intensity to concentration
    MeanConcentration = int2con(MeanDrugIntensity); %µg/ml
    StdConcentration = int2con(StdDrugIntensity); %µg/ml
    
    
    %% Beads
    load(fullfile('BeadMask.mat'));
    % total bead area
    BeadArea = sum(BeadMask(:))*(conversion^2)*(micro2centi)^2;
    % BeadVol = sum(BeadMask(:))*10*(conversion^3); % µm^3
    
    %% Total Drug
    % Mean volume intensity x Total Drug Mask Volume
    TotalDrug = MeanConcentration*DrugVolume; 
    
    %% Saving
    save('Stats.mat', 'DrugArea', 'TissueArea', 'PercentDrugArea', ... 
        'MeanDrugIntensity', 'BeadArea', 'StdDrugIntensity', 'TotalDrug',...
        'MeanConcentration', 'StdConcentration');
    
    cd('..');
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

cd(CodeDir);