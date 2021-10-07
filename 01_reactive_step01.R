# Goals:
# 1.reactive()
# 2.referencing variable names
# 3.updating UI options based on some other UI result - ie. only varieties from whichever vegetable is selected

## showing reactive()

# In this step we set up the UI

library(shiny)
# If you need to install my gardenR library
# library(devtools)
# devtools::install_github("llendway/gardenR")
library(gardenR) # yay, my garden data again!
library(tidyverse)
library(DT) # for table output

veggies <- garden_harvest %>% 
    distinct(vegetable) %>% 
    arrange(vegetable) %>% 
    pull(vegetable)

# Define UI for application
ui <- fluidPage(
    # Application title
    titlePanel("A table and a graph - yay!"),

    # Sidebar with inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "veg", # to use in code
                        label = "Vegetable:", # how it looks in UI
                        choices = veggies, 
                        selected = "tomatoes"
                        )
        ),

        # Show a plot of cumulative weight for chosen vegetable
        # Show a table beneath
        mainPanel(
            plotOutput(outputId = "cum_wt"),
            dataTableOutput(outputId = "cum_wt_tbl")
        )
    )
)

# Define server logic 
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
