import numpy as np
import matplotlib.pyplot as plt
from statsmodels.stats.power import tt_solve_power

# Set parameters
alpha = 0.05
power = 0.80
effect_sizes = np.linspace(0.5, 1, 50)  # Range of effect sizes from 0.5 to 1
sample_sizes = []

# Calculate sample size for each effect size
for effect_size in effect_sizes:
    std_effect_size = effect_size
    n = tt_solve_power(effect_size=std_effect_size, alpha=alpha, power=power, alternative='two-sided')
    sample_sizes.append(n)

# Plot

plt.figure(figsize=(7, 7))
plt.plot(effect_sizes, sample_sizes, marker='o', linestyle='-', markerfacecolor='none', markersize=5, color='firebrick')

plt.title('Sample Size ~ Estimated Effect Size')
plt.xlabel('\n Expected Effect Size \n [ (Expected Difference in Means Before-After) / Standard Deviation]')
plt.ylabel('Calculated Required Sample Size')
plt.grid(True)


plt.show()


