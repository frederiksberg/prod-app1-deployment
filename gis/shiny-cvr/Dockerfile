FROM r-base:3.5.0

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev/unstable \
    libxt-dev \
    libssl-dev \
    python3-pip

RUN wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt) && \
    wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-12.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'reticulate', 'ggplot2', 'rmarkdown'), repos='http://cran.rstudio.com/')"
RUN R -e "require(tinytex);tinytex::install_tinytex()"

RUN cp -R /root/.TinyTeX /opt/
RUN ln -s /opt/.TinyTeX/bin/x86_64-linux/pdflatex /usr/bin/pdflatex 
RUN chown -R shiny:shiny /opt/.TinyTeX

RUN pip3 install elasticsearch elasticsearch-dsl

COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY app /srv/shiny-server/
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]
RUN mkdir -p /srv/shiny-server/cache
RUN chmod -R a+rw /srv/shiny-server

CMD ["/usr/bin/shiny-server.sh"]