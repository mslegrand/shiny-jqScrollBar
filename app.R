library(shiny)
source("jqScrollBar.R")

initialValue='200'
inputId.1<-"tabs6"
  
ui<-fluidPage(
    h1('Test App'),
    h3('current Value'),
    textOutput('currentValue'),
    
    textInput(inputId='addTabValue','add Tab', ""),
    actionButton('addButton', label='press to add tab'),
    textInput(inputId='removeTabValue','remove Tab', ""),
    actionButton('removeButton', label='press to remove tab by name'),
    textInput(inputId='updateSelectedTab','selected Tab', ""),
    actionButton('updateButton', label='press to update selected tab by name'),
    actionButton('clearButton', label='press to clear'),
    actionButton('removeButton', label='press to remove tab by position'),
    actionButton('removeButton', label='press to update selected tab by position'),
    jqScrollBar(inputId=inputId.1,  value= initialValue)
)

server<-function(input,output,session){
    output$currentValue<-renderText(input[[ inputId.1 ]])
    
    observeEvent(input$addButton,{
        value<-input$addTabValue
        tryCatch({
        updateJqScrollBar(session, inputId.1, cmd='add',value=value )
       }, 
        error=function(e){
            # do nothing , record error
            print('add error')
        })
      },
      ignoreInit = TRUE
    )
  observeEvent(input$removeButton,{
        value<-input$'removeTabValue'
        tryCatch({
            updateJqScrollBar(session, inputId.1, cmd='remove',value=value )
        }, 
        error=function(e){
            # do nothing , record error
            print('remove error')
        })
      },
      ignoreInit = TRUE
    )   
    
    observeEvent(input$updateButton,{
        value<-input$updateSelectedTab
        tryCatch({
            updateJqScrollBar(session, inputId.1, cmd='select',value=value )
        }, 
        error=function(e){
            # do nothing , record error
            print('update selection error')
        })
      },
      ignoreInit = TRUE
    )
    observeEvent(input$clearButton,{
        
        tryCatch({
            updateJqScrollBar(session, inputId.1, cmd='clear',value='value' )
         }, 
        error=function(e){
            # do nothing , record error
            print('update selection error')
        })
      },
      ignoreInit = TRUE
    )
}

shinyApp(ui=ui, server=server)
