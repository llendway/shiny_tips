# Goals:
# 1.reactive()
# 2.referencing variable names
# 3.updating UI options based on some other UI result - ie. only varieties from whichever vegetable is selected

## updating UI options based on some other UI result

# In this step we set up the UI

library(shiny)
# If you need to install my gardenR library
# library(devtools)
# devtools::install_github("llendway/gardenR")
library(gardenR) # yay, my garden data again!
library(tidyverse)

veggies <- garden_harvest %>% 
    distinct(vegetable) %>% 
    arrange(vegetable) %>% 
    pull(vegetable)

# Define UI for application
ui <- fluidPage(
    # Application title
    titlePanel("Update the variety within a veggie"),

    # Sidebar with inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "veg", # to use in code
                        label = "Vegetable:", # how it looks in UI
                        choices = veggies, 
                        selected = "tomatoes"
                        ),
            selectInput(inputId = "variety", # to use in code
                        label = "Variety:", # how it looks in UI
                        multiple = TRUE, # can choose more than one
                        choices = NULL # this will depend on veggie selection! 
            )
            
        ),
        # Show a barplot of chosen varieties within chosen veggie
        mainPanel(
            plotOutput(outputId = "total_wt")
        )
    )
)

# Define server logic 
server <- function(input, output) {
    vegetable <- reactive({
        garden_harvest %>% 
            filter(vegetable == input$veg)
    })
    
# This is the key piece of code    
# We use a combination of observeEvent and updateSelectInput
# There are many updateXXX() functions
# Think of this as observe the vegetable() (filtered to the chosen veggie)
# Then, make my list of variety choices and update the "variety" inputId with those choices.
    observeEvent(vegetable(), {
        choices <- vegetable() %>% 
            distinct(variety) %>% 
            arrange(variety) %>% 
            pull(variety)
        updateSelectInput(inputId = "variety", choices = choices) 
    })
    
    veg_variety <- reactive({
        vegetable() %>% 
            filter(variety %in% input$variety)
    })

    output$total_wt <- renderPlot({
        req(input$variety) # check that this is here (you've done the selecting)
        veg_variety() %>% 
            group_by(variety) %>% 
            summarize(tot_wt = sum(weight)) %>% 
            ggplot(aes(y = fct_reorder(variety, tot_wt),
                       x = tot_wt)) +
            geom_col() +
            labs(title = paste("Total weight (g)", input$veg, "varieties"),
                 x = "",
                 y = "")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
