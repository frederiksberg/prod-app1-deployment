library(shiny)
library(reticulate)
library(RColorBrewer)
# use_condaenv(condaenv = "base")
use_python('/usr/bin/python3')

# Define UI
ui <- fluidPage(
    titlePanel("Erhversudvikling"),
    inputPanel(
        sliderInput("aar_adjust", label = "aar:",
                    min = 1999, max = 2019, value = 1, step = 1,
                    animate = animationOptions(interval = 600, loop = TRUE)),
        downloadButton("report", "Generer rapport")
    ),
    plotOutput("plot1"),
    plotOutput("plot2")
)

# Define server
server <- function(input, output) {
    
    # Data
    # Get data
    py_run_file("parser.py")
    
    D <- Sys.Date()
    f <- paste("./cache/", format(D, "%G"), "_", format(D, "%V"), ".cache", sep="")
    
    obj <- py_load_object(f)
    
    # Unwrap
    A_counts <- obj[1][[1]]
    A_all <- obj[2][[1]]
    A_sort <- obj[3][[1]]
    B_counts <- obj[4][[1]]
    B_all <- obj[5][[1]]
    B_leg <- obj[6][[1]]
    
    
    # Prep
    M1 <- max(unlist(Map({function(a) Map({function(b) b[2]}, a)}, unname(B_counts))))
    M2 <- max(unlist(Map({function(a) Map({function(b) b[2]}, a)}, unname(A_counts))))
    
    # First plot
    output$plot1 <- renderPlot({
        M1 <- max(unlist(Map({function(a) Map({function(b) b[2]}, a)}, unname(B_counts))))
        cols <- rainbow(length(B_all), 0.5)
        l <- B_counts[[toString(input$aar_adjust)]]
        labs <- unlist(Map({function(a) a[[1]]}, l))
        vals <- unlist(Map({function(a) a[[2]]}, l))
        par(xpd = T, mar = par()$mar + c(0,0,0,15))
        barplot(vals, names.arg = labs, main = toString(input$aar_adjust),
                ylim = c(0, M1), col = cols)
        legend(length(l)+5, M1, legend=B_leg, pch=15, col = cols)
        par(mar=c(5,4,4,2) + 0.1)
        
        
    })
    
    # Second plot
    output$plot2 <- renderPlot({
        M2 <- max(unlist(Map({function(a) Map({function(b) b[2]}, a)}, unname(A_counts))))
        l <- A_counts[[toString(input$aar_adjust)]]
        labs <- unlist(Map({function(a) a[[1]]}, l))
        vals <- unlist(Map({function(a) a[[2]]}, l))
        barplot(vals, names.arg = labs, main = toString(input$aar_adjust), ylim = c(0, M2)) 
    })
    
    # Report export
    output$report <- downloadHandler(
        
        filename <- "report.pdf",
        content <- function(file) {
            tempReport <- file.path(tempdir(), "report.Rmd")
            file.copy("report.Rmd", tempReport, overwrite = T)
            
            options(tinytex.verbose = T)
            
            params <- list(year = input$aar_adjust,
                           A_counts = A_counts,
                           A_all = A_all,
                           A_sort = A_sort,
                           B_counts = B_counts,
                           B_all = B_all,
                           B_leg = B_leg)
            
            rmarkdown::render(tempReport, output_file=file,
                              params=params,
                              envir = new.env(parent = globalenv()))
        }
        
    )
}


# Run app
shinyApp(ui = ui, server = server)
