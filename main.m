clearvars

% Input data
replay0 = input('Enter the path to an Excel file with data: ', 's');

data = readmatrix(replay0, "NumHeaderLines", 1);
d = data(:,1);
P = data(:,2);

% Plot data
figure;
plot(d, P, 'o', MarkerFaceColor = 'r',Color = 'r');
xlabel('Distance (m)');
ylabel('Received Power (dBm)');
title('Received Power vs Distance');


% Reference Values
d0 = input('Reference distance in m: ');
P0 = input('Received power at the reference distance in dBm: ');

% Neural Network
num_runs = input('Enter number of training runs for the neural network: ');
[bestNet, best_mu_p, best_sigma_p, best_mu_t, best_sigma_t, best_d_test, best_P_test, best_d_train, best_P_train, best_d_val, best_P_val] = nn_model(d, P, d0, P0, num_runs);

% RMSE for Path Loss Model
PrE_test = path_loss(best_d_train, best_P_train, d0, P0, best_d_test);
rmse_pl = rmse(best_P_test, PrE_test);

fprintf('RMSE of Log-Distance Path Loss Model for the test dataset is %.2f.\n', rmse_pl);

% RMSE for Neural Network Model
rmse_nn_train = nn_rmse(best_d_train, best_P_train, best_mu_p, best_sigma_p, best_mu_t, best_sigma_t, bestNet);
rmse_nn_val = nn_rmse(best_d_val, best_P_val, best_mu_p, best_sigma_p, best_mu_t, best_sigma_t, bestNet);
rmse_nn_test = nn_rmse(best_d_test, best_P_test, best_mu_p, best_sigma_p, best_mu_t, best_sigma_t, bestNet);

fprintf('RMSE of the Neural Network Model for the training test is %.2f.\n', rmse_nn_train);
fprintf('RMSE of the Neural Network Model for the validation test is %.2f.\n', rmse_nn_val);
fprintf('RMSE of the Neural Network Model for the test test is %.2f.\n', rmse_nn_test);

% Predicting Received Power Using Either Method
while true
    replay1 = input("Predict with Path Loss or NN? Enter 'stop' to stop: ", 's');

    if strcmpi(replay1, 'Path Loss') % Predicting with Path Loss
        while true
            dE = input("Enter distance in meters to estimate received power, or 'stop' to stop: ", 's');

            if strcmpi(dE,'stop')
                break
            end

            dE = str2double(dE);

            if isnan(dE)
                disp('Invalid input. Please enter a numeric value.');
                continue;
            end

            PrE = path_loss(d, P, d0, P0, dE);
            fprintf("The received power at distance %d m is %.2f dBm.\n", dE, PrE);
        end

    elseif strcmpi(replay1, 'NN') % Predicting with NN
        while true
            dE = input("Enter distance in meters to estimate received power, or enter 'stop' to stop: ","s");

            if strcmpi(dE, 'stop')
                break
            end

            dE = str2double(dE);

            if isnan(dE)
                disp('Invalid input. Please enter a numeric value.');
                continue;
            end

            dE_norm = (dE - best_mu_p) / best_sigma_p;
            PrE = predict(bestNet, dE_norm) * best_sigma_t + best_mu_t;
            fprintf("The received power at distance %d m is %.2f dBm.\n", dE, PrE);
        end

    elseif strcmpi(replay1, 'stop')
        break

    else
        disp('Wrong input. Try again.');

    end

end