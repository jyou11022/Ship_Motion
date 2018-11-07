%% Generating sine waves
x = linspace(0,100,20000);
data = sin(3*x);
data2 = exp(0.01*x).*sin(3*x);
plot(data2)
%% Test
numTimeStepsTrain = floor(0.9*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

mu = mean(dataTrain); sig = std(dataTrain);
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
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');

net = trainNetwork(XTrain,YTrain,layers,options);
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','gpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

figure
%plot(dataTrain(1:end-1))
plot(data)
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Cases")
title("Forecast")
legend(["Observed" "Forecast"])

%% Test3
data
numTimeStepsTrain = floor(0.9*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

mu = mean(dataTrain); sig = std(dataTrain);
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

numFeatures = 1;
numResponses = 1;
numHiddenUnits1 = 35;
numHiddenUnits2 = 35;
% numHiddenUnits3 = 100;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
     lstmLayer(numHiddenUnits2,'OutputMode','sequence')
%     lstmLayer(numHiddenUnits3,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',300, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',75, ...
    'LearnRateDropFactor',0.05, ...
    'Verbose',0, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');

net = trainNetwork(XTrain,YTrain,layers,options);
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','gpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

figure
%plot(dataTrain(1:end-1))
plot(data)
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Cases")
title("Forecast")
legend(["Observed" "Forecast"])
sqrt(sum((data(idx)-[data(numTimeStepsTrain) YPred]).^2)/length(idx))

%% Test4
data
numTimeStepsTrain = floor(0.9*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

mu = mean(dataTrain); sig = std(dataTrain);
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

numFeatures = 1;
numResponses = 1;
numHiddenUnits1 = 55;
numHiddenUnits2 = 55;
% numHiddenUnits3 = 100;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
     lstmLayer(numHiddenUnits2,'OutputMode','sequence')
%     lstmLayer(numHiddenUnits3,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',400, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',80, ...
    'LearnRateDropFactor',0.05, ...
    'Verbose',0, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');

net = trainNetwork(XTrain,YTrain,layers,options);
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','gpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

figure
%plot(dataTrain(1:end-1))
plot(data)
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Cases")
title("Forecast")
legend(["Observed" "Forecast"])

%% Test5
data2;
numTimeStepsTrain = floor(0.9*numel(data2));
dataTrain = data2(1:numTimeStepsTrain+1);
dataTest = data2(numTimeStepsTrain+1:end);

% mu = mean(dataTrain); sig = std(dataTrain);
mu = 0; sig = 1;
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

numFeatures = 1;
numResponses = 1;
numHiddenUnits1 = 35;
numHiddenUnits2 = 35;
numHiddenUnits3 = 5;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1,'OutputMode','sequence')
    lstmLayer(numHiddenUnits2,'OutputMode','sequence')
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',300, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',75, ...
    'LearnRateDropFactor',0.05, ...
    'Verbose',0, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');

net = trainNetwork(XTrain,YTrain,layers,options);
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','gpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

figure
%plot(dataTrain(1:end-1))
plot(data2)
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data2(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Cases")
title("Forecast")
legend(["Observed" "Forecast"])

%% Exp testing 2
data2; neuralNet = [];
fileID = fopen('exp_sine_param2.txt','w');
numTimeStepsTrain = floor(0.9*numel(data2));
dataTrain = data2(1:numTimeStepsTrain+1);
dataTest = data2(numTimeStepsTrain+1:end);

% mu = mean(dataTrain); sig = std(dataTrain);
mu = 0; sig = 1;
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
numFeatures = 1;
numResponses = 1;

for i = 3:7
    for j = 2:8
        
        numHiddenUnits1 = 10*i;
        numHiddenUnits2 = 10*j;
        if numHiddenUnits3 == 0
            layers = [ ...
                sequenceInputLayer(numFeatures)
                lstmLayer(numHiddenUnits1,'OutputMode','sequence')
                lstmLayer(numHiddenUnits2,'OutputMode','sequence')
                fullyConnectedLayer(numResponses)
                regressionLayer];
        else
            layers = [ ...
                sequenceInputLayer(numFeatures)
                lstmLayer(numHiddenUnits1,'OutputMode','sequence')
                lstmLayer(numHiddenUnits2,'OutputMode','sequence')
                lstmLayer(numHiddenUnits3,'OutputMode','sequence')
                fullyConnectedLayer(numResponses)
                regressionLayer];
        end
        options = trainingOptions('adam', ...
            'MaxEpochs',250, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',25, ...
            'LearnRateDropFactor',0.4, ...
            'Verbose',0, ...
            'ExecutionEnvironment','gpu');

        net = trainNetwork(XTrain,YTrain,layers,options);
        dataTestStandardized = (dataTest - mu) / sig;
        XTest = dataTestStandardized(1:end-1);

        net = predictAndUpdateState(net,XTrain);
        
        neuralNet = [neuralNet net];
        
        [net,YPred] = predictAndUpdateState(net,YTrain(end));

        numTimeStepsTest = numel(XTest);
        for k = 2:numTimeStepsTest
            [net,YPred(:,k)] = predictAndUpdateState(net,YPred(:,k-1),'ExecutionEnvironment','gpu');
        end

        YPred = sig*YPred + mu;
        YTest = dataTest(2:end);
        rmse(i,j) = sqrt(mean((YPred-YTest).^2));
        A = [i,j,rmse(i,j)];
        disp([i,j,rmse(i,j)]);
        fprintf(fileID,'%6d %6d %12.6f\r\n',A);
% 
%         figure
%         %plot(dataTrain(1:end-1))
%         plot(data2)
%         hold on
%         idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
%         plot(idx,[data2(numTimeStepsTrain) YPred],'.-')
%         hold off
%         xlabel("Month")
%         ylabel("Cases")
%         title("Forecast")
%         legend(["Observed" "Forecast"])
%          sqrt(sum((data2(idx)-[data2(numTimeStepsTrain) YPred]).^2)/length(idx))
    end
end

%% Exp. Test 1

data2; neuralNet = [];
fileID = fopen('exp_sine_param.txt','w');
numTimeStepsTrain = floor(0.9*numel(data2));
dataTrain = data2(1:numTimeStepsTrain+1);
dataTest = data2(numTimeStepsTrain+1:end);

% mu = mean(dataTrain); sig = std(dataTrain);
mu = 0; sig = 1;
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
numFeatures = 1;
numResponses = 1;

for i = 2:5
    for j = 1:11
        
        numHiddenUnits1 = 40;
        numHiddenUnits2 = 15*i;
        numHiddenUnits3 = 15*(j-1);
        if numHiddenUnits3 == 0
            layers = [ ...
                sequenceInputLayer(numFeatures)
                lstmLayer(numHiddenUnits1,'OutputMode','sequence')
                lstmLayer(numHiddenUnits2,'OutputMode','sequence')
                fullyConnectedLayer(numResponses)
                regressionLayer];
        else
            layers = [ ...
                sequenceInputLayer(numFeatures)
                lstmLayer(numHiddenUnits1,'OutputMode','sequence')
                lstmLayer(numHiddenUnits2,'OutputMode','sequence')
                lstmLayer(numHiddenUnits3,'OutputMode','sequence')
                fullyConnectedLayer(numResponses)
                regressionLayer];
        end
        options = trainingOptions('adam', ...
            'MaxEpochs',300, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',75, ...
            'LearnRateDropFactor',0.05, ...
            'Verbose',0, ...
            'ExecutionEnvironment','gpu');

        net = trainNetwork(XTrain,YTrain,layers,options);
        dataTestStandardized = (dataTest - mu) / sig;
        XTest = dataTestStandardized(1:end-1);

        net = predictAndUpdateState(net,XTrain);
        
        neuralNet = [neuralNet net];
        
        [net,YPred] = predictAndUpdateState(net,YTrain(end));

        numTimeStepsTest = numel(XTest);
        for k = 2:numTimeStepsTest
            [net,YPred(:,k)] = predictAndUpdateState(net,YPred(:,k-1),'ExecutionEnvironment','gpu');
        end

        YPred = sig*YPred + mu;
        YTest = dataTest(2:end);
        rmse(i,j) = sqrt(mean((YPred-YTest).^2));
        A = [i,j,rmse(i,j)];
        disp([i,j,rmse(i,j)]);
        fprintf(fileID,'%6d %6d %12.6f\r\n',A);
% 
%         figure
%         %plot(dataTrain(1:end-1))
%         plot(data2)
%         hold on
%         idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
%         plot(idx,[data2(numTimeStepsTrain) YPred],'.-')
%         hold off
%         xlabel("Month")
%         ylabel("Cases")
%         title("Forecast")
%         legend(["Observed" "Forecast"])
%          sqrt(sum((data2(idx)-[data2(numTimeStepsTrain) YPred]).^2)/length(idx))
    end
end

%% Exp. Test 4

data2; neuralNet = [];
fileID = fopen('exp_sine_param4.txt','w');
numTimeStepsTrain = floor(0.9*numel(data2));
dataTrain = data2(1:numTimeStepsTrain+1);
dataTest = data2(numTimeStepsTrain+1:end);

% mu = mean(dataTrain); sig = std(dataTrain);
mu = 0; sig = 1;
dataTrainStandardized = (dataTrain - mu) / sig;

XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);
numFeatures = 1;
numResponses = 1;

numHiddenUnits1 = 35;
numHiddenUnits2 = 35;
i = 1

for j = 1:20
    numHiddenUnits3 = 3*j;
    if numHiddenUnits3 == 0
        layers = [ ...
            sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits1,'OutputMode','sequence')
            lstmLayer(numHiddenUnits2,'OutputMode','sequence')
            fullyConnectedLayer(numResponses)
            regressionLayer];
    else
        layers = [ ...
            sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits1,'OutputMode','sequence')
            lstmLayer(numHiddenUnits2,'OutputMode','sequence')
            lstmLayer(numHiddenUnits3,'OutputMode','sequence')
            fullyConnectedLayer(numResponses)
            regressionLayer];
    end
    options = trainingOptions('adam', ...
        'MaxEpochs',240, ...
        'GradientThreshold',1, ...
        'InitialLearnRate',0.005, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',24, ...
        'LearnRateDropFactor',0.04, ...
        'Verbose',0, ...
        'ExecutionEnvironment','gpu');

    net = trainNetwork(XTrain,YTrain,layers,options);
    dataTestStandardized = (dataTest - mu) / sig;
    XTest = dataTestStandardized(1:end-1);

    net = predictAndUpdateState(net,XTrain);

    neuralNet = [neuralNet net];

    [net,YPred] = predictAndUpdateState(net,YTrain(end));

    numTimeStepsTest = numel(XTest);
    for k = 2:numTimeStepsTest
        [net,YPred(:,k)] = predictAndUpdateState(net,YPred(:,k-1),'ExecutionEnvironment','gpu');
    end

    YPred = sig*YPred + mu;
    YTest = dataTest(2:end);
    rmse(i,j) = sqrt(mean((YPred-YTest).^2));
    A = [i,j,rmse(i,j)];
    disp([i,j,rmse(i,j)]);
    fprintf(fileID,'%6d %6d %12.6f\r\n',A);
% 
%         figure
%         %plot(dataTrain(1:end-1))
%         plot(data2)
%         hold on
%         idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
%         plot(idx,[data2(numTimeStepsTrain) YPred],'.-')
%         hold off
%         xlabel("Month")
%         ylabel("Cases")
%         title("Forecast")
%         legend(["Observed" "Forecast"])
%          sqrt(sum((data2(idx)-[data2(numTimeStepsTrain) YPred]).^2)/length(idx))

end


%% Exp Sine Ttests
%4      5     0.452917
%40;60;75

%6      8     0.455560
%60,80,0
net = neuralNet(12);
net = resetState(net);
net = predictAndUpdateState(net,XTrain);

[net,YPred] = predictAndUpdateState(net,YTrain(18000));

numTimeStepsTest = numel(XTest);
for k = 2:numTimeStepsTest
    [net,YPred(:,k)] = predictAndUpdateState(net,YPred(:,k-1),'ExecutionEnvironment','gpu');
end

YPred = sig*YPred + mu;
YTest = dataTest(2:end);
rmse = sqrt(mean((YPred-YTest).^2))

figure
%plot(dataTrain(1:end-1))
plot(data2)
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data2(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Month")
ylabel("Cases")
title("Forecast")
legend(["Observed" "Forecast"])
 sqrt(sum((data2(idx)-[data2(numTimeStepsTrain) YPred]).^2)/length(idx))