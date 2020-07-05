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
			if (response["meta"]["execute_offline"] == true) then
				TebexCommandRunner.doOfflineCommands()
			end
		end)
	end
end)