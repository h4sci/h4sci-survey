# Hacking for Science Survey

Simple R shiny based survey and report to get an idea of students programming and data backgrounds. 
The survey uses a PostgreSQL transaction backend to store participants answers.
The questionnaire is an R shiny frontend. 


## Local Development Using Docker 

With Docker running, e.g., via Docker Desktop, simply run `docker-compose up`. 
Note that the shiny server part is commented out, because it is not strictly needed as you can use a local R session as your shiny server. 
Feel free to use shiny server from docker container to have a more production like setup. 
Either way, make sure that your shiny app uses the Postgres port that is exposed by the container (1111 in this example).

