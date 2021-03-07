--[[
  _      _             _     _   _____ _          _ 
 | |    (_)           (_)   | | |  __ (_)        | |
 | |     _  __ _ _   _ _  __| | | |__) |__  _____| |
 | |    | |/ _` | | | | |/ _` | |  ___/ \ \/ / _ \ |
 | |____| | (_| | |_| | | (_| | | |   | |>  <  __/ |
 |______|_|\__, |\__,_|_|\__,_| |_|   |_/_/\_\___|_|
              | |                                   
              |_|     
  _____       _                      _   _           
 |_   _|     | |                    | | (_)          
   | |  _ __ | |_ ___ _ __ __ _  ___| |_ ___   _____ 
   | | | '_ \| __/ _ \ '__/ _` |/ __| __| \ \ / / _ \
  _| |_| | | | ||  __/ | | (_| | (__| |_| |\ V /  __/
 |_____|_| |_|\__\___|_|  \__,_|\___|\__|_| \_/ \___|
                                                     
Created by luketeam5, Github: https://github.com/luketeam5/Roblox-Server-System

Licensed under:       
MIT License

Copyright © 2021 LiquidPixel Interactive

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.                       
--]]

-- ** Getting services 
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

--[[ 
List of functions:
 [1] Server creating
 [2] Getting server data
 [3] Getting custom data
--]]

local ServerSystem = {}


--[[
[1] Server creating
Creates new server
--]]
function ServerSystem.Create(name, description, ownerid, maxslots, placeID, password, CustomData) -- Creating new server, make sure this is not spamable, provide your own cooldown!!!
	local ServerStats = DataStoreService:GetDataStore("ServerSystem_ServerSTATS") -- Connects to global data datastore (Stores server number of servers and other cool stuff)
	local success, ServerNumber = pcall(function() -- Soo everything doesn't error when datastore stops working.
		return ServerStats:GetAsync("ServerNumber")
	end)
	if success then -- Checks if getting data was succesfull
		if ServerNumber == nil then -- This means the Module is being used first time in the universe, to stop errors we change nil to 0
			ServerNumber = 0
		end
		ServerNumber += 1 -- Add +1 to server number
		local success2 = pcall(function()
			return ServerStats:SetAsync("ServerNumber", ServerNumber) -- Updates ServerStats, with our +1 server number
		end)
	end
	local NewServerDatastore = DataStoreService:GetDataStore("ServerSystem_Server_"..ServerNumber) -- Connects to our new datastore using our ServerNumber (SID)
	local OfficialInfo = { -- Information needed for the servers to work, don't mess with this.
		Active = false, -- To tell people if server if active, if so change this with server access code.
		ServerID = SID,
		PlaceId = placeID,
		Password = password,
		Name = name,
		Description = description,
		MOTD = "Default game server created by ServerSystem",
		Owner = ownerid,
		MaxPlayers = maxslots, 
		CurrectPlayers = 0,
		Created = os.time(),
		ServerVersion = 1 -- If some of the core function changes (adding more to dictionaries etc... this will help me make AutoUpdate script to update the servers data)
	}
	-- Now let's upload information about our server creation to our new datastore
	local success, err = pcall(function()
		NewServerDatastore:SetAsync("ServerData", OfficialInfo) -- Creates new info in datastore, you can access this by using name "ServerSystem_Server_<SID>" and key "ServerData" in datastore editor.
	end)
	local success, err = pcall(function()
		NewServerDatastore:SetAsync("CustomData", CustomData) -- Custom boolean/table/dictionary from input, you can store whatever you like here, you can access this by using name "ServerSystem_Server_<SID>" and key "CustomData" in datastore editor.
	end)
	return ServerNumber
end

--[[
[2] Getting server data
--]]
function ServerSystem.GetServerData(SID)
	local ServerDatastore = DataStoreService:GetDataStore("ServerSystem_Server_"..SID) -- Connects to datastore using SID provided by server
	local success, Data = pcall(function()
		return ServerDatastore:GetAsync("ServerData")
	end)
	if success then
		return Data -- Returns data
	end
end

--[[
[3] Getting custom data
--]]
function ServerSystem.GetCustomData(SID)
	local ServerDatastore = DataStoreService:GetDataStore("ServerSystem_Server_"..SID) -- Connects to datastore using SID provided by server
	local success, Data = pcall(function()
		return ServerDatastore:GetAsync("CustomData")
	end)
	if success then
		return Data -- Returns custom data
	end
end

return ServerSystem
