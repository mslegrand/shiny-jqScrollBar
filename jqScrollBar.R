library(shiny)
library(svgR)
library(jsonlite)

try({ removeInputHandler("jqScrollBarBinding") })


#' Constructor for the jqScrollBar
#' 
#' @param inputId the id of this shiny input
#' @param value the initial value for this control
#' export
jqScrollBar<-function(inputId,  choices =choices, selected=null){
# note: use toJSON for non-trivial initializations 
  txt=selected
  if(!is.null(selected) && class(selected)=="character"){
      txt=selected
  }else if(
        !is.null(selected) && 
        class(selected)=="numeric" && 
        selected>0 && 
        selected<length(choices)
  ){
      txt=names(choices)[[selected]]
  }
  fn<-function(n,txt){span(rel=n,txt)}
  value=toJSON(data.frame(text=txt, rel=choices[[txt]]))
  
  ll<-mapply(fn, choices, names(choices),SIMPLIFY = FALSE)
  tagList(
      singleton(tags$head(tags$script(src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"))), 
      singleton(tags$head(tags$script(src = "jquery.scrolltabs.js"))), 
      singleton(tags$head(tags$script(src = "jquery.mousewheel.js"))),
      singleton(tags$head(tags$script(src = "jqScrollBar.js"))),
      tags$link(rel = "stylesheet", type = "text/css", href = "scrolltabs.css"),
      tags$link(rel = "stylesheet", type = "text/css", href = "ptRScrollTabs.css"),
      div( id=inputId, class="jqScrollBar style1",
                ll,
                'data-ini'=value #attaches value as string to this div
           )
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
      return(value$text)
    }
  }
)



