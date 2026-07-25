function [bestNet, best_mu_p, best_sigma_p, best_mu_t, best_sigma_t, best_d_test, best_P_test, best_d_train, best_P_train, best_d_val, best_P_val] = nn_model(d, P, d0, P0, num_runs)
% Neural Network

% Set of RMSE for validation set
rmse_val_all = zeros(num_runs,1);

for run = 1:num_runs

    [d_train, P_train, d_val, P_val, d_test, P_test] = get_sets(d, P, d0, P0);

    % Training data
    predictors = d_train;        
    target = P_train;

    % Validation data
    predictors_val = d_val;
    target_val = P_val;

    % Standardization
    [predictors_norm, mu_p, sigma_p] = normalize(predictors);
    [target_norm, mu_t, sigma_t] = normalize(target);

    predictors_val_norm = (predictors_val - mu_p) / sigma_p;
    target_val_norm = (target_val - mu_t) / sigma_t;

    % Network
    net = dlnetwork;

    Layers = [
        featureInputLayer(1)

        fullyConnectedLayer(16)
        batchNormalizationLayer
        reluLayer
        dropoutLayer(0.2)

        fullyConnectedLayer(4)
        batchNormalizationLayer
        reluLayer

        fullyConnectedLayer(1)
    ];

    net = addLayers(net,Layers);

    % Training Options
    train_opt = trainingOptions('adam',...
        InitialLearnRate = 0.001, ...
        LearnRateSchedule = 'piecewise', ...
        LearnRateDropFactor = 0.5, ...
        LearnRateDropPeriod = 1000, ...
        MaxEpochs = 5000, ...
        ValidationData = {predictors_val_norm,target_val_norm}, ...
        ValidationFrequency = 50, ...
        ValidationPatience = 100, ...
        Metrics = ["rsquared","rmse"], ...
        ObjectiveMetricName = "loss", ...
        OutputNetwork = 'best-validation',...
        Plots = 'training-progress' ...
        );

    % Train the network
    netTrainned = trainnet(predictors_norm,target_norm,net,'mse',train_opt);

    % Validation RMSE
    d_val_norm = (d_val - mu_p) / sigma_p;
    P_val_pred = predict(netTrainned, d_val_norm) * sigma_t + mu_t;
    rmse_val_all(run) = rmse(P_val, P_val_pred);

    if run == 1 || rmse_val_all(run) < min(rmse_val_all(1:run-1))

        bestNet = netTrainned;

        best_mu_p = mu_p;
        best_sigma_p = sigma_p;
        best_mu_t = mu_t;
        best_sigma_t = sigma_t;

        best_d_train = d_train;
        best_P_train = P_train;

        best_d_val = d_val;
        best_P_val = P_val;

        best_d_test = d_test;
        best_P_test = P_test;

    end

end

d_plot = linspace(min(d),max(d),500);
d_plot_norm = (d_plot - best_mu_p) / best_sigma_p;
d_plot_norm = d_plot_norm';

y_plot_norm = predict(bestNet, d_plot_norm);        
y_plot = y_plot_norm * best_sigma_t + best_mu_t;

figure(2);
scatter(d_train,P_train,'red','filled')
       
hold on
scatter(d_val,P_val,'green','filled')
hold on
scatter(d_test,P_test,'blue','filled')
hold on
plot(d_plot,y_plot);
title('Neural Network Model')
xlabel('Distance (m)'), ylabel('Received Power (dBm)')
legend('Training data','Validation data','Testing data','NN Model')


end