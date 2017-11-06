local tokentool= require "tokentool"
local ret = tokentool.has_token("msg")
ngx.log(ngx.ERR,ret)
if ret == true then
   ngx.say("ok")
else
   ngx.say("oops,error")
end
 
