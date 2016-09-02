using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Activity as ac;
using Toybox.ActivityMonitor as Act;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;

class drs_blueView extends Ui.WatchFace {

	var GRT;
    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        GRT = Ui.loadResource(Rez.Drawables.id_drs_blue);
      
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

   //! Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = Sys.getClockTime();
        
        var moment = Time.now();
        var info = Gregorian.info(moment, Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$ $3$ $4$", [info.day_of_week, info.day, info.month, info.year]);
        
        
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        //view.setText(timeString);
		
		var activityInfo;
		activityInfo = Act.getInfo();
		
		
        // Call the parent onUpdate function to redraw the layout
        
        
        var dayInfo = ac.getActivityInfo();
                 
        
        //var goal = currentInfo.History.stepGoal;
        
        // Draw the background
        
        View.onUpdate(dc);
        var bgX = ((dc.getWidth() - 218) / 2) + 5;
        var bgY = ((dc.getHeight() - 218) / 2 - 1);
        
        dc.drawBitmap(bgX+30, bgY+70, GRT);
        
        
        //draw date string
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(bgX+102, bgY+60, Gfx.FONT_TINY, dateString, Gfx.TEXT_JUSTIFY_CENTER);
        // draw time string
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(bgX + 102, bgY+7, Gfx.FONT_NUMBER_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
	        
      //draw calories
		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(bgX +20, bgY+155, Gfx.FONT_XTINY, activityInfo.calories + "kCals", Gfx.TEXT_JUSTIFY_LEFT);
        //draw steps
        dc.drawText(bgX +180, bgY+155, Gfx.FONT_XTINY, activityInfo.steps +"/"+activityInfo.stepGoal, Gfx.TEXT_JUSTIFY_RIGHT);
                
    	  // Draw the battery indicator
    	var timeHeight = dc.getFontHeight(Gfx.FONT_NUMBER_HOT);
        var dateHeight = dc.getFontHeight(Gfx.FONT_SMALL);
        var batteryIndicatorHeight = 10;
        var totalHeight = timeHeight + dateHeight + batteryIndicatorHeight;
        var timeY = (dc.getHeight() / 2) - (totalHeight / 2) - 5;
        var batteryIndicatorY = timeY + timeHeight+75;
        var dateY = batteryIndicatorY + batteryIndicatorHeight;
        drawBatteryIndicator(dc, batteryIndicatorY);    
        
       dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
       dc.drawText(bgX+103, bgY + 170, Gfx.FONT_XTINY, "Dead Rabbit Society", Gfx.TEXT_JUSTIFY_CENTER);
    }

    
    //
    //
     function drawBatteryIndicator(dc, batteryIndicatorY) {
        // Draw the battery life
        var stats = Sys.getSystemStats();
        var percent = stats.battery;
        
        var remainingString = Lang.format("$1$%", [percent.format("%d")]);
        
        var batteryIndicatorStartX = dc.getWidth() / 2;
        var blockSpace = 2;
        var blockWidth = 6;
        var blockHeight = 6;
        
        var numBlocks = 10;
        
        var batteryIndicatorWidth = (numBlocks * blockWidth) + ((numBlocks-1) * blockSpace);
        var batteryIndicatorX = (dc.getWidth() / 2) - (batteryIndicatorWidth / 2);
        
        if(percent >= 51){
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        } else if (percent <= 50 and percent >= 25){
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        } else {
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        }
        dc.drawText(batteryIndicatorX+90, batteryIndicatorY-20, Gfx.FONT_XTINY, "Bat:"+ remainingString, Gfx.TEXT_JUSTIFY_RIGHT);
        
        var activityInfo;
		activityInfo = Act.getInfo();
		
		var HRH=Act.getHeartRateHistory(1, true);
		
		var hr = HRH.getMax();
		
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(batteryIndicatorX-15, batteryIndicatorY-20, Gfx.FONT_XTINY, "HR:"+ hr, Gfx.TEXT_JUSTIFY_LEFT);
    }
    //
    
    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
