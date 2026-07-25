Since $P_r = P_0 - 10 * n * log_{10}(d / d_0)$ is a linear approximation, we can treat it like $y = mx + b$, where 
<ul>
  <li> $y = P_r$ </li>
  <li> $m = -10 * n$ </li>
  <li> $x = log_{10}(d / d_0)$ </li>
  <li> $b = P_0$ </li>
</ul>


The sum of the squared errors:

$$J(n) = \sum_{i = 1}^k (P_i - P_{ri}) ^2$$

Where $P$ is measured value and $P_r$ is an estimation.

Substituting $y = mx + b$, we get:

$$J(m) = \sum_{i = 1}^k (P_i - m * x_i - b) ^2$$

In order to minimize an error, we take the derivative of the equation above with respect to $m$.

$$J'(m) = -2\sum_{i = 1}^k x_i * (P_i - m * x_i - b)$$
$$0 = \sum_{i = 1}^k x_i * (P_i - b)\ - \sum_{i = 1}^k m * x_i^2$$

Since $m$ is a constant slope, we can pull it out of the summation:

$$m * \sum_{i = 1}^k x_i^2\ = \sum_{i = 1}^k x_i * (P_i - b)$$
$$m = \sum_{i = 1}^k x_i * (P_i - b)\ / \sum_{i = 1}^k x_i^2$$

Substituting the estimation model back, we get:

$$n = -\sum_{i = 1}^k log_{10}(d_i / d_0) * (P_i - P_0) / 10\sum_{i = 1}^k (log_{10}(d_i / d_0))^2$$

Where
<ul>
  <li> $d_0$&mdash;reference distance in m </li>
  <li> $d$&mdash;measured distance in m </li>
  <li> $i$&mdash;index of a measurement </li>
  <li> $k$&mdash;number of measurements </li>
  <li> $n$&mdash;path loss exponent </li>
  <li> $P_0$&mdash;reference received power in dBm </li>
  <li> $P$&mdash;measured received power in dBm </li>
</ul>
