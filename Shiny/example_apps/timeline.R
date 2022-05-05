
  library(shiny)
  library(shinydashboard)
  library(shinydashboardPlus)
  
  shinyApp(
    ui = dashboardPage(
      dashboardHeader(),
      dashboardSidebar(),
      dashboardBody(
        h3("When Reversed = TRUE, can be displayed inside a box"),
        box(
          title = "Timeline",
          status = "info",
          timelineBlock(
            width = 12,
            timelineEnd(color = "red"),
            timelineLabel(2018, color = "teal"),
            timelineItem(
              title = "Item 1",
              icon = icon("gears"),
              color = "olive",
              time = "now",
              footer = "Here is the footer",
              "This is the body"
            ),
            timelineItem(
              title = "Item 2",
              border = FALSE
            ),
            timelineLabel(2015, color = "orange"),
            timelineItem(
              title = "Item 3",
              icon = icon("paint-brush"),
              color = "maroon",
              timelineItemMedia(image = "https://placehold.it/150x100"),
              timelineItemMedia(image = "https://placehold.it/150x100")
            ),
            timelineStart(color = "purple")
          )
        ),
        h3("When Reversed = FALSE, can be displayed out of a box"),
        timelineBlock(
          reversed = FALSE,
          timelineEnd(color = "red"),
          timelineLabel(2018, color = "teal"),
          timelineItem(
            title = "Item 1",
            icon = icon("gears"),
            color = "olive",
            time = "now",
            footer = "Here is the footer",
            "This is the body"
          ),
          timelineItem(
            title = "Item 2",
            border = FALSE
          ),
          timelineLabel(2015, color = "orange"),
          timelineItem(
            title = "Item 3",
            icon = icon("paint-brush"),
            color = "maroon",
            timelineItemMedia(image = "https://placehold.it/150x100"),
            timelineItemMedia(image = "https://placehold.it/150x100")
          ),
          timelineStart(color = "purple")
        )
      ),
      title = "timelineBlock"
    ),
    server = function(input, output) { }
  )
