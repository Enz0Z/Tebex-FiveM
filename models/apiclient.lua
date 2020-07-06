TebexApiClient = {}

local GetIdentifiers = function(source)
	local steamID = "no info"
	local fivem = "no info"
	local name = GetPlayerName(source)

	if name then
		for k, v in ipairs(GetPlayerIdentifiers(source)) do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamID = v
			elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
				fivem = v
			end
		end
		return steamID, fivem, name
	else
		return nil, nil, nil
	end
end

TebexApiClient.Get = function(endpoint, success, failure)
	PerformHttpRequest(config.baseUrl .. endpoint, function(code, body, headers)
		if (body == nil) then
			print("There was a problem sending this request. Please try again " .. code)
			return
		end
		tBody = json.decode(body)

		if (code == 200 or code == 204) then
			success(tBody)
			return
		end
		failure(tBody)
	end, 'GET', '', {
		['X-Buycraft-Secret'] = config.secret
	})
end

TebexApiClient.Delete = function(endpoint, success, failure)
	PerformHttpRequest(config.baseUrl .. endpoint, function(code, body, headers)
		if (body == nil) then
			print("There was a problem sending this request. Please try again")
			return
		end
		tBody = json.decode(body)

		if (code == 200 or code == 204) then
			success(tBody)
			return
		end
		failure(tBody)
	end, 'DELETE', '', {
		['X-Buycraft-Secret'] = config.secret
	})
end

TebexApiClient.Search = function(fivem)
	for _, server_id in ipairs(GetPlayers()) do
		local steamID, fivemID, nameID = GetIdentifiers(server_id)

		if (steamID and fivemID and nameID) and fivemID == "fivem:" .. fivem then
			return steamID, nameID
		end
	end
end