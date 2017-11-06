local arg = ngx.req.get_uri_args()
for k,v in pairs(arg) do
   ngx.say("[GET ] key:", k, " v:", v)
end

ngx.req.read_body() -- 解析 body 参数之前一定要先读取 body
   local arg = ngx.req.get_post_args()
for k,v in pairs(arg) do
   ngx.say("[POST] key:", k, " v:", v)
end


local headers = ngx.req.get_headers()  
ngx.say("headers begin", "<br/>")  
ngx.say("Host : ", headers["Host"], "<br/>")  
ngx.say("user-agent : ", headers["user-agent"], "<br/>")  
ngx.say("user-agent : ", headers.user_agent, "<br/>")  
for k,v in pairs(headers) do  
    if type(v) == "table" then  
        ngx.say(k, " : ", table.concat(v, ","), "<br/>")  
    else  
        ngx.say(k, " : ", v, "<br/>")  
    end  
end 


ngx.say("ngx.req.http_version : ", ngx.req.http_version(), "<br/>")  
  
ngx.say("ngx.req.get_method : ", ngx.req.get_method(), "<br/>")  

ngx.say("ngx.req.raw_header : ",  ngx.req.raw_header(), "<br/>")  
 
ngx.say("ngx.req.get_body_data() : ", ngx.req.get_body_data(), "<br/>")  
ngx.say("<br/>")  

