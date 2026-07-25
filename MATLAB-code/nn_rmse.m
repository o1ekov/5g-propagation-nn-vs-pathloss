function rmse_nn = nn_rmse(d_set, P_set, mu_p, sigma_p, mu_t, sigma_t, netTrainned)
% Calculate RMSE for the neural network

d_norm = (d_set - mu_p) / sigma_p;
P_pred = predict(netTrainned, d_norm) * sigma_t + mu_t;
rmse_nn = rmse(P_set, P_pred);

end