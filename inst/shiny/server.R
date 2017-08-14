rm(list=ls())
gc()

server <- function(input, output, session) {
    options(shiny.maxRequestSize=500*1024^2)
    
    #reactive values
    values <- reactiveValues(data=NULL)
    
    #file loading
    observeEvent(input$segFile,{ 
        values$data <- read.csv(input$segFile$datapath,
                                sep = '\t',
                                as.is = T)
    })
    
    output$scatter <- renderD3Scatter({
        if (!is.null(values$data)){
            #data <- read.csv('Z:/pathology/TCHRLBCL/combined-20170810/1049/1049_[52474,10131]_cell_seg_data.txt',sep = '\t',as.is = T)
            
            dat <- values$data[,c("Nucleus.PAX5..Opal.620..Mean..Normalized.Counts..Total.Weighting.",
                                  "Entire.Cell.Area..pixels.","Phenotype","Cell.ID")]
            dat <- dat[dat$Phenotype != '',]
            
            #filter according to PAX5 stain
            if (input$showPAX){
                dat <- dat[dat$Phenotype %in% c('PAX5+','Tumor PDL1-','Tumor PDL1+'),]
            }
            dat$Phenotype <- as.factor(dat$Phenotype)

            #coloring
            cols <- c('#e78ac3','#a6d854','#ffd92f','#66c2a5','#fc8d62','#8da0cb')
            
            #legend
            legend <- data.frame(col=cols[1:length(levels(dat$Phenotype))],
                                 name=levels(dat$Phenotype))
            D3Scatter(dat,
                      col=cols[as.numeric(dat$Phenotype)],
                      dotsize = 3,
                      xlab='Nucleus PAX5 - Opal 620 - Mean',
                      ylab='Entire Cell Area pixels',
                      tooltip = c('Phenotype','Cell.ID'),
                      legend = legend,
                      callback_handler='ScatterSelection')
        }
    })
    
    observeEvent(input$deleteSelected,{
        if (length(input$ScatterSelection) > 0){
            cellIDs <- values$data$Cell.ID
            if (input$showPAX){
                cellIDs <- cellIDs[values$data$Phenotype %in% c('PAX5+','Tumor PDL1-','Tumor PDL1+'),]
            }
            selected <- cellIDs[as.numeric(input$ScatterSelection)]

            values$data <- values$data[!values$data$Cell.ID %in% selected,]
        }
    })
    
    #saves the selected cells
    output$SaveSelection <-    downloadHandler(
        filename = function(){input$segFile$name},
        content = function(file) {
            write.table(values$data,file = file,sep='\t',row.names=F)
        },
        contentType='txt')
    
    output$currentOutput <- renderPrint({ })

}



