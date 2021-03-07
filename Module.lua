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
