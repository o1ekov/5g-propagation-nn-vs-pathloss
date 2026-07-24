# Received Power Estimation for Urban 5G Propagation: Comparing Path Loss Modeling and Machine Learning

Author: Oleksandr Kovalchuk

A comparison of a classical log-distance path loss model with a neural network for predicting received power from distance, using real 5G measurements.

## Problem Statement
Mobile networks require accurate received power prediction for reliable coverage planning. Traditional analytical models rely on simplified assumptions about signal propagation that may not take into an account complex real world environment. The objective of this project is to investigate whether or not a data-driven neural network approach can learn the relationship between distance and received power purely from empirical measurements, without any prior knowledge of the propagation physics.

## Data
~100 field measurements of distane (m) and received power (dBm), collected for a 5G link. Full dataset is in [measurements.csv](measurements.csv).

<img width="1180" height="775" alt="image" src="https://github.com/user-attachments/assets/e159a290-dabd-4460-bd62-336131dd3fe8" />

## Methods
### 1. Mathematical Model&mdash;Log-Distance Path Loss
Received power is estimated using the standard log-distance path loss model:

$$P_r(d) = P_0 - 10 * n * log_{10}(d / d_0)$$

where $n$ is the path loss exponent and $d0$ is a reference distance. The exponent n was derived using the sum of squared errors. (see [path_loss_deriviation.md](path_loss_deriviation.md))

For this project, $d_0 = 100m$ and $P_0 = 0dBm$.

### 2. Neural Network Model
A feedforward neural network trained on the same data, using only distance as input&mdash;no physics priors:

<ul>
  <li> Architecture: FC(16) &rarr; BatchNowm &rarr; ReLU &rarr; Dropout(0.2) &rarr; FC(4) &rarr; BatchNorm &rarr; ReLU &rarr; FC(1) </li>
  <li> Optimizer: Adam </li>
  <li> Initial Learning Rate: 0.001, piecewise decay </li> 
  <li> Data split: 70% train, 15% validation, 15% test </li>  
  <li> Standardized inputs and outputs (z-score normalization) </li>
</ul>

Model selection is based on the best validation-set performance across multiple training runs.

Full MATLAB implementation code can be found in ...
