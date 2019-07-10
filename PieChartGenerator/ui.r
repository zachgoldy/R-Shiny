library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(plotly)
shinyUI(
  
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(

    )),
    dashboardBody(
          fluidRow(
           box(title="Barplot", status ="primary", solidheader= T, plotlyOutput("boxplot", height=1200)),
           box(title="Plot Controls", status = "warning", solidheader = T, selectInput("input_select",
                choices = list("CAT_VARS_HERE!!!", "PUT_CAT_VAR_2_HERE!!!!"), label = "Graph of:"), ###PUT YOUR CAT VARIABLES HERE!!
                 box(title="First 50 Entries of Category (less if there are less than 50 entries)", verbatimTextOutput("click_out"),width = 5),
               box(title="Summary of Data", verbatimTextOutput("summary"), width= 7)
          )
        ),
        fluidRow(
          box(plotOutput("histo"))
        )
        ),
    )
    
)


