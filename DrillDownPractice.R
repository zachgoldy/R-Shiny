#Drilldown Practice
library(shinydashboard)
library(ggplot2)
library(scales)
data <- PlantGrowth #using builtin PlantGrowth dataset, easily replaceable.
## UI ------------------------------------------------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(title = "Drilldown Practice"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(plotOutput("plot1", height=500, click="plot_click"))
      
    ),
    fluidRow(
      box(verbatimTextOutput("table1"))
    )
  )
)
## SERVER --------------------------------------------------------------------------------------------
server <- function(input, output){
  output$plot1 <- renderPlot({
    dfl <- ddply(data, .(group), summarize, y=length(group))
    value <- dfl$y
    pie <- ggplot(dfl, aes(1,y=y, fill= group)) + geom_bar(width = 1, stat="identity") 
    blank_theme <- theme_minimal()+
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
    
    pie + scale_fill_brewer("Types") +  blank_theme +
      geom_text(aes(y = value/3 + c(0, cumsum(value)[-length(value)]), 
                    label = percent(value/nrow(data))), size=5)
    
  })
  output$table1 <- renderPrint({
    if (is.null(input$plot_click$y)){
      data_table <- data
    }
    else {
      #we create a subset of the table with a grouping that is equal to the grouping on the barplot
      keeprows <- subset(data, as.numeric(group) == length(levels(data$group)) - (floor(input$plot_click$y/10))) 
      if (length(keeprows$group) == 0 | input$plot_click$x > 1.5 | input$plot_click$x < 0){
      }else {
        data_table <- keeprows
      }}
    data_table
  })
  
}

shinyApp(ui, server)
