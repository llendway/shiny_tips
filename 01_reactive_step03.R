# Goals:
# 1.reactive()
# 2.referencing variable names
# 3.updating UI options based on some other UI result - ie. only varieties from whichever vegetable is selected

## showing reactive()

# Now we add reactivity!!

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

    # First, try this. It WILL NOT work :(    
    # veg_smry <- garden_harvest %>% 
    #     filter(vegetable == input$veg) %>% 
    #     group_by(date) %>% 
    #     summarize(daily_wt = sum(weight)) %>% 
    #     mutate(cum_wt = cumsum(daily_wt))
    
    # Enclose in reactive() - makes a function
    veg_smry <- reactive(garden_harvest %>% 
        filter(vegetable == input$veg) %>% 
        group_by(date) %>% 
        summarize(daily_wt = sum(weight)) %>% 
        mutate(cum_wt = cumsum(daily_wt)))
    
    # Now use that function, with no arguments.
    output$cum_wt <- renderPlot({
        veg_smry() %>% 
            ggplot(aes(x = date, y = cum_wt)) +
            geom_point() +
            geom_line() +
            labs(title = paste("Cumulative weight (g) of", input$veg),
                 x = "",
                 y = "") +
            theme_minimal()
    })
    
    output$cum_wt_tbl <- renderDataTable(veg_smry())

}

# Run the application 
shinyApp(ui = ui, server = server)
