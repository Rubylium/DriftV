$(function() {
	
	var s_playerID;
	var s_rpm;
	var s_speed;
	var s_gear;
	var s_IL;
	var s_Handbrake;
	var s_LS_r;
	var s_LS_o;
	var s_LS_h;
	var calcSpeed;
	var speedText = '';
	var inVehicle = false;
	
    window.addEventListener("message", function(event) {
        var item = event.data;
        
        if (item.ShowHud) {
			
			inVehicle   = true;
			s_PlayerID  = item.PlayerID;
			s_Rpm       = item.CurrentCarRPM;
			s_Speed     = item.CurrentCarSpeed;
			s_Kmh       = item.CurrentCarKmh;
			s_Mph       = item.CurrentCarMph;
			s_Gear      = item.CurrentCarGear;
			s_IL        = item.CurrentCarIL;
			s_Handbrake = item.CurrentCarHandbrake;
			s_Brake     = item.CurrentCarBrake;
			s_LS_r      = item.CurrentCarLS_r;
			s_LS_o      = item.CurrentCarLS_o;
			s_LS_h      = item.CurrentCarLS_h;
			CalcSpeed   = s_Kmh;
			CalcRpm     = (s_Rpm * 9);
			
			if(CalcSpeed > 999) {
				CalcSpeed = 999;
			}
			
			// Vehicle RPM display
			$("#rpmshow").attr("data-value", CalcRpm.toFixed(2));
			
			// Vehicle Gear display
			if(s_Gear == 0) {
				$(".geardisplay span").html("R");
				$(".geardisplay").attr("style", "color: #FFF;border-color:#FFF;");
			} else {
				$(".geardisplay span").html(s_Gear);
				if(CalcRpm > 7.5) {
					$(".geardisplay").attr("style", "color: rgb(235,30,76);border-color:rgb(235,30,76);");
				} else {
					$(".geardisplay").removeAttr("style");
				}
			}
			
			// Vehicle speed display
			if(CalcSpeed >= 100) {
				var tmpSpeed = Math.floor(CalcSpeed) + '';
				speedText = '<span class="int1">' + tmpSpeed.substr(0, 1) + '</span><span class="int2">' + tmpSpeed.substr(1, 1) + '</span><span class="int3">' + tmpSpeed.substr(2, 1) + '</span>';
			} else if(CalcSpeed >= 10 && CalcSpeed < 100) {
				var tmpSpeed = Math.floor(CalcSpeed) + '';
				speedText = '<span class="gray int1">0</span><span class="int2">' + tmpSpeed.substr(0, 1) + '</span><span class="int3">' + tmpSpeed.substr(1, 1) + '</span>';
			} else if(CalcSpeed > 0 && CalcSpeed < 10) {
				speedText = '<span class="gray int1">0</span><span class="gray int2">0</span><span class="int3">' + Math.floor(CalcSpeed) + '</span>';
			} else {
				speedText = '<span class="gray int1">0</span><span class="gray int2">0</span><span class="gray int3">0</span>';
			}
			
			// Handbrake
			if(s_Handbrake) {
				$(".handbrake").html("HBK");
			} else {
				$(".handbrake").html('<span class="gray">HBK</span>');
			}
			
			// Brake ABS
			if(s_Brake > 0) {
				$(".abs").html("ABS");
			} else {
				$(".abs").html('<span class="gray">ABS</span>');
			}
			
			// Display speed and container
			$(".speeddisplay").html(speedText);
			$("#container").fadeIn(500);
			
        } else if (item.HideHud) {
			
			// Hide GUI
			$("#container").fadeOut(500);
			inVehicle = false;
        }
    });
});
