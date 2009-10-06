--[[
rem 26-Oct-2008 by msl
@title My Shutter
]]

function wait()
  repeat
    wait_click(80)
    if is_pressed "remote" then
      return true
    end
  until false
end

function shoot()
  print "Shooting..."
  press "shoot_full"
  release "shoot_full"
  release "shoot_half"
  repeat
		sleep(50)
	until get_shooting() == false
end

repeat
  wait()
  shoot()
until false