
library(forecast)
library(tseries)
library(mice)
library(taRifx)

#* @param wfc Comma seperated weather observarions in 10 min spacing
#* @post /gv
#* @serializer unboxedJSON
function(req, wfc) {
  
  string <- paste(req$postBody, collapse='\n')
  
  data <- read.csv2(text=string, header=T, stringsAsFactors = F, sep=',', colClasses=c("ts" = "POSIXct"))
  data <- japply(data, which(sapply(data, class)=="character"), as.numeric)
  
  wfc <- diff(ts(as.numeric(unlist(strsplit(wfc, split=",")))))
  
  NAs <- sum(sapply(data[,-1], function(x) sum(is.na(x))))
  hasNAs <- NAs > 0
  
  if(hasNAs){
    tempData <- mice(data, m = 1, maxit = 25, meth = "cart")
    data <- complete(tempData, 1)
  }
  
  h878 <- diff(ts(data$h878))
  nedbor <- diff(ts(data$nedbor))
  
  df <- data.frame(h878 = h878, time = as.numeric(time(h878)), nedbor=nedbor)
  
  model <- tslm(h878~trend+nedbor, df)
  
  new_data <- data.frame(nedbor = wfc)
  
  fc <- forecast(model, newdata = new_data)
  
  m <- fc$mean
  l <- fc$lower
  u <- fc$upper
  
  offset <- tail(data$h878, n=1)
  
  m <- offset + cumsum(m)
  l <- offset + cumsum(l)
  u <- offset + cumsum(u)
  
  list(means = m, lowers = l, uppers = u)
  
}
