ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello, monkey, __testing
  }
  
  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }
    monkey = function(obj) {
      msg = "Hello " + obj.defaultsTo("Monkey");
      msg.isnull()
    }
    __testing = { "queries": [ 
                    { "name": "hello", "args": [ "obj" ] },
                    { "name": "monkey", "args": [ "obj" ] },
                    { "name": "__testing" } ], 
                           
              "events": [ 
                { "domain": "echo", "type": "hello",
                "attrs": [ "name" ] }, 
              
                { "domain": "echo", "type": "monkey",
                "attrs": [ "name" ] }
              ]
            }
  }
  
  rule hello_world {
    select when echo hello
    pre {
      name = event:attr("name").klog("our passed in name: ")
    }
    send_directive("say", {"something": "Hello World"})
  }
  
  rule hello_monkey {
    select when echo monkey
    pre {
      name = event:attr("name").defaultsTo("Monkey").klog("name attr equals: ")
      /*
      name = event:attr("name").klog("name attr equals: ")
      name = (name=="") => "Monkey"
      | name
      //*/
      log = name.isnull().klog("name is null? ")
    }
    send_directive("say", {"something": "Hello " + name})
  }
  
}