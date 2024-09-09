# Inspired by https://trr266.wiwi.hu-berlin.de/shiny/sposm_survey/
# https://github.com/joachim-gassen/sposm/tree/master/code/intro_survey

library(shiny)
library(shinythemes)

fluidPage(
  theme = shinytheme("superhero"),
  title = "Hacking for Social Sciences - Introductory Survey",
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Hacking for Social Sciences"),
        p("Introductory Survey. This course is about you. It is important to know your starting point as well as your individual pain points and needs in programming with data. Please use this opportunity to help shape this course!")
      )
    )
  ),
  uiOutput("icebreaker"),
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Programming"),
        p("Explanation of Grid Scale:
1,2,3,4,5 ->
5: write my own extensions, packages, etc.
4: use this language regularly, very experienced in using existing packages and functions
3: used it in courses
2: played around with it
1: know of it")
      )
    )
  ),
  uiOutput("lang"),
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Infrastructure"),
        p("This Section asks about the Infrastructure familiarity of students ")
      )
    )
  ),
  uiOutput("infrastructure"),
  fluidRow(
    column(
      width = 6,
      div(
        class = "jumbotron",
        h1("Course Expectations "),
        p("This Section asks about the expectations which students have from the course...")
      )
    )
  ),
  uiOutput("workflow"),
  uiOutput("expect"),
  uiOutput("submit"),
  uiOutput("thanks")
)
