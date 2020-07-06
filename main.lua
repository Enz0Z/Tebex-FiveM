config = {
	secret = GetConvar("sv_tebexSecret", nil),
	baseUrl = "https://plugin.tebex.io"
}

Citizen.CreateThread(function()
	if config.secret == nil then
		print("sv_tebexSecret is nil.")
		return
	else
		print("^2Authenticated with Tebex: ^7" .. config.secret)
	end
	while true do
		Citizen.Wait(30000)
		TebexApiClient.Get("/queue", function(response)
			local players = response["players"]

			if (response["meta"]["execute_offline"] == true) then
				TebexCommandRunner.doOfflineCommands()
			end
			for k, v in pairs(players) do
				local steamID, nameID = TebexApiClient.Search(v["uuid"])
				
				if steamID and nameID then
					TebexCommandRunner.doOnlineCommands(v["id"], nameID, steamID)
				end
			end
		end)
	end
end)