// JAVASCRIPT

//INPUT BINDING
var jqScrollBarBinding = new Shiny.InputBinding();
$.extend(jqScrollBarBinding, {
    find: function(scope) {
        return $(scope).find(".jqScrollBar");
    },
    initialize: function(el){
        //  Initialize element data here:
        // may use the dnds:
        
        //  1. get element data, hint: use dnd 'from string ' 
        //$el.scrollTabs();
        let value = {
            rel: '',
            text: ''
        }
        $(el).data('value', value)
        $(el).data('rel', '');
        $(el).data('text','');
    },
    getValue: function(el) {
      // Used for returning the value(s) of this input control
      //console.log('getValue');
      // Typically,  held as element data, ie. $(el).data('value')
      let value=$(el).data('value');
      //console.log('getValue');
      // if value is an object, may want to use JSON.stringify
      value=JSON.stringify(value);
      //console.log('getValue: value='+value);
      return value ;
    },
    setValue: function(el,  value) { 
      // used for updating input control
      // Typically
      //  1. set element data value
      //console.log('setValue el='+JSON.stringify(el));
      //console.log('setValue: value='+JSON.stringify(value));
          $(el).data('value', value);
       //console.log('setValue2: value='+JSON.stringify(value));   
      //  2. then trigger element change
          $(el).trigger("change");
       //console.log('setValue3: value=change'+JSON.stringify(value));     
    },
    subscribe: function(el, callback) {
        // notify server whenever change
        console.log('change');
        $(el).on("change.jqScrollBarBinding", function(e) {
            console.log('change');
            callback();
        });
    },
    unsubscribe: function(el) {
        $(el).off(".jqScrollBarBinding");                              
    },
    receiveMessage: function(el, data) { //called when server sends update message
        if(!!data){
            let cmd = data.cmd;
            let text =data.text
            
            switch(cmd){
              case 'add':
                  $('#tabs6').scrollTabs().addTab("<span>"+text+"</span>")
                  break;
              case 'remove':
                  $('#tabs6').scrollTabs().removeTabs("span:contains('"+text+"')")
                  break;
              case 'select':
                  let id = el.id
                  $('#'+id).find("span:contains('"+text+"')").trigger('click')
                  break;
              case 'clear':
                  $('#tabs6').scrollTabs().clearTabs();
                  break;
              default:
            }
        }
    },
    
    // STEP 5.1 add handler clicked: (hint use)
    clicked: function(ctrlId, value, evt ){
      //alert('hi from '+  ctrlId +" my value is " + JSON.stringify(value)); //for testing
      let el='#'+ctrlId;
      this.setValue( el, value)
    },
    
    getType: function(el){ 
      return "jqScrollBarBinding";
    }
});

$(document).ready(function(){
    $('#tabs6').scrollTabs();// how to avoid this?
      //$.tabs6 = $('#tabs6').scrollTabs(); // how to avoid this?
});

// REGISTER INPUT BINDING
Shiny.inputBindings.register(jqScrollBarBinding);

