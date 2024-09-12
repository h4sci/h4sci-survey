# Inspired by https://trr266.wiwi.hu-berlin.de/shiny/sposm_survey/
# https://github.com/joachim-gassen/sposm/tree/master/code/intro_survey

library(shiny)
library(shinythemes)

fluidPage(
  theme = shinytheme("superhero"),
  title = "Hacking for Sciences - Introductory Survey",
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Hacking for Sciences"),
        p("Introductory Survey. This course is about you. It is important to know your starting point as well as your individual pain points and needs in programming with data. Please use this opportunity to help shape this course!")
      )
    )
  ),
  uiOutput("icebreaker"),
  uiOutput("reporting"), # add other (text-box)
  uiOutput("lang"), # add other (text-box)
  uiOutput("infrastructure"),
  uiOutput("expect"),
  uiOutput("groupwork"),
  uiOutput("comments"),
  uiOutput("raffle"),
  uiOutput("submit"),
  uiOutput("thanks")
)
