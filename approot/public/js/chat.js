(function(){
     function send_handler(ev){
         var mes = $("#mes").val();
         $("#mes").val("");
         jQuery.post("/post",{"mes":mes});
         setTimeout(ajax_get,100);
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
     //setInterval(ajax_get,1000);
}())
