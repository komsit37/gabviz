# Copyright (c) 2014 Clear Channel Broadcasting, Inc. 
# https://github.com/iheartradio/ShinyBuilder
# Licensed under the MIT License (MIT)

#require(shiny)

#Render Google Chart as Shiny output
renderGoogleChart <- function(expr, env=parent.frame(), quoted = FALSE){
  func <- exprToFunction(expr, env, quoted)
  function(){ 
    val <- func()
    val
  }
}

gvisFormat <- function(data){
  
  ## Create a list where the Google DataTable type of all variables will be stored
  require(RJSONIO)
  
  ## Convert data.frame to list
  x <- as.list(data)
  varNames <- names(x)
  
  varTypes <- sapply(varNames,
                     function(.x){
                       #print(class(x[[.x]]))
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
                  paste0("/Date(", as.double(x[[.x]]), "000)/") 
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


#Generate Google Chart Object
googleChartObject <- function(data, type, options){
  formatted_data  <- gvisFormat(data)

  #print('====Chart Object====')
  #print(formatted_data)

  dataLabels      <- toJSON(formatted_data$data.type)
  #print('====Chart data type====')
  #print(formatted_data$data.type)

  dataJSON        <- formatted_data$json
  return(list(dataLabels = dataLabels, dataJSON = dataJSON, chartType = type, options = options))
}

#Shiny chart output element
googleChartOutput <- function(chartid){tagList(
  HTML(paste0('<div id = "', chartid, '" class="shinyGoogleChart" style = "width: 100%; height:100%; overflow-y: hidden; overflow-x: hidden"></div>'))
)}

#Shiny chart editor output element
googleChartEditor <- function(id, target, type = 'Table', options = '{}', label = 'Edit Chart'){tagList(
  #singleton(HTML('<script type="text/javascript" src="//www.google.com/jsapi"></script>')),
  #singleton(includeScript(paste0(getwd(),'/www/googleChart_init.js'))),
  
  #ChartEditor Button  
  HTML(paste0("<div class = 'chartEditor btn' style='display:inline;' onclick='openChartEditor(\"", target, 
     "\");' data-target = '", target, "' options = '", options,
     "' chartType = '", type,"' id = '", id,"'>",label,"</div> ")),

  singleton(tags$script(
       "var openChartEditor = function(chartId){
        var wrapper = $('#'+chartId).data('chart');
        var editor = new google.visualization.ChartEditor();
        google.visualization.events.addListener(editor, 'ok',
             function() {
              var new_wrapper = editor.getChartWrapper();
              new_wrapper.draw($('#'+chartId));
              $('#'+chartId).data('chart', new_wrapper);
              $('#'+chartId+'_editor').attr('chartType', new_wrapper.getChartType());
              $('#'+chartId+'_editor').attr('options', JSON.stringify(new_wrapper.getOptions()));
              $('#'+chartId+'_editor').trigger('change.chartEditorInputBinding');
            }
        );
        editor.openDialog(wrapper);
        };"))
            
)}