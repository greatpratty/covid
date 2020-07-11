library(ggplot2)

# Read in raw data as a data frame
rawData <- read.csv("C:/Users/John/Documents/VDH-COVID-19-PublicUseDataset-EventDate.csv", stringsAsFactors = FALSE)

# Fix the date field
rawData$FixedDate <- as.Date(rawData$Event.Date,format="%m/%d/%Y")

# Build a data frame with just the confirmed cases
confirmedCases <- subset(rawData, Case.Status == "Confirmed")

# Build a data frame with just the probable cases
probableCases <- subset(rawData, Case.Status == "Probable")
#ggplot(data = confirmedCases, aes(x = FixedDate, y = Number.of.Deaths)) + geom_point()

# Change the column headings to reflect the two data sets
col_headings     <- c('Event.Date','Health.Planning.Region', 'Case.Status - Confirmed', 'Cases-confirmed', 'Hospitalizations-confirmed', 'Deaths-confirmed', 'FixedDate')
col_headings2    <- c('Event.Date','Health.Planning.Region', 'Case.Status - Probable', 'Cases-probable', 'Hospitalizations-probable', 'Deaths-probable', 'FixedDate')
names(confirmedCases) <- col_headings
names(probableCases)  <- col_headings2

# Merge the two dataframes and build the new columns combining the data
mergedData                    <- merge(confirmedCases, probableCases, by = c("FixedDate","Health.Planning.Region"), all.x = TRUE, all.y = TRUE)
mergedData[is.na(mergedData)] <- 0
mergedData$totalCases         <- mergedData$'Cases-confirmed' + mergedData$'Cases-probable'
mergedData$totalHospitalized  <- mergedData$`Hospitalizations-confirmed` + mergedData$`Hospitalizations-probable`
mergedData$totalDeaths        <- mergedData$`Deaths-confirmed` + mergedData$`Deaths-probable`

ggplot(data = mergedData, aes(x = FixedDate, y = totalCases)) + geom_line()

casesEastern <-subset(mergedData, mergedData$Health.Planning.Region == "Eastern")
ggplot(data = casesEastern, aes(x = FixedDate, y = totalCases)) + geom_line()
casesCentral <-subset(mergedData, mergedData$Health.Planning.Region == "Central")
ggplot(data = casesCentral, aes(x = FixedDate, y = totalCases)) + geom_line()
