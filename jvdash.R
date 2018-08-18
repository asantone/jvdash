## app.R ##
library(shinydashboard)
library(highcharter)
library(dplyr)
library(viridisLite)
library(forecast)
 
sideWidth = 250

thm <- 
  hc_theme(
    colors = c("#1a6ecc", "#434348", "#90ed7d"),
    chart = list(
      backgroundColor = "transparent",
      style = list(fontFamily = "Source Sans Pro")
    ),
    xAxis = list(
      gridLineWidth = 1
    )
  )

#hc %>% hc_add_theme(hc_theme_chalk())

#chartTheme = hc_theme_monokai()
#chartTheme = hc_theme_chalk()
#chartTheme = hc_theme_tufte()
chartTheme = hc_theme_economist()

ui <- dashboardPage(
  dashboardHeader(
    title = "JV Dashboard",
    titleWidth = sideWidth
    ),
  ## Sidebar content
  dashboardSidebar(
    width = sideWidth,
    sidebarMenu(
      menuItem("Kit Sales", tabName = "kitsales", icon = icon("archive")),
      menuItem("Guide Sales", tabName = "guidesales", icon = icon("book")),
      menuItem("Customers", tabName = "customers", icon = icon("user")),
      menuItem("Locations", tabName = "locations", icon = icon("map-marker", lib = "glyphicon"))
    )
  ),
  ## Body content
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      # First tab content
      tabItem(tabName = "kitsales",
              #quick summary boxes
              fluidRow(
                infoBox("Offered", value = 8, subtitle = "JV Kits",
                        icon = icon("archive"), color = "aqua", width = 6,
                        href = NULL, fill = FALSE),
                infoBox("Shipped", value = 13, subtitle = "JV Kits",
                        icon = icon("archive"), color = "aqua", width = 6,
                        href = NULL, fill = FALSE)
              ),
              
              #tabset panel
              tabsetPanel(type = "tabs", 
                          tabPanel("All",
                                   h2("Kit Sales (All)"),
                                     AirPassengers %>% 
                                       forecast(level = 90) %>% 
                                       hchart() %>% 
                                       hc_add_theme(chartTheme) #hc_add_theme(thm) #chalk #monokai
                                   ),
                          tabPanel("CO",
                                   h2("Chill Out"),
                                     AirPassengers %>% 
                                       forecast(level = 90) %>% 
                                       hchart() %>% 
                                       hc_add_theme(chartTheme) #hc_add_theme(thm) #chalk #monokai
                                   ),
                          tabPanel("ET",
                                   h2("Electronic Textiles")
                          ),
                          tabPanel("GG",
                                   h2("Growing Green")
                          ),
                          tabPanel("NM",
                                   h2("Noise Makers")
                          ),
                          tabPanel("PU",
                                   h2("Pump It Up")
                          ),
                          tabPanel("SS",
                                   h2("Shoe Soles")
                          ),
                          tabPanel("SL",
                                   h2("Super Lens")
                          ),
                          tabPanel("UC",
                                   h2("U Control")
                          )
              ),
              
              
              #sales chart
              fluidRow(
                box(
                  width=12,
                  title = "Plot",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "primary",
                  AirPassengers %>% 
                    forecast(level = 90) %>% 
                    hchart() %>% 
                    hc_add_theme(hc_theme_monokai()) #hc_add_theme(thm) #chalk #monokai
                ) 
              ),
             
              
              fluidRow(
                box(
                  title = "Histogram",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  #background = "teal",
                  status = "primary", 
                  plotOutput("plot1", height = 250)
                  ),
                
                box(
                  title = "Controls",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  #background = "orange",
                  status = "primary",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
                
                
              )
      ),
      
      #tab content
      tabItem(tabName = "guidesales",
              #quick summary boxes
              fluidRow(
                infoBox("Shipped", value = 126, subtitle = "Educator Guides",
                        icon = icon("book"), color = "aqua", width = 6,
                        href = NULL, fill = FALSE),
                infoBox("Shipped", value = 126, subtitle = "Student Guides",
                        icon = icon("book"), color = "aqua", width = 6,
                        href = NULL, fill = FALSE)
              )       
              
      ),
      
      #tab content
      tabItem(tabName = "customers",
              #quick summary boxes
              fluidRow(
                infoBox("JV Teams", value = 40, subtitle = "Grantees",
                        icon = icon("users"), color = "aqua", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("JV Teams", value = 3, subtitle = "Independent",
                        icon = icon("users"), color = "aqua", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("Customer", value = 18, subtitle = "Accounts",
                        icon = icon("user"), color = "aqua", width = 4,
                        href = NULL, fill = FALSE)
              )       
        
      ),
      
      # tab content
      tabItem(tabName = "locations",
              h2("JV Locations"), 
              
              box(
                title = "Plot",
                solidHeader = TRUE,
                collapsible = TRUE,
                status = "primary",
                AirPassengers %>% 
                  forecast(level = 90) %>% 
                  hchart() %>% 
                  hc_add_theme(hc_theme_monokai()) #hc_add_theme(thm) #chalk #monokai
              )
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