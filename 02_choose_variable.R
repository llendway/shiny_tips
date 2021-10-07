# Goals:
# 1.reactive()
# 2.referencing variable names
# 3.updating UI options based on some other UI result - ie. only varieties from whichever vegetable is selected

## showing referencing variable names

library(shiny)
library(tidyverse) # for everything ... almost
library(moderndive) # for kc house data
library(bslib)     #for theming

quant_vars <- house_prices %>% 
    select(-price, -id, where(is.numeric)) %>% 
    names() %>% 
    sort()

# Define UI for application
ui <- fluidPage(
    theme = bs_theme(primary = "#123B60", 
                     secondary = "#D44420", 
                     base_font = list(font_google("Raleway"), "-apple-system", 
                                      "BlinkMacSystemFont", "Segoe UI", "Helvetica Neue", "Arial", 
                                      "sans-serif", "Apple Color Emoji", "Segoe UI Emoji", 
                                      "Segoe UI Symbol"), 
                     bootswatch = "spacelab"),
    # Application title
    titlePanel("What affects price?"),

    # Sidebar with inputs 
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "var", # to use in code
                        label = "Select a variable:", # how it looks in UI
                        choices = quant_vars, 
                        selected = "sqft_living"
                        )
        ),

        # Show a scatterplot of variable on x with 
        # price on y
        mainPanel(
            plotOutput(outputId = "scatter"),
        )
    )
)

# Define server logic 
server <- function(input, output) {

    # Try this first ... what the heck?
    output$scatter <- renderPlot({
        house_prices %>%
            ggplot(aes(x = input$var, y = price)) +
            geom_point() +
            geom_smooth() +
            theme_minimal()
    })

    
    # Need tidy evaluation: https://mastering-shiny.org/action-tidy.html
    # output$scatter <- renderPlot({
    #     house_prices %>% 
    #         ggplot(aes(x = .data[[input$var]], y = price)) +
    #         geom_point() +
    #         geom_smooth() +
    #         theme_minimal()
    # })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
