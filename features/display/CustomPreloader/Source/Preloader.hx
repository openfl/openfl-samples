package;


import haxe.Timer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;


class Preloader extends Sprite {
	
	
	public function new () {
		
		super ();
		
		addEventListener (Event.COMPLETE, this_onComplete);
		addEventListener (ProgressEvent.PROGRESS, this_onProgress);
		
	}
	
	
	private function update (percent:Float):Void {
		
		graphics.clear ();
		graphics.beginFill (0x1F9DB2);
		graphics.drawRect (0, 0, stage.stageWidth * percent, stage.stageHeight);
		
	}
	
	
	private function this_onComplete (event:Event):Void {
		
		update (1);
		
		// optional
		
		event.preventDefault ();
		
		Timer.delay (function () {
			
			dispatchEvent (new Event (Event.UNLOAD));
			
		}, 2000);
		
	}
	
	
	private function this_onProgress (event:ProgressEvent):Void {
		
		if (event.bytesTotal <= 0) {
			
			update (0);
			
		} else {
			
			update (event.bytesLoaded / event.bytesTotal);
			
		}
		
	}
	
	
}