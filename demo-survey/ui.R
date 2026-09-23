# Inspired by https://trr266.wiwi.hu-berlin.de/shiny/sposm_survey/
# https://github.com/joachim-gassen/sposm/tree/master/code/intro_survey

library(shiny)
library(shinythemes)

fluidPage(
  theme = shinytheme("superhero"),
  title = "Hacking for Sciences - Demo Survey",
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Hacking for Sciences"),
        p("Some Introductory paragraph motivating our survey.")
      )
    )
  ),
  uiOutput("basic_questions"),
  uiOutput("submit"),
  uiOutput("thanks")
)