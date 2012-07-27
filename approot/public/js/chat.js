(function(){
     //var servername = "localhost:8080"
     //var servername = "chatcloud-ls.dotcloud.com:32901"
     //var ws = new WebSocket("ws://" + servername );
     var ws = new WebSocket(ws_url);
     
     function send_handler(ev){
         var mes = $("#mes").val();
         $("#mes").val("");
         jQuery.post("/post",{"mes":mes});
         ws.send("ping");
     }

     function ajax_get(){
         jQuery.get("/get",{},function(data){
                        var list = eval("("+data+")");
                        var j_list = $("#list");
                        j_list.find("p").remove();
                        for (var i = 0,l=list.length;i<l;i++){
                            var p = $("<p>");
                            p.text(list[i]);
                            j_list.append(p);
                        }
                    });
     }

     $("#send").click(send_handler);
     $("#get").click(ajax_get);
     
     ws.onmessage = function(evt) {
         console.log("recv");
         console.log(evt.data);
         ajax_get();
     };
     
     ws.onclose = function() {
         console.log("close");
     };
     
     ws.onopen = function() {
         console.log("connected");
     };
     
 }())
