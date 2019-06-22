library(tidyverse)

# This script downloads the NASS data from USDA and pulls out Corn ----------

start_year = 1989
end_year = 2018
download_nass = TRUE

# grab the latest NASS crop file from ftp://ftp.nass.usda.gov/quickstats/ and save it
library(RCurl)
url <- "ftp://ftp.nass.usda.gov/quickstats/"
filenames <- getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE)
filenames <-
  unlist(strsplit(filenames, "[\\\\]|[^[:print:]]", fixed = FALSE)) ## split up the filenames
crop_file <- filenames[grep('crops', filenames)]

if (download_nass == TRUE) {
  nass_data_bin <- try(getBinaryURL(paste0(url, crop_file)))
  writeBin(nass_data_bin, crop_file)
  rm(nass_data_bin) # free up memory
}

nass_crop_data = read_tsv(crop_file) # takes a few minutes... 5.6GB

nass_crop_data %>%
  filter(
    AGG_LEVEL_DESC == 'STATE' &
      REFERENCE_PERIOD_DESC == 'YEAR' &
      YEAR >= start_year &
      YEAR <= end_year
  ) ->
  annual_crop_data

rm(nass_crop_data) # save some memory

annual_crop_data %>%
  filter(
    COMMODITY_DESC == 'CORN' &
      SHORT_DESC %in% c('CORN, GRAIN - PRODUCTION, MEASURED IN BU', 'CORN - ACRES PLANTED') &
      SOURCE_DESC == 'SURVEY'
  ) %>%
  mutate(VALUE = as.double(gsub(",", "", VALUE))) -> #kill the commas and make value a double
  corn_annual_nass_data

corn_annual_nass_data %>%
  group_by(STATE_ALPHA, YEAR, SHORT_DESC) %>%
  summarize(VALUE = sum(VALUE)) %>%
  mutate(SHORT_DESC = gsub(
    'CORN, GRAIN - PRODUCTION, MEASURED IN BU',
    'corn_production',
    SHORT_DESC
  )) %>%
  mutate(SHORT_DESC = gsub('CORN - ACRES PLANTED', 'corn_acres_planted', SHORT_DESC)) %>%
  spread(SHORT_DESC, VALUE) %>%
  mutate(plantedYield =  corn_production / corn_acres_planted) ->
  corn_yield

corn_yield %>%
  filter(STATE_ALPHA %in% c('IL','IA','KY','GA','NE')) %>%
  select(state=STATE_ALPHA, year=YEAR, corn_yield=plantedYield) ->
  state_corn_yield

saveRDS(state_corn_yield, file = "data/state_corn_yield.rds")


# 
# ``` {r cornboxplot, fig.cap='Corn Planted Yield (bushels/acre)'}
# state_corn_yield <-
#   readRDS(file = "data/state_corn_yield.rds")
# 
# ggplot(state_corn_yield) +
#   aes(x = state, y = corn_yield) +
#   geom_boxplot()
# 
# ```



