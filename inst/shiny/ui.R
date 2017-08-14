require(shiny)
require(D3Scatter)
require(shinyBS)
require(gplots)

ui <- fillPage(
    titlePanel("Multiplex IF Gating Tool"),
    fillRow(
        D3ScatterOutput("scatter", width = "100%", height = "90%"),
        fillCol(
            fileInput("segFile", "Choose raw .FCS file",
                       accept = c(".txt")),
            checkboxInput("showPAX", label = "Show PAX / tumor only", value = FALSE),
            actionButton('deleteSelected',
                         "Delete selected",
                         icon = icon("trash",lib = "glyphicon")),
            downloadButton("SaveSelection", "Save File"),
            verbatimTextOutput("currentOutput")
    ),flex = c(2,1))
)

                 



                                    
                           
