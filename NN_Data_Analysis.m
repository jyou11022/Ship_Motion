%% Storing all the data from the files
addpath('C:\Users\JYou1.DESKTOP-FUCAOQH\Desktop\Research\SCONE_Cdata')

lvl = ['1' '2' '3']; %Char. of the motion lvl - Level# 1:low / 2:moderate / 3:high
dof = ['R' 'H']; %Roll(R) or Heave(H) rate as the primary determinant
deck_loc = ['1' '2']; %Flight Deck Loc. - 1:(-280,-15,-53)ft / 2:(-525,15,-53)ft
case_num = ['1' '2' '3' '4' '5']; %Realization # 1~5 cases (0 for all)
data = cell(3,2,2,5);
for a = 1:3
    for b = 1:2
        for c = 1:2
            for d = 1:5
                file_name = strcat('SCONE_C',lvl(a),dof(b),'_FD',deck_loc(c),'_',case_num(d),'.dat');
                fileID = fopen(file_name,'r');
                C1 = textscan(fileID,'%s',19,'HeaderLines', 3); 
                C2 = textscan(fileID, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 1);
                fclose(fileID);
                id = C1{1}; x=[];
                for i = 1:19
                    x = [x C2{i}];
                end
                data{a,b,c,d} = x;
            end
        end
    end
end
%% Pull the wanted data
lv=1;det=1;
% clearvars -except data C1 lv det
time = data{1,1,1,1}(:,1);
len = length(time);
vert = data{lv,det,1,1}(:,4)';
roll = data{lv,det,1,1}(:,5)';

%% NN
numTImeStepsTrain = floor(0.8*numel(time));

dataTrain = roll(1:numTImeStepsTrain+1);
dataTest = roll(numTImeStepsTrain+1:end);

mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,options);

