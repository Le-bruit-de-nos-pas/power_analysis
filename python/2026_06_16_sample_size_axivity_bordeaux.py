import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# ----------------------------
# Parameters
# ----------------------------
alpha = 0.05
power = 0.80
m = 3

icc_values = np.arange(0.30, 0.80, 0.05)
r_values = np.arange(0.25, 0.751, 0.01)

# ----------------------------
# Independent sample size
# ----------------------------
def sample_size_independent(r, power=0.80, alpha=0.05):
    z_alpha = norm.ppf(1 - alpha/2)
    z_beta = norm.ppf(power)
    fisher_z = 0.5 * np.log((1+r)/(1-r))
    n = ((z_alpha + z_beta)**2 / fisher_z**2) + 3
    return n

# ----------------------------
# Repeated-measures adjustment
# ----------------------------
def sample_size_repeated(r, icc, m=3, power=0.80, alpha=0.05):
    n_indep = sample_size_independent(r, power, alpha)
    design_effect = 1 + (m - 1) * icc
    n_subjects = (n_indep * design_effect) / m
    return np.ceil(n_subjects)

# ----------------------------
# Plot
# ----------------------------
fig, ax = plt.subplots(figsize=(6, 6))

cmap = plt.cm.Blues
norm_icc = plt.Normalize(icc_values.min(), icc_values.max())

for icc in icc_values:
    n_vals = [sample_size_repeated(r, icc, m) for r in r_values]
    ax.plot(
        r_values,
        n_vals,
        linewidth=2,
        color=cmap(norm_icc(icc))
    )

# Create ScalarMappable for colorbar
sm = plt.cm.ScalarMappable(cmap=cmap, norm=norm_icc)
sm.set_array([])

cbar = fig.colorbar(sm, ax=ax)
cbar.set_label("Intraclass Correlation (ICC)")

ax.set_title(
    "Required Number of Subjects\nRepeated Measures Design (m = 3)\n80% Power, α = 0.05",
    fontsize=11,
    fontweight="bold",
    loc='left'
)

ax.set_xlabel("\nExpected Correlation Coefficient (r)")
ax.set_ylabel("Required Number of Subjects (N)\n")

ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("sample_size_repeated_measures_gradient.svg", format="svg")
plt.show()
