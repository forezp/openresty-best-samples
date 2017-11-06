local tokentool = require "tokentool"
local mysqltool = require "mysqltool"

 function is_include(value, tab)
   for k,v in ipairs(tab) do
      if v == value then
           return true
       end
    end
    return false
 end

local white_uri={"/user/login","/user/validate"}
  

local headers = ngx.req.get_headers() 
local token=headers["token"]
local url=ngx.var.uri
if ( not token) or (token==null) or (token ==ngx.null) then
  if is_include(url,white_uri)then
     
  else
    return ngx.exit(401)
  end  
else 
  ngx.log(ngx.ERR,"token:"..token)
  local user_id=tokentool.get_user_id(token)
  if (not user_id) or( user_id ==null) or ( user_id == ngx.null) then
      return ngx.exit(401)   
  end 
  
  ngx.log(ngx.ERR,"user_id"..user_id)
  local permissions={}
  permissions =tokentool.get_permissions(user_id)
  if(not permissions)or(permissions==null)or( permissions ==ngx.null) then
      permissions= mysqltool.select_user_permission(user_id)
      if permissions and permissions ~= ngx.null then
         tokentool.set_permissions(user_id,permissions)
      end
  end  
  if(not permissions)or(permissions==null)or( permissions ==ngx.null) then
     return ngx.exit(401)
  end 
  local is_contain_permission = is_include(url,permissions) 

  if is_contain_permission == true  then
    
  else
      return ngx.exit(401) 
  end   
end




