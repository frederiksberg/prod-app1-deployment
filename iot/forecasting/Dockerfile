FROM trestletech/plumber

RUN R -e "install.packages(c('forecast', 'tseries', 'mice', 'taRifx'))"

CMD ["/app/plumber.R"]