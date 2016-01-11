print("\n")
print("ESP8266 Init Started")

local serverFiles = {'main.lua', 'webserver.lua'}

-- Compile server code and remove original .lua files.
-- This only happens the first time afer the .lua files are uploaded.

local compileAndRemoveIfNeeded = function(f)
   if file.open(f) then
      file.close()
      print('Compiling:', f)
      node.compile(f)
      file.remove(f)
      collectgarbage()
   end
end

for i, f in ipairs(serverFiles) do compileAndRemoveIfNeeded(f) end
 
if file.open("main.lc") then
    dofile("main.lc")
else
    print("main.lc not exist")
end
exefile=nil;luaFile = nil
collectgarbage()
