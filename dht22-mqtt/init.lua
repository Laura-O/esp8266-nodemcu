-- ESP8266: Log DHT22 temperature data with MQTT

--- MQTT server ---
mqtt_broker_ip = "BROKER IP"
mqtt_broker_port = 1883
mqtt_username = ""
mqtt_password = ""
mqtt_client_id = ""

--- WIFI ---
wifi_SSID = "SSID"
wifi_password = "password"
-- static IP
client_ip="192.168.0.100"
client_netmask="255.255.255.0"
client_gateway="192.168.0.1"

-- Setup MQTT client and events
m = mqtt.Client(client_id, 120)

-- WIFI connection
wifi.setmode(wifi.STATION)
wifi.sta.config(wifi_SSID, wifi_password)
wifi.sta.connect()
wifi.sta.setip({ip=client_ip,netmask=client_netmask,gateway=client_gateway})

-- get DHT22 sensor data
function get_sensor_Data()
    dht=require("dht")
    status, temp, humi, temp_dec, humi_dec = dht.read(4)
    print(temp, temp_dec)
        if( status == dht.OK ) then
            print("Temperature: "..temp.." deg C")
            print("Humidity: "..humi.."%")
        elseif( status == dht.ERROR_CHECKSUM ) then
            print( "DHT Checksum error" )
        elseif( status == dht.ERROR_TIMEOUT ) then
            print( "DHT Time out" )
        end
    -- Release module
    dht=nil
    package.loaded["dht"]=nil
end

-- publish data
function loop()
    if wifi.sta.status() == 5 then
        print("Ready!")
        -- Stop the loop
        tmr.stop(0)
            m:connect( mqtt_broker_ip , mqtt_broker_port, 0, function(conn)
            print("Connected to MQTT")
            print("  IP: ".. mqtt_broker_ip)
            print("  Port: ".. mqtt_broker_port)
            get_sensor_Data()
            m:publish("temp",temp, 0, 0, function(conn)
            m:publish("humi",humi, 0, 0, function(conn)
            m:close()
                end)
            end)
        end)
    else
        print("Connecting...")
    end
end

tmr.alarm(1, 6000, 1, function() loop() end)
