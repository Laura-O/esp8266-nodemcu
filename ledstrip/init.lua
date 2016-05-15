stripPin = 2   -- Comment: GPIO5  
g = 0  
r = 255  
b = 0  
String = string.char(r, g, b)

--function loop()
  --chase(strip.Color(255, 0, 0)); // Red
  --chase(strip.Color(0, 255, 0)); // Green
  --chase(strip.Color(0, 0, 255)); // Blue
--end


ws2812.writergb(4, string.char(0, 0, 0):rep(30))

function chain()
    for pixel = 1, 30, 1 do
        ws2812.writergb(4, string.char(0,0,0):rep(pixel-1)..string.char(0, 0, 255)..string.char(0, 0, 0):rep(30-pixel))
        tmr.delay(10000)
    end
end


chain()
