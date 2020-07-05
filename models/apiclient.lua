TebexApiClient = {}

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