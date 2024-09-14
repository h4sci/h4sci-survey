FROM rocker/r-base 
# rocker/version doesnt work with arm64

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* 

# install R dependencies
RUN R -e "install.packages(c('renv', 'shiny'))"

COPY renv.lock /project/renv.lock
WORKDIR /project
RUN R -e "renv::restore()"
WORKDIR /

COPY ./app/ /project/app

EXPOSE 3838


CMD ["R", "-e", "shiny::runApp(port=3838, host='0.0.0.0', '/project/app')"]

