--This a 3DsMax script, This script assumes that there is an object in the scene called WheeledRobot.
rollout serial_rollout ""
(
    --The serial port object needs a string of the name of the port the Arduino is connected to.
    --In this case, it is COM3, with a baud rate of 9600.
    local cereal = dotNetObject "System.IO.Ports.SerialPort" "COM3" 9600
    local cube = $WheeledRobot    --Robot name on 3DsMax
    local contacted = false

    --Simple GUI for shuting down simulation
    checkbutton on_button "OFF" width:60        --Creating a button
    label info_label "Ready." align:#left       --Creating a label
    timer serial_timer interval:1 active:false 	--The timer is set to an interval of one millisecond.
                                                --On each tick, the port is read and the byte
                                                --is processed.
    
    on on_button changed arg do
    (
        if arg then
        (
            --If the check button is checked, open the serial port and
            --activate the timer.
            cereal.Open()
            serial_timer.active = true
            --UI stuff (optional)
            on_button.text = "ON"
            info_label.text = "Listening..."
        ) else(
            serial_timer.active = false
            cereal.Close()
            contacted = false
            --UI stuff (optional)
            on_button.text = "OFF"
            info_label.text = "Ready."
        )
    )--end on on_button changed

    --Reading the sent bytes from arduino
   on serial_timer tick do
    (
	         in_bytee = filterstring (cereal.ReadLine()) "," --Recgonize and split the sent bytes with ',' mark
	         bytex = execute in_bytee[1] as integer   --Reading the first part before ',' mark this is X
		     bytey = execute in_bytee[2] as integer   --Reading the second part after ',' mark this is Y
		     cBomb = execute in_bytee[3] as integer   --Reading the third part after the second ',' mark this is the metal detector
            
             --Moving the robot with the read X, Y values mulitplyed with a factor
             cube.pos.x = bytex * 0.25
             cube.pos.y = bytey * 0.25
             --Add a bomb in postion each time the metal detector gives 1 / HIGH
		     if cBomb > 0 then (
				--mybomb = box length:5 width:5 height:5
				mybomb = sphere radius:5
				mybomb.pos.x = bytex * 0.25
			    mybomb.pos.y = bytey * 0.25
			)
             --cube.rotation.z_rotation = bytey * 0.25 -- use this for rotation if you need it

             info_label.text = ("Connected @ X: "+ (bytex as string) +" Y: "+ (bytey as string))		
	)
    
)--end rollout
createdialog serial_rollout

--Written by Mohamed Abdo 2-6-2014