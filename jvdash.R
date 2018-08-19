## app.R ##
library(shinydashboard)
library(highcharter)
library(dplyr)
library(viridisLite)
library(forecast)
library(shiny)
library(DT)
 
sideWidth = 250

#custom colors
lmitBlue = "#00aaf0"
lmitOrange = "#F2952D"

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


#--Team Data Calculations (START)
jvTeams <- data_frame(
  name = c("Portland", "Los Angeles", "Cambridge", "Houston"),
  lat = c(45.5122, 34.0522,  42.3736, 29.7604),
  lon = c(-122.6587, -118.2437, -71.1097, -95.3698),
  z = c(3, 5, 1, 1)
  #45.5122° N, 122.6587
  #34.0522° N, 118.2437
  #42.3736° N, 71.1097
  #29.7604° N, 95.3698
)
glimpse(jvTeams)
#--Team Data Calculations (END)

ui <- dashboardPage(
  dashboardHeader(
    title = "JV Dashboard",
    titleWidth = sideWidth
    ),
  ## Sidebar content
  dashboardSidebar(
    width = sideWidth,
    sidebarMenu(
      menuItem("Programs", tabName = "program", icon = icon("archive")),
      menuItem("Kit Sales", tabName = "kitsales", icon = icon("archive")),
      menuItem("Guide Sales", tabName = "guidesales", icon = icon("book")),
      menuItem("Customers", tabName = "customers", icon = icon("user")),
      #menuItem("Locations", tabName = "locations", icon = icon("map-marker-alt"))
      menuItem("Locations", tabName = "locations", icon = icon("map-marker", lib = "glyphicon"))
    )
  ),
  ## Body content
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      #tab content
      tabItem(tabName = "program",
              fluidRow(
                infoBox("School", value = 8, subtitle = "After-school",
                        icon = icon("university"), color = "blue", width = 3,
                        href = NULL, fill = FALSE),
                infoBox("School", value = 13, subtitle = "Classroom",
                        icon = icon("bell"), color = "blue", width = 3,
                        href = NULL, fill = FALSE),
                infoBox("Home", value = 13, subtitle = "Home-school",
                        icon = icon("home"), color = "blue", width = 3,
                        href = NULL, fill = FALSE),
                infoBox("Event", value = 13, subtitle = "Camp",
                        icon = icon("paper-plane"), color = "blue", width = 3,
                        href = NULL, fill = FALSE)
              )
              ),
      
      #tab content
      tabItem(tabName = "kitsales",
              #quick summary boxes
              fluidRow(
                infoBox("Offered", value = 8, subtitle = "JV Kits",
                        icon = icon("archive"), color = "blue", width = 6,
                        href = NULL, fill = FALSE),
                infoBox("Shipped", value = 13, subtitle = "JV Kits",
                        icon = icon("archive"), color = "blue", width = 6,
                        href = NULL, fill = FALSE)
              ),
              
              #tabset panel
              tabsetPanel(type = "tabs", 
                          tabPanel("All",
                                   h2("Kit Sales (All)"),
                                     AirPassengers %>% 
                                       forecast(level = 90) %>% 
                                       hchart() %>% 
                                       hc_add_theme(chartTheme) 
                                   ),
                          tabPanel("CO",
                                   h2("Chill Out"),
                                     AirPassengers %>% 
                                       forecast(level = 90) %>% 
                                       hchart() %>% 
                                       hc_add_theme(chartTheme) 
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
              )
              
      ),
      
      #tab content
      tabItem(tabName = "guidesales",
              #quick summary boxes
              fluidRow(
                infoBox("Shipped", value = 19, subtitle = "Educator Guides",
                        icon = icon("book"), color = "blue", width = 6,
                        href = NULL, fill = FALSE),
                infoBox("Shipped", value = 126, subtitle = "Student Guides",
                        icon = icon("book"), color = "blue", width = 6,
                        href = NULL, fill = FALSE)
              )       
              
      ),
      
      #tab content
      tabItem(tabName = "customers",
              #quick summary boxes
              fluidRow(
                infoBox("JV Teams", value = 40, subtitle = "Grantees",
                        icon = icon("users"), color = "blue", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("JV Teams", value = 3, subtitle = "Independent",
                        icon = icon("users"), color = "blue", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("Customer", value = 18, subtitle = "Accounts",
                        icon = icon("user"), color = "blue", width = 4,
                        href = NULL, fill = FALSE)
              ),
              fluidRow(
                box(
                  title = "Student Participation over Time", width = NULL, status = "primary",
                  div(style = 'overflow-x: scroll', DT::dataTableOutput('table'))
                )
              ),
              
              tabsetPanel(
                id = 'customerData',
                tabPanel("Grantees",      box(DTOutput("mytable"))),
                tabPanel("Independent",   box(DTOutput("mytable"))),
                tabPanel("International", box(DTOutput("mytable")))
              )
              
        
      ),
      
      # tab content
      tabItem(tabName = "locations",
              h2("JV Locations"), 
              
              #quick summary boxes
              fluidRow(
                infoBox("States", value = 7, subtitle = "National",
                        icon = icon("users"), color = "blue", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("Countries", value = 2, subtitle = "International",
                        icon = icon("users"), color = "blue", width = 4,
                        href = NULL, fill = FALSE),
                infoBox("Grantees", value = 4, subtitle = "National",
                        icon = icon("user"), color = "blue", width = 4,
                        href = NULL, fill = FALSE)
              ),
              
              fluidRow(
                hcmap(showInLegend = FALSE) %>%
                  hc_add_series(data = jvTeams, type = "mapbubble", name = "JV Teams", maxSize = '10%', color=lmitOrange) %>% 
                  hc_mapNavigation(enabled = TRUE)
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
  
  #customer data
  test.table <- data.frame(lapply(1:8, function(x) {1:10}))
  names(test.table) <- paste0('This_is_a_very_long_name_', 1:8)
  
  output$table <- DT::renderDataTable({
    DT::datatable(test.table, 
                  options = list(dom = 't'))
  })
}

shinyApp(ui, server)