# Received Power Estimation for Urban 5G Propagation: Comparing Path Loss Modeling and Machine Learning using MATLAB

Author: Oleksandr Kovalchuk

A comparison of a classical log-distance path loss model with a neural network for predicting received power from distance, using real 5G measurements.

## Problem Statement
Mobile networks require accurate received power prediction for reliable coverage planning. Traditional analytical models rely on simplified assumptions about signal propagation that may not take into an account complex real world environment. The objective of this project is to investigate whether or not a data-driven neural network approach can learn the relationship between distance and received power purely from empirical measurements, without any prior knowledge of the propagation physics.

## Data
~100 field measurements of distance (m) and received power (dBm), collected for a 5G link. Full dataset is in [measurements.csv](measurements.csv).

<img width="1180" height="775" alt="image" src="https://github.com/user-attachments/assets/e159a290-dabd-4460-bd62-336131dd3fe8" />

## Methods
### 1. Mathematical Model&mdash;Log-Distance Path Loss
Received power is estimated using the standard log-distance path loss model:

$$P_r(d) = P_0 - 10 * n * log_{10}(d / d_0)$$

where $n$ is the path loss exponent and $d0$ is a reference distance. The exponent n was derived using the sum of squared errors. (see [path_loss_deriviation.md](path_loss_deriviation.md))

For this project, $d_0 = 100m$ and $P_0 = 0dBm$ are used.

### 2. Neural Network Model
A feedforward neural network trained on the same data, using only distance as input&mdash;no physics priors:

<ul>
  <li> Architecture: FC(16) &rarr; BatchNorm &rarr; ReLU &rarr; Dropout(0.2) &rarr; FC(4) &rarr; BatchNorm &rarr; ReLU &rarr; FC(1) </li>
  <li> Optimizer: Adam </li>
  <li> Initial Learning Rate: 0.001, piecewise decay </li> 
  <li> Data split: 70% train, 15% validation, 15% test </li>  
  <li> Standardized inputs and outputs (z-score normalization) </li>
</ul>

Neural Netwotk Trainning Progress:
<img width="1400" height="700" alt="progress" src="https://github.com/user-attachments/assets/8b3eee49-8daa-45a0-85a3-d57722b008d4" />


Model selection is based on the best validation-set performance across multiple training runs.

MATLAB code for the neural network can be found in [nn_model.m](MATLAB-code/nn_model.m).

## Results
| Model | Test RMSE |
| :---: | :---: |
| Mathematical Model | 4.31 |
| Neural Network Model | 4.41 |


| Distance (m) | Mathematical Model (dBm) | Neural Network Model (dBm) |
| :---: | :---: | :---:|
| 150 | -7.83 | -10.02 |
| 300 | -21.21 | -17.09 |
| 800 | -40.15 | -40.81 |
| 2000 | -57.84 | -57.45 |
| 3000 | -65.67 | -64.90 |
| 4000 | -71.22 | -76.83 |

<img width="1180" height="775" alt="image" src="https://github.com/user-attachments/assets/0b8c7fdf-8cda-49cb-889e-e098132ae513" />

<img width="1180" height="775" alt="image" src="https://github.com/user-attachments/assets/d3f13643-99d8-45fe-825c-f46545479744" />

## Conclusion
The mathematical model outperformed the neural network, achieving the RMSE of 4.41 dB in comparison to 4.31 dB. This shows that mathematical model is superior while working with limited sets of data, yet the difference is not significant.

The neural network successfully learned the path loss relationship purely based on empirical data with no physics knowledge given, closing within 0.1 dB of the mathematical model.

Future works should implement broader input features such as frequency and environment conditions, alongside larger data sets, to unlock full potential of the neural network.

## Requirements
<ul>
  <li> MATLAB </li>
  <li> Statistics and Machine Learning ToolBox </li>
  <li> Deep Learning ToolBox </li>
</ul>



