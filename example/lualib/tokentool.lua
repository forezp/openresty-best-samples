module("tokentool", package.seeall)
local redis = require "resty.redis"
local str = require "resty.string"
local cjson = require("cjson")  


local redis_host = "127.0.0.1"
local redis_port = 6379

local function close_redis(red)  
    if not red then  
        return  
    end  
    local pool_max_idle_time = 10000 --毫秒  
    local pool_size = 100 --连接池大小  
    local ok, err = red:set_keepalive(pool_max_idle_time, pool_size)  
    if not ok then  
        ngx.say("set keepalive error : ", err)  
    end  
end 

local function connect()
    local red = redis:new()
    red:set_timeout(1000)
    local ok, err = red:connect(redis_host, redis_port)
    if not ok then
        return false
    end
    
    return red
end

function has_token(token)
    local red = connect()
    if red == false then
        return false
    end

    local res, err = red:get(token)
    if not res then
        return false
    end
    close_redis(red)  
    return true
end

function set_permissions(user_id,permissions)
  if (permissions==null) or( permissions==ngx.null) then
     return false
  end 
  local str = cjson.encode(permissions)  
  ngx.log(ngx.ERR,"set redis p:"..str)
  local red=connect()
  if red== false then
     return false
  end
  local ok, err = red:set(user_id,str)
  if not ok then
     return false
  end
  return true 
end

function get_permissions(user_id)
  local red=connect()
  if red== false then
     return false
  end
  local res, err = red:get(user_id)
  if (not res) or (res == ngx.null) then
     return
  end 
  ngx.log(ngx.ERR,"get redis p:"..res);
  local permissions=cjson.decode(res)  
  return permissions
end

function get_user_id(token)
    local red = connect()
    local resp, err = red:get(token)  
    if not resp then  
      ngx.say("get msg error : ", err)  
      return close_redis(red)  
    end  
    close_redis(red)  
    return resp
end

