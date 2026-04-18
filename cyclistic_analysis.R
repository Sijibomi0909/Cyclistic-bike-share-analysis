# ============================================================
# CYCLISTIC CASE STUDY - DATA VISUALIZATION & ANALYSIS
# Analyst: Oluwasijibomi Oderinde
# Date: 16/04/2026
# Tools: R 4.5.3, tidyverse, ggplot2, patchwork
# Time Period: April 2025 - March 2026
# ============================================================

# ------------------------------------------------------------
# STEP 1: Install required packages (run once)
# ------------------------------------------------------------
# Uncomment and run the lines below if you haven't installed these packages yet.

# install.packages("tidyverse")
# install.packages("lubridate")
# install.packages("scales")
# install.packages("viridis")
# install.packages("patchwork")

# ------------------------------------------------------------
# STEP 2: Load libraries
# ------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(scales)
library(viridis)
library(patchwork)

# ------------------------------------------------------------
# STEP 3: Import cleaned data
# ------------------------------------------------------------
# Assumes you are in the R Project root folder
df <- read_csv("02_Prepared_Data/cyclistic_clean_12months.csv")

# Quick data check
glimpse(df)

# ------------------------------------------------------------
# STEP 4: Create output directory for visuals
# ------------------------------------------------------------
if (!dir.exists("03_Visuals")) {
  dir.create("03_Visuals")
}

# ------------------------------------------------------------
# CHART 1: Overall Ridership by User Type
# ------------------------------------------------------------
plot1 <- df %>%
  count(member_casual) %>%
  ggplot(aes(x = member_casual, y = n, fill = member_casual)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = scales::comma(n)), 
            vjust = -0.5, size = 5) +
  scale_fill_manual(values = c("casual" = "#FF8C00", "member" = "#1E88E5")) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Total Rides: Members vs. Casual Riders",
    subtitle = "April 2025 - March 2026",
    x = "",
    y = "Number of Rides"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    panel.grid.major.x = element_blank()
  )

print(plot1)
ggsave("03_Visuals/plot1_ridership_overall.png", plot1, width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------
# CHART 2: Average Ride Duration with Error Bars
# ------------------------------------------------------------
summary_stats <- df %>%
  group_by(member_casual) %>%
  summarise(
    avg_mins = mean(ride_length_mins),
    sd_mins = sd(ride_length_mins),
    n = n()
  ) %>%
  mutate(se_mins = sd_mins / sqrt(n))  # Standard error

plot2 <- summary_stats %>%
  ggplot(aes(x = member_casual, y = avg_mins, fill = member_casual)) +
  geom_col(width = 0.6) +
  geom_errorbar(aes(ymin = avg_mins - se_mins, ymax = avg_mins + se_mins),
                width = 0.2, color = "gray30", linewidth = 0.8) +
  geom_text(aes(label = paste0(round(avg_mins, 1), " min")), 
            vjust = -1.5, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("casual" = "#FF8C00", "member" = "#1E88E5")) +
  labs(
    title = "Average Ride Duration",
    subtitle = "Casual riders take significantly longer trips",
    x = "",
    y = "Minutes"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 18),
    panel.grid.major.x = element_blank()
  )

print(plot2)
ggsave("03_Visuals/plot2_avg_duration.png", plot2, width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------
# CHART 3: Usage Heatmap by Hour and Day
# ------------------------------------------------------------
heatmap_data <- df %>%
  count(member_casual, day_of_week, start_hour) %>%
  mutate(day_of_week = factor(day_of_week, 
                              levels = c("Monday", "Tuesday", "Wednesday", 
                                         "Thursday", "Friday", "Saturday", "Sunday")))

plot3 <- heatmap_data %>%
  ggplot(aes(x = start_hour, y = day_of_week, fill = n)) +
  geom_tile(color = "white", linewidth = 0.5) +
  scale_fill_viridis_c(option = "plasma", 
                       labels = scales::comma,
                       name = "Number of Rides") +
  facet_wrap(~member_casual, ncol = 1) +
  scale_x_continuous(breaks = seq(0, 23, by = 2)) +
  labs(
    title = "Ride Frequency by Hour and Day",
    subtitle = "Members show clear commute peaks; Casual riders prefer weekend afternoons",
    x = "Hour of Day (0 = Midnight, 23 = 11 PM)",
    y = ""
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    strip.text = element_text(face = "bold", size = 14),
    panel.grid = element_blank(),
    legend.position = "bottom",
    legend.key.width = unit(2, "cm")
  )

print(plot3)
ggsave("03_Visuals/plot3_heatmap.png", plot3, width = 12, height = 8, dpi = 300)

# ------------------------------------------------------------
# CHART 4: Bike Type Preference (Stacked Percentage Bar)
# ------------------------------------------------------------
plot4 <- df %>%
  count(member_casual, rideable_type) %>%
  group_by(member_casual) %>%
  mutate(percentage = n / sum(n)) %>%
  ggplot(aes(x = member_casual, y = percentage, fill = rideable_type)) +
  geom_col(position = "fill", width = 0.6) +
  geom_text(aes(label = scales::percent(percentage, accuracy = 1)),
            position = position_fill(vjust = 0.5),
            color = "white", fontface = "bold", size = 5) +
  scale_fill_brewer(palette = "Set1", name = "Bike Type") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    title = "Bike Type Preference",
    subtitle = "Casual riders show higher preference for electric bikes",
    x = "",
    y = "Percentage of Rides"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    legend.position = "bottom"
  )

print(plot4)
ggsave("03_Visuals/plot4_bike_preference.png", plot4, width = 8, height = 6, dpi = 300)

# ------------------------------------------------------------
# COMBINED DASHBOARD (All 4 Plots in a 2x2 Grid)
# ------------------------------------------------------------
combined_plot <- (plot1 + plot2) / (plot3 + plot4) +
  plot_annotation(
    title = "Cyclistic Bike-Share Analysis: Casual vs. Member Behavior",
    theme = theme(plot.title = element_text(face = "bold", size = 22, hjust = 0.5))
  )

print(combined_plot)
ggsave("03_Visuals/combined_dashboard.png", combined_plot, 
       width = 16, height = 12, dpi = 300)

# ------------------------------------------------------------
# OPTIONAL: Statistical Test (t-test)
# ------------------------------------------------------------
t_test_result <- t.test(ride_length_mins ~ member_casual, data = df)
print(t_test_result)

# ------------------------------------------------------------
# SESSION INFO (for reproducibility)
# ------------------------------------------------------------
sessionInfo()
