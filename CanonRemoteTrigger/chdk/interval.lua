--[[
@title My Intervalometer
@param a Shooting interval, min
@default a 0
@param b ...sec
@default b 3
--]]
 
interval = a * 60000 + b * 1000
 
function TakePicture()
  print "Taking picture"
  press "shoot_half"
  press "shoot_full"
  release "shoot_full"
  
  sleep(500)
  print "Done waiting"
end
 
repeat
  start_tick = get_tick_count()
  TakePicture()
  print "Sleeping"
  sleep(interval - (get_tick_count() - start_tick))
  print "Looping"
until false
