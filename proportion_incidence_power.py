import numpy as np
import statsmodels.stats.power as smp

# Set parameters
alpha = 0.05  # Significance level
power = 0.80  # Desired power
p2 = 0.0  # Expected proportion under the alternative hypothesis (if any)

sample_sizes = []

# Calculate sample size for each value of p1
for p1 in np.linspace(0.05, 0.8, 20):
    # Calculate effect size
    effect_size = 2 * (np.arcsin(np.sqrt(p1)) - np.arcsin(np.sqrt(p2)))
    
    # Perform power analysis
    nobs = smp.NormalIndPower().solve_power(effect_size=effect_size, alpha=alpha, power=power, alternative='larger')
    
    sample_sizes.append(nobs)


# Plot
import matplotlib.pyplot as plt

plt.figure(figsize=(7, 7))
plt.plot(np.linspace(0.05, 1, 20), sample_sizes, marker='o', linestyle='-', markerfacecolor='none', markersize=5, color='black')
plt.title('Sample Size ~ Proportion of Patients Developing the Event [Improving]')
plt.xlabel('Proportion of Patients Developing the Event ($p_1$) \n "Event" defined as experiencing a clear clinical benefit')
plt.ylabel('Calculated Required Sample Size \n')
plt.grid(True)
plt.show()
