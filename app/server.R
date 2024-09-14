library(shiny)
library(shinyjs)
library(DBI)
library(RPostgres)

shinyServer(function(input, output, session) {
  # it should be sufficient to store the session token.
  # cookies auth is a more sophisticated alternative, but
  # let's not dive into js to deep for now.
  # session$token

  store_record <- function(response) {
    con <- dbConnect(
      drv = Postgres(), dbname = "kofdb", user = "shiny",
      host = "archivedb.kof.ethz.ch",
      password = "postgres"
    )
    # TODO: change teaching? to rseed?
    dbExecute(con, "SET SEARCH_PATH=teaching")
    dbAppendTable(con, dbQuoteIdentifier(con, "responses"), response)
    dbDisconnect(con)
  }

  submitted <- reactiveVal(FALSE)


  response <- reactive({
    dt <- data.frame(
      id = session$token,
      icebreaker = paste(input$icebreaker, collapse = ","),
      reporting = paste(input$reporting, collapse = ","),
      # name in db is left
      l_r = input$r,
      l_python = input$python,
      l_julia = input$julia,
      l_matlab = input$matlab,
      l_sql = input$sql,
      l_cpp = input$cpp,
      l_js = input$js,
      l_web = input$web,
      i_docker = input$docker,
      i_kubernetes = input$kubernetes,
      i_euler = input$euler,
      i_cloud = input$cloud,
      i_cicd = input$cicd,
      expect = paste(input$expect, collapse = ","),
      groupwork = paste(input$groupwork, collapse = ","),
      comments = input$comments,
      # is this the correct way to incl. radio button answer
      raffle = input$icebreaker, # TODO: bool?
      year = 2024,
      stringsAsFactors = FALSE
    )
  })

  observeEvent(input$submit, {
    store_record(response())
    submitted(TRUE)
    # has_participated(TRUE)
    # js$setcookie("HAS_PARTICIPATED_IN_SPOSM_INTRO_SURVEY")
  })

  output$test <- renderText({
    as.character(submitted())
  })


  output$icebreaker <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Ice Breaker")
            ),
            div(
              class = "panel-body",
              "Imagine you have to explain the following concepts to your peers. Indicate which ones you feel comfortable explaining
              (multiple may apply).",
              checkboxGroupInput(
                "icebreaker", "",
                c(
                  "Interpreted Programming Languages",
                  "Compiled Programming Languages",
                  "Version Control (Git)",
                  "Integrated Development Environments (IDEs)",
                  "HTML/CSS",
                  "Terminal/Command Line",
                  "Continuous Integration/Continuous Deployment (CI/CD)",
                  "Software Libraries/Packages",
                  "Debugging",
                  "SCRUM",
                  "Kanban",
                  "Open Source"
                )
              )
            )
          )
        )
      )
    }
  )

  output$reporting <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Reporting")
            ),
            div(
              class = "panel-body",
              "Which of the following reporting tools and frameworks do you use?
              (multiple may apply).",
              checkboxGroupInput(
                "reporting", "",
                c(
                  "LaTeX",
                  "Overleaf",
                  "Typst",
                  "Quarto",
                  "Markdown (md)",
                  "Notebooks (like Jupyter)"
                  # other - text input
                )
              )
            )
          )
        )
      )
    }
  )

  output$lang <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Programming Languages")
            ),
            div(
              class = "panel-body",
              "Please indicate your familiarity with the following programming languages.
              1 = never heard of it, 2 = trying out status, 3 = used it in courses or projects,
              4 = use this language regularly, very experienced in using existing packages and functions,
              5 = write my own extensions, packages, etc.",
              sliderInput("r", "R", min = 1, max = 5, value = 3),
              sliderInput("python", "Python", min = 1, max = 5, value = 3),
              sliderInput("julia", "Julia", min = 1, max = 5, value = 3),
              sliderInput("matlab", "Matlab", min = 1, max = 5, value = 3),
              sliderInput("sql", "SQL", min = 1, max = 5, value = 3),
              sliderInput("cpp", "Cpp", min = 1, max = 5, value = 3),
              sliderInput("js", "Javascript", min = 1, max = 5, value = 3),
              sliderInput("web", "HTML/CSS", min = 1, max = 5, value = 3)
              # ,
              # sliderInput("other", "Other"....)
            )
          )
        )
      )
    }
  )


  output$infrastructure <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Infrastructure")
            ),
            div(
              class = "panel-body",
              "The ability to run computations in the cloud or resurrect an
              ugly research setup from the old days in an isolated environment
              can be very valuable. Please indicate your familiarity
              with the following infrastructure. 1 = never heard of it,
              2 = trying out status, 3 = working with it in real life projects,
              4 = several years of experience, 5 = expert",
              sliderInput("docker", "Docker", min = 1, max = 5, value = 3),
              sliderInput("kubernetes", "Kubernetes", min = 1, max = 5, value = 3),
              sliderInput("euler", "Euler/Leomed", min = 1, max = 5, value = 3),
              sliderInput("cloud", "Commercial Cloud: AWS, Azure, GCP", min = 1, max = 5, value = 3),
              sliderInput("cicd", "Continuous Integration/ Continuous Deployment", min = 1, max = 5, value = 3)
            )
          )
        )
      )
    }
  )

  output$expect <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Course Expectations")
            ),
            div(
              class = "panel-body",
              "What do you expect to learn from this course?",
              checkboxGroupInput(
                "expect", "",
                c(
                  "Data cleaning, analytics and communication",
                  "Web development skills",
                  "Data management best practices",
                  "Automating workflows",
                  "Collaboration tools and techniques"
                  # other
                )
              )
            )
          )
        )
      )
    }
  )

  output$groupwork <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Group Work Expectations")
            ),
            div(
              class = "panel-body",
              "What do you expect from the group work in this course?",
              checkboxGroupInput(
                "groupwork", "",
                c(
                  "Collaboration on coding projects",
                  "Apply new skills from the course",
                  "deep-diving into my research topics"
                  # other..
                )
              )
            )
          )
        )
      )
    }
  )

  output$comments <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Additional Expectations")
            ),
            div(
              class = "panel-body",
              "Do you have any additional unaddressed expectations or comments you would like to submit?",
              textAreaInput(
                "text",
                ""
              )
            )
          )
        )
      )
    }
  )

  output$raffle <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Raffle Participation")
            ),
            div(
              class = "panel-body",
              "If you would like to participate in the Raffle to win a physical copy of the Research Software Engineering Book by Dr. Matthias Bannert, please indicate so below:",
              radioButtons(
                "raffle",
                "",
                c("Yes", "No")
              )
            )
          )
        )
      )
    }
  )



  output$submit <- renderUI(
    if (!submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-primary",
            div(
              class = "panel-heading",
              h3("Submit Your Answers!")
            ),
            div(
              class = "panel-body", align = "right",
              actionButton("submit", "submit")
            )
          )
        )
      )
    }
  )

  output$thanks <- renderUI(
    if (submitted()) {
      fluidRow(
        column(
          width = 6,
          div(
            class = "panel panel-info",
            div(
              class = "panel-heading",
              h3("Thank You")
            ),
            div(
              class = "panel-body", align = "right",
              "Thank you for your participation. Please only take part once."
            )
          )
        )
      )
    }
  )
})
