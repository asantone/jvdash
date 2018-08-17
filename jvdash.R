## app.R ##
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "JV Dashboard"),
  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Sales", tabName = "sales", icon = icon("dashboard")),
      menuItem("Locations", tabName = "locations", icon = icon("th"))
    )
  ),
  ## Body content
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      # First tab content
      tabItem(tabName = "sales",
              fluidRow(
                box(
                  title = "Histogram",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "primary", 
                  plotOutput("plot1", height = 250)
                  ),
                
                box(
                  title = "Controls",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "primary",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                ),
                
                valueBox(10 * 2, "Orders", icon = icon("credit-card"))
              )
      ),
      
      # Second tab content
      tabItem(tabName = "locations",
              h2("JV Locations")
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)