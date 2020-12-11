library(shiny)
library(svgR)
library(jsonlite)

try({ removeInputHandler("jqScrollBarBinding") })

# add any helper functions here




#' Constructor for the jqScrollBar
#' 
#' @param inputId the id of this shiny input
#' @param value the initial value for this control
#' export
jqScrollBar<-function(inputId,  value='whatever' ){
# note: use toJSON for non-trivial initializations  
 
  tagList(
      singleton(tags$head(tags$script(src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"))), 
      singleton(tags$head(tags$script(src = "jquery.scrolltabs.js"))), 
      singleton(tags$head(tags$script(src = "jquery.mousewheel.js"))),
      singleton(tags$head(tags$script(src = "jqScrollBar.js"))),
      tags$link(rel = "stylesheet", type = "text/css", href = "scrolltabs.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "demo.css"),
      
           div( id=inputId, class="jqScrollBar style1",
                span(rel='1', "First Tab"),
                span(rel='3', "Third Tab"),
                span(rel='4', "Forth Tab"),
                span(rel='5', "Fifth Tab"),
                span(rel='6', "Sixth Tab"),
                span(rel='7', "Seventh Tab"),
                span(rel='2', "Second Tab")
           )
           # STEP 2.3 customize for initialization by attaching data-*** to this div
           # Note: 
           #      'data-xxx'=yyy  only accepts vectors of length 1
           #      for more complex data, try using toJSON to convert value
           #'data-value'=value #attaches value as string to this div
              
  )
}

#' updateJqScrollBar
#' server to client update
#' 
#' @param session the shiny session
#' @param inputId the control Id
#' @param value update with this value
#' @export
updateJqScrollBar<-function(session, inputId, cmd,  value='bogus'){
            # 2. Form message
                mssg<-list(cmd=cmd, text=value) 
            # 3. Send message to client
                session$sendInputMessage(inputId, mssg)
}


# preprocess data returned to server from the client
shiny::registerInputHandler(
  "jqScrollBarBinding", 
  function(value, shinysession, inputId) {
    if(is.null(value) ) {
      return("NULL")
    } else {
      # STEP 6.1: process value (may use fromJSON)
      value<-fromJSON(value);
      print(value)
      # STEP 7: add updateJqScrollBar()
      
      return(value$text)
    }
  }
)



