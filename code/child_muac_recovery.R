###############################################
# Child MUAC Recovery Analysis Script
# Author: jie zhao
###############################################

library(dplyr)
library(ggplot2)
library(readr)

#===============================
# 1. Load data from Data/
#===============================
df <- read.csv(here::here("data", "f75_interim.csv"))
#===============================
# 2. Age group categorization
#===============================
df <- df %>%
  mutate(
    age_group = case_when(
      agemons < 12 ~ "0–12 months",
      agemons >= 12 & agemons < 24 ~ "12–24 months",
      agemons >= 24 & agemons <= 59 ~ "24–59 months",
      TRUE ~ NA_character_
    )
  )

#===============================
# 3. Compute MUAC relative change (%)
#===============================
df <- df %>%
  mutate(muac_change_pct = ((muac2 - muac) / muac) * 100)

#===============================
# 4. Summary statistics by age group
#===============================
summary_stats <- df %>%
  group_by(age_group) %>%
  summarise(
    n = n(),
    mean_change = mean(muac_change_pct, na.rm = TRUE),
    median_change = median(muac_change_pct, na.rm = TRUE),
    sd_change = sd(muac_change_pct, na.rm = TRUE)
  )

# save to Output/
write_csv(summary_stats, "../Output/muac_summary_stats.csv")

#===============================
# 5. Visualization—boxplot
#===============================
p <- ggplot(df, aes(x = age_group, y = muac_change_pct)) +
  geom_boxplot(fill = "#6baed6", alpha = 0.7) +
  labs(
    title = "Relative MUAC Recovery Across Age Groups",
    x = "Age Group",
    y = "MUAC Change (%)"
  ) +
  theme_minimal()

ggsave("../Output/muac_recovery_boxplot.png", p, width = 8, height = 5)
