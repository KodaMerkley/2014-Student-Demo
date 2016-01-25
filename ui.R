
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)



##Unique State Codes
##This was done by extracting all of the unique values from the hd2014.csv$STABBR and exporting them to a csv.
x <- read.csv("states.CSV")[,1]

shinyUI(fluidPage(


verticalLayout(
    titlePanel("2014 Student Enrollment Demographics"),
    mainPanel(
        ##Plot generated
        plotOutput("distPlot", height = "650"),

    ##Render options
    wellPanel(
        fluidRow(
            ##Demographic
            column(width = 2,
            radioButtons("Data", "Demographic",
                list("Gender" = "dataMF",
                    "Race" = "dataRace"))),
            ##Degree Level
            column(width = 2, offset = .5,
                radioButtons("deg", "Degree Level",
                    choices = list("All Students" = 1,
                        "Undergraduates" = 2, "Graduates" = 4),
                        selected = 1)),
            ##Rendering Colors
            column(width = 2, offset = .5,
                radioButtons("Color", "Color Palette",
                     list("Descrete" = "Set3",
                            "Pastel" = "Pastel1",
                            "Red Yellow Blue" = "RdYlBu",
                            "Pink Green" = "PiYG",
                            "Brown Green" = "BrBG"))),
            ##State Selection
            column(width = 4, offset = .5,
                selectInput("states", "Select States",
                    choices = as.character(x),
                        selected = x[1:51],
                    multiple=TRUE, selectize=TRUE))
        )
    ),
    ##Date data was last downloaded.
    textOutput("text1")
    )
  )
))
