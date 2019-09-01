%% WARNING - Run cell by cell by pressing [CTRL] + [ENTER] to preserve necessary results

clear all; close all; clc;

CodeDir = pwd;
addpath(genpath('..'));

%% Loading stats
directory = '../../Data/Tissue Samples'; % Data directory to Tissue Samples
cd([directory '/Stats']);
load(fullfile('DrugTumor.mat'));

cd(directory); % change directory to [directory]
sample = dir('W*'); % Locate all the woodchuck tumor image directory W* locates all folders W as a name

for i=1:length(sample)
    % Implementing to automate the process
    cd(sample(i).name); % change directory to [sample directory] with image
    load(fullfile('Stats.mat'));
    names{i} = sample(i).name; % saving sample names
    AreaARRAY(i,1) = DrugArea;
    AreaARRAY(i,2) = BeadArea;
    MuIntensityARRAY(i) = MeanDrugIntensity;
    StdIntensityARRAY(i) = StdDrugIntensity;
    MeanConcentrationARRAY(i) = MeanConcentration;
    StdConcentrationARRAY(i) = StdConcentration;
    TotalDrugARRAY(i) = TotalDrug;
    
    cd('..')
end
names = categorical(names);

%% Figure 1
 % state the names cell is categorical or matlab will show error message
figure(1);
yyaxis left
Drug = bar(names, [MeanConcentrationARRAY(:), zeros(length(sample),1)],1);
ylabel('Mean Conentration (µg/ml)','FontSize', 12); 

% hold on;
% er = errorbar(names, double(MeanConcentrationARRAY), StdConcentrationARRAY(:));
% er.Color = [0,0,0];
% er.LineStyle = 'none';
% hold off;

yyaxis right
Bead = bar(names, [zeros(length(sample),1), TotalDrugARRAY(:)],1);
ylabel('Total Drug Mass (µg)','FontSize', 12);

set(gca,'TickLabelInterpreter', 'none');
xticks('auto'); xtickangle(45); title('Mean DOX Concentration and Total Drug Mass');
xlabel('Sample Name', 'FontSize', 12);

%% Figure 2
figure(2);
scatter(TotalDrugARRAY, AreaARRAY(:,2));
title('Tissue Drug Area vs Bead Area');
xlabel('Bead Area (cm)'); ylabel('Drug Area (cm)');

%% Figure 3
figure(3);
b = bar(names, MuIntensityARRAY);
%set(b, 'FaceColor', 'red');
hold on;
er = errorbar(names, double(MuIntensityARRAY), StdIntensityARRAY);
er.Color = [0,0,0];
er.LineStyle = 'none';
hold off;

set(gca,'TickLabelInterpreter', 'none');
xticks('auto'); xtickangle(45); title({'Mean Pixel (8-bit) Intensity in Drug Mask', ... 
                                    'Thresholding Above 2 STD of Blank Mean Pixel Intensity'});
xlabel('Sample Name', 'FontSize', 12);
ylabel('Intensity', 'FontSize', 12);

%% Figure 4
figure(4);
bar(MuConDrugTumor);
hold on;
er = errorbar(double(MuConDrugTumor), StdConDrugTumor);
er.Color = [0,0,0];
er.LineStyle = 'none';
hold off;

title('Mean DOX Concentration');
xlabel('Woodchuck Tumor Label');
ylabel('Mean DOX Concentration (µg/ml)');

cd(CodeDir);