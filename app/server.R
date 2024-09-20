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
      drv = Postgres(),
      user = "postgres",
      host = "localhost",
      dbname = "postgres",
      password = "postgres",
      port = 1111
    )
    dbExecute(con, "SET SEARCH_PATH=rseed")
    dbAppendTable(con, dbQuoteIdentifier(con, "h4sci_intro"), response)
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
      l_go = input$go,
      l_rust = input$rust,
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
      raffle = input$raffle, # TODO: bool?
      survey_year = 2024,
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
              h3("Conceptual Foundations")
            ),
            div(
              class = "panel-body",
              "Indicate which concepts you feel comfortable explaining including drafting a basic demo (if applicable).
              ",
              checkboxGroupInput(
                "icebreaker", "",
                c(
                  "Interpreted Programming Language",
                  "Compiled Programming Language",
                  "Version Control (Git)",
                  "Integrated Development Environments (IDEs)",
                  "HTML/CSS",
                  "Terminal/Command Line",
                  "Continuous Integration/Continuous Deployment (CI/CD)",
                  "Software Libraries/Packages",
                  "Ollama",
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
              sliderInput("go", "go", min = 1, max = 5, value = 3),
              sliderInput("rust", "Rust", min = 1, max = 5, value = 3),
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
                "comments",
                "",
                "", rows=20, cols=150
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
              h3("Win a Copy of Research Software Engineering")
            ),
            div(
              class = "panel-body",
              img(src="rse-book.jpeg", width="200"),
              br(),
              "Please indicate whether you want to take part in the raffle. If you take part, your session token will be revealed to you after you submitted. Please make sure to remember your session token with you so we can identify the winner.",
              radioButtons(
                "raffle",
                "",
                c("No", "Yes")
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
              "Thank you for your participation. Please only take part once.",
              conditionalPanel(
                condition = "input.raffle == 'Yes'",
                sprintf("Here is your session token: %s. We will reveal the first 8 characters of the winner token in class. Please contact us if your token matches.", session$token)
              )
            ),
          
          )
        )
      )
    }
  )
})
