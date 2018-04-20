package;


import openfl.display.Tile;
import openfl.Lib;


class AnimatedTile extends Tile {
	
	
	private var frameDuration:Int;
	private var frames:Array<Int>;
	private var loopDuration:Int;
	private var startTime:Int;
	
	
	public function new (frames:Array<Int>, frameRate:Float = 7.5) {
		
		super ();
		
		this.frames = frames;
		
		if (frames != null && frames.length > 0) {
			
			id = frames[0];
			
			startTime = Lib.getTimer ();
			
			loopDuration = Std.int ((frames.length / frameRate) * 1000);
			frameDuration = Math.round (loopDuration / frames.length);
			
		}
		
	}
	
	
	public function update ():Void {
		
		if (frames != null && frames.length > 0) {
			
			var currentTime = Lib.getTimer ();
			var timeElapsed = currentTime - startTime;
			
			var totalDuration = timeElapsed % loopDuration;
			var frameCount = Math.round (totalDuration / frameDuration);
			var frameIndex = frameCount % frames.length;
			
			id = frames[frameIndex];
			
		}
		
	}
	
	
}