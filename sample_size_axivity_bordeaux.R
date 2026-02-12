# Load required library
library(ggplot2)

# Function to compute sample size for correlation
sample_size_corr <- function(r, power = 0.80, alpha = 0.05) {
  z_alpha <- qnorm(1 - alpha/2)
  z_beta  <- qnorm(power)
  fisher_z <- 0.5 * log((1 + r)/(1 - r))
  n <- ((z_alpha + z_beta)^2 / fisher_z^2) + 3
  return(ceiling(n))
}

# Sequence of correlation coefficients
r_values <- seq(0.25, 0.75, by = 0.01)

# Compute sample sizes for 80% and 90% power
n_80 <- sapply(r_values, sample_size_corr, power = 0.80)
n_90 <- sapply(r_values, sample_size_corr, power = 0.90)

# Create dataframe
df <- data.frame(
  r = rep(r_values, 2),
  SampleSize = c(n_80, n_90),
  Power = factor(rep(c("80% Power", "90% Power"), each = length(r_values)))
)

# Plot
ggplot(df, aes(x = r, y = SampleSize, color = Power)) +
  geom_line(size = 2.2) +
  labs(
    title = "Required Sample Size \nDetect Correlation",
    subtitle = "Two-sided alpha = 0.05",
    x = "\n Expected Correlation Coefficient (r)",
    y = "Required Sample Size (n) \n",
    color = "Power"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "top"
  ) +
  scale_colour_manual(values=c("#8499b1", "#7b6d8d"))
