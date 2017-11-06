

local mysql = require("resty.mysql")  
 
local function close_db(db)  
    if not db then  
        return  
    end  
    db:close()  
end  



local function select_user_permission(user_id)

   local db, err = mysql:new()
   if not db then  
      ngx.say("new mysql error : ", err)  
      return  
   end 
   db:set_timeout(1000)  
  
   local props = {  
      host = "127.0.0.1",  
      port = 3306,  
      database = "test",  
      user = "root",  
      password = ""  
   }

  local res, err, errno, sqlstate = db:connect(props)  
  
  if not res then  
     ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
     close_db(db)
  end
  
  local select_sql = "SELECT  a.id,a.permission from permission a ,role_permission b,role c,user_role d,user e WHERE a.id=b.permission_id and c.id=b.role_id and d.role_id=c.id and d.user_id=e.id and e.id="..user_id
  res, err, errno, sqlstate = db:query(select_sql)  
  if not res then  
     ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)  
     return close_db(db)  
  end  

   local permissions={}
   for i, row in ipairs(res) do  
     for name, value in pairs(row) do
	if name == "permission" then
          table.insert(permissions, 1, value)
        end  
    end  
   end  
 return permissions 
end

local _M = {  
    select_user_permission= select_user_permission
}  
  
return _M  
  
