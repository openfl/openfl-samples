package;


import flash.events.Event;
#if !html5
import flash.system.Capabilities;
#end
import flash.Lib;


class Env {
	
	
	public static var screenDensity (default, null):Float;
	public static var width (default, null):Int;
	public static var height (default, null):Int;
	
	
	public static function setup ():Void {
		
		#if html5
		screenDensity = 1;
		#else
		
		var dpi = Capabilities.screenDPI;
		
		if (dpi < 200) {
			
			screenDensity = 1;
			
		} else if (dpi < 300) {
			
			screenDensity = 1.5;
			
		} else {
			
			screenDensity = 2;
			
		}
		
		#end
		
		stage_onResize (null);
		Lib.current.stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private static function stage_onResize (event:Event):Void {
		
		width = Math.ceil (Lib.current.stage.stageWidth / screenDensity);
		height = Math.ceil (Lib.current.stage.stageHeight / screenDensity);
		
	}
	
	
}