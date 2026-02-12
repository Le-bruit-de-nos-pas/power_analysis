import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

def sample_size_corr(r, power=0.80, alpha=0.05):
    z_alpha = norm.ppf(1 - alpha/2)
    z_beta = norm.ppf(power)
    fisher_z = 0.5 * np.log( (1+r) / (1-r) )
    n = ((z_alpha+z_beta)**2 / fisher_z**2) + 3
    return np.ceil(n)

r_values = np.arange(0.25, 0.751, 0.01)

print(r_values)

n_80 = [sample_size_corr(r, power=0.80) for r in r_values]
n_90 = [sample_size_corr(r, power=0.90) for r in r_values]

print(n_80)
print(n_90)

plt.figure(figsize=(5, 5))
plt.plot(r_values, n_80, linewidth=4, label="80% Power", color="#8499b1")
plt.plot(r_values, n_90, linewidth=4, label="90% Power", color="#7b6d8d")
plt.title("Required Sample Size\nDetect Correlation [alpha 0.05]\n", fontsize=10, fontweight="bold", loc='left')
plt.xlabel("\nExpected Correlation Coefficient (r)")
plt.ylabel("Required Sample Size (n)\n")

plt.legend(loc="upper right")
plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("sample_size_correlation.svg", format="svg")
plt.show()