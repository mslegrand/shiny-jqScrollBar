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
        $(el).scrollTabs();
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
            //$("span").filter(function() { return ($(this).text().indexOf('FIND ME') > -1) }); -- anywhere match
            //$("span").filter(function() { return ($(this).text() === 'FIND ME') }); -- exact match
            switch(cmd){
              case 'add': //to iterate use array.forEach(x=>{...})
              if(typeof(text)==='string'){
                  $('#tabs6').scrollTabs().addTab("<span>"+text+"</span>", 0)
                  } else {
                      text.forEach(t=>$('#tabs6').scrollTabs().addTab("<span>"+t+"</span>", 0) )
                  }
                  break;
              case 'remove':
                  $('#tabs6').scrollTabs().removeTabs("span:contains('"+text+"')")
                  break;
              case 'select':
                  //$('#'+id).find("span:contains('"+text+"')").trigger('click')
                  $('#'+el.id).find('span').filter(function(){
                      if ($(this).text() === text){
                          $(this).trigger('click')
                      }
                  })
                  break;
              case 'rename':
                  //let id = el.id
                  console.log(JSON.stringify(text))
                  $('#'+el.id).find('span').filter(function(){
                      if ($(this).text() === text.oldName){
                          $(this).text(text.newName)
                      }
                  })
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



// REGISTER INPUT BINDING
Shiny.inputBindings.register(jqScrollBarBinding);

