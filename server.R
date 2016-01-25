
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny); require(ggplot2); require(dplyr); require(reshape); require(RColorBrewer)

##data aquired from ()[http://nces.ed.gov/ipeds/datacenter/DataFiles.aspx]
##Data files used are:
##HD2014    Institutional Characteristics
##EFFY2014  12-Month Enrollment

##Downloading and loading EFFY2014
EFFY2014URL <- "http://nces.ed.gov/ipeds/datacenter/data/EFFY2014.zip"
temp <- tempfile()
download.file(EFFY2014URL,temp)
EFFY2014 <- read.csv(unz(temp, "effy2014.csv"))
unlink(temp)
##Downloading and loading hd2014
hd2014URL <- "http://nces.ed.gov/ipeds/datacenter/data/HD2014.zip"
temp <- tempfile()
download.file(hd2014URL,temp)
hd2014 <- read.csv(unz(temp, "hd2014.csv"))
unlink(temp)
dateDownloaded <- date()

##Adding the State codes the the EFFY2014 from the hd2014 file
data <- merge(hd2014[,c(1:2,5)], EFFY2014)
##Turning data into long format with just the male and female totals.
dataMF <- melt(data, 1:5, c(9,11))
    ##Replacing total gender codes with human readable names.
    levels(dataMF$variable) <- c("Male", "Female")
    colnames(dataMF)[6] <- "Group"
##Turing race totals into long format
dataRace <- melt(data, 1:5, c(13,19,25,31,37,43,49,55,61))
    ##Replacing codes for total race count with human readable race names.
    levels(dataRace$variable) <- c("American Indian or Alaska Native", "Asian",
        "Black or African American", "Hispanic or Latino", "Native Hawaiian or
        Other Pacific Islanders", "White", "Two or more races", "unknown",
        "Nonresident Alien")
    colnames(dataRace)[6] <- "Group"

##Server
shinyServer(function(input, output) {

    ##Outputs
    output$text1 <- renderText({
        paste("Data downloaded on", dateDownloaded)
        })

    output$distPlot <- renderPlot({

        # Data source selection
        Data <- input$Data #Gender = dataMF \ race = dataRace
        st <- input$states #list of states by there abbreviation
        deg <- input$deg #Choice of degree level. 1 = total \ 2 = undergrad \
                                                # 3 = Graduate

        # Choosing color palette.
        if(Data == "dataMF"){c <- 4}
            else{c <- 9}
        mypalette <-brewer.pal(c,input$Color)

        # draw the barplot
        g <- ggplot(data = subset(get(Data), (STABBR %in% st)&(EFFYLEV %in% deg)
            ), aes(y = value, x = STABBR, fill = Group))
            g <- g + xlab("States") + ylab("%")
            g <- g +geom_bar(stat = "identity",  position = "fill", alpha = .75)
            g <- g + scale_fill_manual(values = mypalette)
            g

  })

})
