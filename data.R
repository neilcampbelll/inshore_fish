##  Place input data files into /data folder

hhdata <- getDATRAS(record = "HH", survey = "NS-IBTS", years = 2012:2022, quarters = 3)
hldata <- getDATRAS(record = "HL", survey = "NS-IBTS", years = 2012:2022, quarters = 3)

# cadata <- getDATRAS(record = "CA", survey = "NS-IBTS", years = 2022, quarters = 3)
## I don't think we need catch at age data for this work


hldata$HaulId <- paste(hldata$Country, hldata$Year, hldata$HaulNo, sep = "_")

hldata$Grouping <- ifelse(hldata$LngtClass<=length.threshold, "SMALL", "LARGE")

# hauls <- st_as_sf(hhdata, coords = c("ShootLat", "ShootLong"), crs = st_crs("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"))

hauls <- hhdata

hauls$HaulId <- paste(hauls$Country, hauls$Year, hauls$HaulNo, sep = "_")

hldata2    <- hldata %>% select(c('HaulId', 'Grouping', 'HLNoAtLngt')) %>%
                group_by(HaulId, Grouping) %>%
                summarise(NoFish = sum(HLNoAtLngt))

small.fish <- hldata2 %>% filter(Grouping == "SMALL") %>%
                select(HaulId, NoFish) %>%
                rename('Small' = 'NoFish')

large.fish <- hldata2 %>% filter(Grouping == "LARGE") %>%
  select(HaulId, NoFish)%>%
  rename('Large' = 'NoFish')



hauls <- left_join(hauls, large.fish, by = 'HaulId')
hauls <- left_join(hauls, small.fish, by = 'HaulId')

hauls$Large.CPUE <- hauls$Large * (60/hauls$HaulDur)
hauls$Small.CPUE <- hauls$Small * (60/hauls$HaulDur) 

hauls$Small.CPUE[is.na(hauls$Small.CPUE)] <- 0
hauls$Large.CPUE[is.na(hauls$Large.CPUE)] <- 0

hauls <- st_as_sf(hauls, coords = c("ShootLat", "ShootLong"), crs = st_crs("+proj=utm +zone=30 +datum=WGS84 +units=m +no_defs"))
