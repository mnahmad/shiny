FROM rocker/r-ver:3.5.2

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    gdal-bin \
    libgdal-dev \
    libudunits2-dev \
    libcairo2-dev \
    libxt-dev \
    wget


# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')" && \
    R -e "install.packages(c('shinydashboard','leaflet','RColorBrewer','lattice','dplyr','DT','ggplot2','ggthemes','scales','reshape2','raster','rgdal','stringr'), repos='http://cran.rstudio.com/')" && \ 
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

COPY slExplorer /srv/shiny-server/slExplorer

CMD ["/usr/bin/shiny-server.sh"]
