(function(){
     function send_handler(ev){
         var mes = $("#mes").val();
         console.log(mes);
         $("#mes").val("");
         jQuery.post("/post",{"mes":mes});
         ajax_get();
     }

     function ajax_get(){
         jQuery.get("/get",{},function(data){
                        var list = eval("("+data+")");
                        console.log(data);
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
