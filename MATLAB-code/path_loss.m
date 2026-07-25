function PrE = path_loss(d, P, d0, P0, dE)

% Find n
x = log10(d./d0);
n = (-1/10) * sum((P - P0).*x) / sum(x.^2);

% Calculate the estimated power using the derived n
PrE = P0 - 10 * n * log10(dE./d0);

end