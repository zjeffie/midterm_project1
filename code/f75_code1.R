library(knitr)
library(rio)
library(here)
library(tidyverse)

here::i_am(
  "code/f75_code1.R"
)

#import data set from raw data
f75 <- read.csv(here::here("data", "f75_interim.csv"))
glimpse(f75)

#filter and summarize muca measurements by sex 
muac_summary<-f75 |>
  group_by(sex, arm)|>
  summarise(
    N = n(),
    across(
      c(muac, muac1, muac2),              # variables to summarize
      list(
        mean = ~mean(.x, na.rm = TRUE),
        sd   = ~sd(.x, na.rm = TRUE),
        min  = ~min(.x, na.rm = TRUE),
        max  = ~max(.x, na.rm = TRUE)
      ),
      .names = "{.col}_{.fn}"               # how to name result columns
    )
  )
#save f75_summary
saveRDS(
  f75_summary, 
  file= here::here("output", "f75_summary.rds")
  )

#craete box plot contrast muac baseline by sex
ggplot(f75,aes(x=sex, y=muac, fill=sex))+
  geom_boxplot()+
  labs(
    title="MUAC by Sex",
    x="Sex",
    y="MUAC(cm)"
  )+
  theme_minimal(base_size = 14)
# save the table
ggsave(
  filename = here::here("output", "muac_boxplot.png"),
  width = 6, height = 4, dpi = 300
)

