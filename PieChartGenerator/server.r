library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(dplyr)
library(Hmisc)
setwd("C:\\Users\\Sample_path") # Insert Path here 
csv_file <- read.csv("sample_file.csv") # Add file name here 
quant_var <- "QUANT_VAR_HERE" # ADD QUANT VARIABLE HERE!!!!!
shinyServer(function(input, output){
##############################################    PIE CHART 
  output$boxplot <- renderPlotly({ 
    blank_theme <- theme_minimal()+ #Creates a blank theme, removes ticks, titles, etc. for graph
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid=element_blank(),
        axis.ticks = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        plot.title=element_text(size=14, face="bold"),
        axis.text = element_blank()
      )
    x <- input$input_select
    data_list <- csv_file[[x]] #creates a list of values for the selected variable (we have to do
    ## this way because input "x" is a string)
    data_list <- data_list[data_list != ""]
    data_list <- factor(data_list)
    difl <- data.frame(prop.table(table(data_list)))
    plot <- plot_ly(difl, labels = ~data_list, values = ~Freq, type = 'pie') %>%
      layout(autosize= F, height = 1200, width = 1000, title = sprintf('Distribution of %s', x), xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    plot
  })
    
  #######################           Drill Down Table 
  output$click_out <- renderPrint({
    op <- event_data("plotly_click")$pointNumber
    if (is.null(op)){ "Click for a table!"} else{
      csv_file <- csv_file[,c(input$input_select, quant_var)]
      csv_file <- csv_file[csv_file[[input$input_select]] != "",]
      csv_file[[input$input_select]] <- factor(csv_file[[input$input_select]])
      csv_file$nums <- (as.numeric(csv_file[[input$input_select]]) - 1)
      sub <- csv_file[csv_file$nums==op,]
      if(length(sub[,1]) < 50){
        if(length(sub[,1])){
        sub[,1:2]
        }else{
          "Click for a table!"
        }
      }else{
        sub[1:50,1:2]
      }
    }
      

  })
  
  ########################      SUMMARY STATISTICS BOX
  output$summary <- renderPrint({
    op <- event_data("plotly_click")$pointNumber
    if (is.null(op)){ "Click for a table summary!"} else{
      csv_file <- csv_file[,c(input$input_select, quant_var)]
      csv_file <- csv_file[csv_file[[input$input_select]] != "",]
      csv_file[[quant_var]] <- as.integer(csv_file[[quant_var]])
      csv_file <- csv_file[csv_file[[quant_var]] != '',]
      csv_file[[input$input_select]] <- factor(csv_file[[input$input_select]])
      csv_file$nums <- (as.numeric(csv_file[[input$input_select]]) - 1)
      sub <- csv_file[csv_file$nums==op,]
      desc <- describe(sub[[quant_var]], descript = paste("Summary of ", quant_var, " with a ", input$input_select, " value of  \"", sub[1,1], "\"", sep= ""))
      sum <- summary(sub[[quant_var]])
      if(is.null(desc)){"No quantitative values!"}else{desc}
      
    }
  })
  ########################### HISTOGRAM  
  output$histo <- renderPlot({
    op <- event_data("plotly_click")$pointNumber
    
      csv_file <- csv_file[,c(input$input_select, quant_var)]
      csv_file <- csv_file[csv_file[[input$input_select]] != "",]
      csv_file[[input$input_select]] <- factor(csv_file[[input$input_select]])
      csv_file$nums <- (as.numeric(csv_file[[input$input_select]]) - 1)
      csv_file <- csv_file[csv_file[[quant_var]] != '',]
      csv_file[[quant_var]] <- as.integer(csv_file[[quant_var]])
      if (is.null(op)){hist(csv_file[[quant_var]], main = paste("Distribution of ", quant_var)) } else{
      sub <- csv_file[csv_file$nums==op,]
      hist(sub[[quant_var]], main = paste("Distribution of ", quant_var, " with a ", input$input_select, " value of  \"", sub[1,1], "\"", sep= ""))
    }
  })
})
