%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

addpath(genpath('..'));

%% Loading images
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor images *W* locates all folders W as a name

for i=1:length(sample)
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    
    load('Stats.mat');
    
    GroupDrugIntensity(i) = MeanDrugIntensity;
    
    cd('..');
    %% Progress - Just to see the progress of the code
    progress = i;
    progress = i/length(sample)*100;
    disp([num2str(progress) '%']);
end

MuAllDrugIntensity_25std = mean(GroupDrugIntensity);
StdAllDrugIntensity_25std = std(GroupDrugIntensity);

save([directory '/Stats/GroupStats.mat'], 'MuAllDrugIntensity_25std', 'StdAllDrugIntensity_25std');