--Proto 
--Created @ 2016-01-08 by Yann Vasseur
--Site:  http://reactor.fr
--For ESP12E Dev kit

-- Config
local modeStation = true;
local SSID = "Livebox-AC8E"
local WIFIKEY = "your key here"
local pinOnboardLed1 = 0;
local pinOnboardLed2 = 4;


-- ****************
-- * MAIN PROGRAM *
-- ****************
print("******** Main - Proto 2 ********")

--Init
w = loadfile("webserver.lc")
w()

start_init = function()  
gpio.mode(pinOnboardLed1, gpio.OUTPUT);  
gpio.mode(pinOnboardLed2, gpio.OUTPUT);
gpio.write(pinOnboardLed1,gpio.LOW);  
gpio.write(pinOnboardLed2,gpio.LOW);  
D1_state=1;
D0_state=1;
end

function dojob()
	print('Server On')		
	httpserver()	
end


if modeStation then
	--**** MODE CLIENT Connexion to my live box
	wifi.setmode(wifi.STATION)
	wifi.sta.config(SSID, WIFIKEY)

	-- Connect to the WiFi access point.
	-- Once the device is connected, you may start the HTTP server.

	if (wifi.getmode() == wifi.STATION) or (wifi.getmode() == wifi.STATIONAP) then
		local joinCounter = 1
		local joinMaxAttempts = 5
		tmr.alarm(0, 3000, 1, function()
			print('Connecting to WiFi Access Point, Attempt ' .. joinCounter .. ' over ' .. joinMaxAttempts)
			local ip = wifi.sta.getip()	
			if ip == nil and joinCounter < joinMaxAttempts then		  
				joinCounter = joinCounter +1
			else
				if joinCounter == joinMaxAttempts then
					print('Failed to connect to WiFi Access Point.')
					PinOn(2)
				else
					print('IP: ',ip)
					dojob()
				end			
				tmr.stop(0)
				joinCounter = nil
				joinMaxAttempts = nil
				collectgarbage()
			end
		end)
	end
else
	--**** MODE AP
	wifi.setmode(wifi.SOFTAP) 
	local cfg={}
	cfg.ssid="DoitWiFi";
	cfg.pwd="12345678"
	wifi.ap.config(cfg)

	cfg={}
	cfg.ip="192.168.2.111"
	cfg.netmask="255.255.255.0"
	cfg.gateway="192.168.2.1"
	wifi.ap.setip(cfg)

	dojob()
end
