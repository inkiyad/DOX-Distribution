function [concentration] = int2con(intensity)

% DOX Fluorescence image intensity calibration.
% This is an example of linear model.

concentration = (intensity - 33.97)./1808.8; %µg/ml
end