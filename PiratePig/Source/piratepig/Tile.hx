package piratepig;


import motion.easing.Quad;
import motion.Actuate;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Assets;


class Tile extends Sprite {
	
	
	public var column:Int;
	public var moving:Bool;
	public var removed:Bool;
	public var row:Int;
	public var type:Int;
	
	
	public function new (imagePath:String) {
		
		super ();
		
		var image = new Bitmap (Assets.getBitmapData (imagePath));
		image.smoothing = true;
		addChild (image);
		
		mouseChildren = false;
		buttonMode = true;
		
		graphics.beginFill (0x000000, 0);
		graphics.drawRect (-5, -5, 66, 66);
		
	}
	
	
	public function initialize ():Void {
		
		moving = false;
		removed = false;
		
		mouseEnabled = true;
		buttonMode = true;
		
		scaleX = 1;
		scaleY = 1;
		alpha = 1;
		
	}
	
	
	public function moveTo (duration:Float, targetX:Float, targetY:Float):Void {
		
		moving = true;
		
		Actuate.tween (this, duration, { x: targetX, y: targetY } ).ease (Quad.easeOut).onComplete (this_onMoveToComplete);
		
	}
	
	
	public function remove (animate:Bool = true):Void {
		
		if (!removed) {
			
			if (animate) {
				
				mouseEnabled = false;
				buttonMode = false;
				
				parent.addChildAt (this, 0);
				Actuate.tween (this, 0.6, { alpha: 0, scaleX: 2, scaleY: 2, x: x - width / 2, y: y - height / 2 } ).onComplete (this_onRemoveComplete);
				
			} else {
				
				this_onRemoveComplete ();
				
			}
			
		}
		
		removed = true;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function this_onMoveToComplete ():Void {
		
		moving = false;
		
	}
	
	
	private function this_onRemoveComplete ():Void {
		
		parent.removeChild (this);
		
	}
	
	
}