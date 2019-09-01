clear all; close all; clc

%% Gather all the individual concentration exposure data

directory = '/Users/inkiyadga/Documents/Gazi Inkiyad/Beads/Raw';
addpath(genpath([directory 'Code'])); % adding path 
concentration = [0.061215, 1.25, 2.5, 5, 10];
expTime = [400, 100, 75, 50, 40, 30, 25, 20, 15]; 
for l=1:5
RawData = [directory 'Raw/Single Bead Calibration/' num2str(concentration(l)) ' mg\'];
cd(RawData);
load('ExposureStandard.mat');
Intensity(:,l) = avgIntensity;
DisplayName{l} = [num2str(concentration(l)) ' mg/ml'];

figure(1);
hold on;
scatter(expTime, Intensity(:,l));
fit(l,:) = polyfit(expTime([3:9])',Intensity([3:9],l),1);
end
xlabel('Exposure time'); ylabel('Average Intensity');
ylim([0,255]);

for l=1:5
hold on;
plot(expTime(1:9), polyval(fit(l,:), expTime([1:9])'));
end
legend(DisplayName);