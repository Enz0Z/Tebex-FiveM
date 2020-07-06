TebexCommandRunner = {}
local maxCommands = 3

local buildCommand = function(cmd, username, id)
	cmd = cmd:gsub("{id}", id)
	cmd = cmd:gsub("{hexid}", id)
	cmd = cmd:gsub("{username}", username)

	return cmd .. "\n"
end

TebexCommandRunner.doOfflineCommands = function()
	TebexApiClient.Get("/queue/offline-commands", function(response)
		local commands = response.commands
		local exCount = 0
		local executedCommands = {}

		for key, cmd in pairs(commands) do
			local commandToRun = buildCommand(cmd["command"], cmd["player"]["name"], cmd["player"]["uuid"])
			exCount = exCount + 1

			ExecuteCommand(commandToRun)
			table.insert(executedCommands, cmd["id"])
			if exCount % maxCommands == 0 then
				TebexCommandRunner.deleteCommands(executedCommands)
				executedCommands = {}
			end
		end
		if exCount % maxCommands > 0 then
			TebexCommandRunner.deleteCommands(executedCommands)
			executedCommands = {}
		end
	end, function(body)
		print(body["error_code"] .. " " .. body["error_message"])
	end)
end

TebexCommandRunner.doOnlineCommands = function(playerPluginId, playerName, playerId)
    TebexApiClient.Get("/queue/online-commands/" .. playerPluginId, function(response)
		local commands = response.commands
		local exCount = 0
		local executedCommands = {}

		for key, cmd in pairs(commands) do
			local commandToRun = buildCommand(cmd["command"], playerName, playerId)
			exCount = exCount + 1

			ExecuteCommand(commandToRun)
			table.insert(executedCommands, cmd["id"])
			if exCount % maxCommands == 0 then
				TebexCommandRunner.deleteCommands(executedCommands)
				executedCommands = {}
			end
		end
		if exCount % maxCommands > 0 then
			TebexCommandRunner.deleteCommands(executedCommands)
			executedCommands = {}
		end
    end, function(body)
        print(body["error_code"] .. " " .. body["error_message"])
    end)
    apiclient = nil
end

TebexCommandRunner.deleteCommands = function(commandIds)
	local endpoint = "/queue?"
	local amp = ""

	for key, commandId in pairs(commandIds) do
		endpoint = endpoint .. amp .. "ids[]=" .. commandId
		amp = "&"
	end
	TebexApiClient.Delete(endpoint, function(response)
		-- SUCCESS
	end, function(body)
		print(body["error_code"] .. " " .. body["error_message"])
	end)
end