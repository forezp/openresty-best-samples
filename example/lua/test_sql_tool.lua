local mysqltool = require "mysqltool"
local permissions= mysqltool.select_user_permission("1")
ngx.log(ngx.ERR,table.concat(permissions))
ngx.say(table.concat(permissions))
