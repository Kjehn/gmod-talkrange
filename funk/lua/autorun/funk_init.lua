if SERVER then
    AddCSLuaFile("funk/client/cl_funk.lua")
    AddCSLuaFile("funk/config.lua")
    AddCSLuaFile("funk/sh_funk.lua")
    include("funk/config.lua")
    include("funk/sh_funk.lua")
    include("funk/server/sv_funk.lua")
else
    include("funk/config.lua")
    include("funk/sh_funk.lua")
    include("funk/client/cl_funk.lua")
end