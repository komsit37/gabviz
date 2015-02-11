library(ggplot2)
library(gridExtra)
library(googleVis)

library(ShinyBuilder)
ShinyBuilder::runShinyBuilder()

source("/Users/komsit37/Development/qserver/qserver.R")
h<-open_connection("127.0.0.1",5555)
cal <- execute(h, "0N!x:select count i by cal from cal where 10>cal-.z.D")
cal <- execute(h, "0N!x:10#select count i by time from cal where 10>cal-.z.D")
as.double(cal$a)


cal <- execute(h, "a")
cal <- execute(h, "b")
cal <- execute(h, "update `int$a from b")
str(cal)
60*60*24*as.double(cal$a)
class(cal$a)[1] == "POSIXt"

=="POSIXt"
1388534400 
(as.double(cal$a) - 1388534400)
32400
9*60*60
cal
plot(gvisTable(cal))

([]a:`a`b;b:1 2)
([]a:2014.01.01 2014.01.02;b:1 2)
#issue JSON.parse('[ [ new Date(2014,0,1),"a" ],[ new Date(2014,0,2),"b" ] ]')

data <- cal
cal
encodeDate <- function(x){
	if ("Date" == class(x)){
		x <- paste0("/Date(", 60*60*24*as.double(x), "000)/")
	}
	return(x)
}
cald <- data.frame(lapply(cal, encodeDate))
class(cal$a)
cald$a

lapply(cal, encodeDate)

str(cal)
encodeDate(cal)
encodeDate(cal$cal)
cal

	paste("f",cal$cal)
encodeDate <- function(x){
	paste0("/Date(", 60*60*24*as.double(data$cal), "000)/")
}
  formatted_data  <- googleVis:::gvisFormat(data)
  formatted_data
  dataLabels      <- RJSONIO::toJSON(formatted_data$data.type)
  dataJSON        <- formatted_data$json
 dataJSON
data
gvisFormat(cal)
gvisFormat <- function(data){
  
  ## Create a list where the Google DataTable type of all variables will be stored
  require(RJSONIO)
  
  ## Convert data.frame to list
  x <- as.list(data)
  varNames <- names(x)
  
  varTypes <- sapply(varNames,
                     function(.x){
                       print(class(x[[.x]]))
                       ifelse(is.numeric(x[[.x]]), 
                          "number",
                        ifelse(is.logical(x[[.x]]),
                          "boolean", 
                        ifelse("Date"==class(x[[.x]]),
                          "date",
                        ifelse("POSIXt"==class(x[[.x]])[1],
                          "datetime",
                          "string"))))
                     }
                     )
  
  x <- lapply(varNames,
              function(.x){
                if("Date"==class(x[[.x]])) 
                  paste0("/Date(", 60*60*24*as.double(x[[.x]]), "000)/") 
                else if ("POSIXt"==class(x[[.x]])[1])
                  paste0("/Date(", as.double(x[[.x]]), ")/") 
                else x[[.x]]
              }
              )
  
  ## factor to character, date to character
  x.df <- as.data.frame(
                        lapply(x,
                               function(a){
                                 if (is.factor(a)) as.character(a) else a
                               }
                               ),
                        stringsAsFactors=FALSE
                        )
  ## needed for toJSON, otherwise names are in json-array
  names(x.df) <-  NULL
  x.array <- lapply(seq(nrow(x.df)),
                    function(.row){
                      do.call("list", x.df[.row,])
                    }
                    )
  
  output <- list(
                 data.type = unlist(varTypes),
                 json = toJSON(x.array)
                 )
  
  return(output)
}


