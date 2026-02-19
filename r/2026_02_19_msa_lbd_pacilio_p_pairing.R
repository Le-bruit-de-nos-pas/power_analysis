library(tidyverse)
library(data.table)
library(dplyr)
library(MatchIt)


msa_lbd_pacilio_p_pairing <- fread("msa_lbd_pacilio_p_pairing.csv")

msa_lbd_pacilio_p_pairing %>% group_by(group, sex) %>% count()

#   group   sex     n
# 1 LBD       0    20
# 2 LBD       1     3
# 3 MSA       0    41
# 4 MSA       1    45

# Not possible to match 3:1 for the males
# Even if we ignored age we would need 60 MSA males (only have 45)


data <- msa_lbd_pacilio_p_pairing

data <- data %>%
  mutate(
    group = factor(group, levels = c("MSA", "LBD")),
    sex = factor(sex)
  )


female_data <- data %>% filter(sex == 1)

match_female <- matchit(
  group ~ eval_age,
  data = female_data,
  method = "nearest",
  ratio = 3,
  replace = FALSE
)


male_data <- data %>% filter(sex == 0)

match_male <- matchit(
  group ~ eval_age,
  data = male_data,
  method = "nearest",
  ratio = 2,
  replace = FALSE
)



matched_female <- match.data(match_female)
matched_female %>% arrange(subclass, group)

matched_male <- match.data(match_male)
matched_male %>% arrange(subclass, group)

matched_final <- bind_rows(matched_female, matched_male)

summary(match_female)

# Call:
# matchit(formula = group ~ eval_age, data = female_data, method = "nearest", 
#     replace = FALSE, ratio = 3)
# 
# Summary of Balance for All Data:
#          Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance         0.199        0.0534          1.1896     1.5157    0.4046   0.8667
# eval_age        73.440       63.4691          4.2457     0.1015    0.4046   0.8667
# 
# Summary of Balance for Matched Data:
#          Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max Std. Pair Dist.
# distance         0.199        0.1496          0.4032     5.3831    0.0463   0.4444          0.5208
# eval_age        73.440       72.5011          0.3998     3.2632    0.0463   0.4444          0.5578
# 
# Sample Sizes:
#           Control Treated
# All            45       3
# Matched         9       3
# Unmatched      36       0
# Discarded       0       0

summary(match_male)

# Call:
# matchit(formula = group ~ eval_age, data = male_data, method = "nearest", 
#     replace = FALSE, ratio = 2)
# 
# Summary of Balance for All Data:
#          Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max
# distance        0.5783        0.2057          1.4430     1.3663    0.3634    0.578
# eval_age       73.4615       62.9356          1.8706     0.5381    0.3634    0.578
# 
# Summary of Balance for Matched Data:
#          Means Treated Means Control Std. Mean Diff. Var. Ratio eCDF Mean eCDF Max Std. Pair Dist.
# distance        0.5783        0.2108          1.4234     1.3616    0.3541    0.575          1.4243
# eval_age       73.4615       63.3393          1.7988     0.5918    0.3541    0.575          1.8008
# 
# Sample Sizes:
#           Control Treated
# All            41      20
# Matched        40      20
# Unmatched       1       0
# Discarded       0       0

matched_final %>%
  group_by(group, sex) %>%
  summarise(mean_age = mean(eval_age),
            sd_age = sd(eval_age),
            n = n())

#   group sex   mean_age sd_age     n
# 1 MSA   0         63.3   7.31    40
# 2 MSA   1         72.5   1.30     9
# 3 LBD   0         73.5   5.63    20
# 4 LBD   1         73.4   2.35     3

abs(matched_final$distance)

#  [1] 0.172346402 0.088603723 0.103576058 0.156673332 0.114973061 0.259625787 0.170593937 0.171030722 0.109144092 0.131266060
# [11] 0.125402367 0.340193773 0.053850728 0.319196293 0.260557543 0.012027594 0.343980436 0.020468609 0.064131386 0.040927305
# [21] 0.517094981 0.030157064 0.007541984 0.025117841 0.026926807 0.059709231 0.057092073 0.046596753 0.770023943 0.398916502
# [31] 0.427764047 0.477251669 0.099557326 0.434769117 0.140705088 0.053127756 0.017019908 0.106143656 0.023210654 0.674295530
# [41] 0.179596885 0.267961053 0.002917530 0.161433141 0.269363963 0.151081391 0.353167455 0.330154380 0.860008066 0.213745034
# [51] 0.011421030 0.122250516 0.366322947 0.607050996 0.636150560 0.839365432 0.252837928 0.547305266 0.536079162 0.653050765
# [61] 0.341835338 0.193310764 0.718517886 0.908159382 0.930450522 0.921314907 0.633391665 0.840006202 0.286555899 0.810550426
# [71] 0.448854967 0.094960824

matched_final <- matched_final %>% filter(!is.na(subclass))

# Compute within-set age differences
age_diffs <- matched_final %>%
  group_by(subclass) %>%
  summarise(
    ages = list(eval_age),
    max_age = max(eval_age),
    min_age = min(eval_age),
    max_diff = max(eval_age) - min(eval_age)
  )

# View largest differences
age_diffs %>% arrange(desc(max_diff))

#   subclass ages      max_age min_age max_diff
#  1 14       <dbl [3]>    82.0    63.4     18.6
#  2 12       <dbl [3]>    81.3    62.7     18.6
#  3 4        <dbl [3]>    78.6    60.1     18.5
#  4 13       <dbl [3]>    82.6    64.1     18.5
#  5 16       <dbl [3]>    78.6    60.4     18.2
#  6 18       <dbl [3]>    77.8    59.9     17.9
#  7 1        <dbl [7]>    73.2    55.4     17.7
#  8 3        <dbl [7]>    76.2    59       17.2
#  9 2        <dbl [7]>    73.5    57.1     16.4
# 10 7        <dbl [3]>    72.3    56.3     16.0
# 11 11       <dbl [3]>    75.6    59.6     16.0
# 12 6        <dbl [3]>    72.5    56.6     15.9
# 13 15       <dbl [3]>    74.0    58.4     15.6
# 14 20       <dbl [3]>    62.4    47.2     15.3
# 15 19       <dbl [3]>    70.8    56.0     14.8
# 16 8        <dbl [3]>    74.3    59.6     14.8
# 17 17       <dbl [3]>    67.8    53.2     14.7
# 18 10       <dbl [3]>    65.7    51.2     14.5
# 19 9        <dbl [3]>    68.9    54.6     14.3
# 20 5        <dbl [3]>    67.1    52.9     14.2

balance_table <- matched_final %>%
  group_by(group, sex) %>%
  summarise(
    n = n(),
    mean_age = mean(eval_age),
    sd_age = sd(eval_age)
  ) %>%
  ungroup()

balance_table

#   group sex       n mean_age sd_age
# 1 MSA   0        40     63.3   7.31
# 2 MSA   1         9     72.5   1.30
# 3 LBD   0        20     73.5   5.63
# 4 LBD   1         3     73.4   2.35

age_diffs %>%
  inner_join(matched_final %>% select(subclass, sex) %>% distinct(), by="subclass") %>%
  group_by(sex) %>%
  summarise(
    max_diff_overall = max(max_diff),
    mean_diff = mean(max_diff),
    median_diff = median(max_diff)
  )

#  sex   max_diff_overall mean_diff median_diff
# 1 0                 18.6      16.4        16.0
# 2 1                 17.7      17.1        17.2

matched_final <- matched_final %>% arrange(sex, subclass, group)


fwrite(matched_final, "matched_final.csv")
