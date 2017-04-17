package;
import openfl._legacy.display.BitmapData;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.Shader;
import openfl.events.KeyboardEvent;
import openfl.filters.BlurFilter;
import shaders.DotShader;
import shaders.RGBShiftShader;


class SpriteExample extends Sprite {

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(_) {
		
		// we initialize stuff
		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		var left = new Sprite();
		var right = new Sprite();
		addChild(left);
		addChild(right);
		
		left.addChild(new Bitmap(bitmapData));
		right.addChild(new Bitmap(bitmapData));
		
		left.y = right.y = stage.stageHeight / 2 - bitmapData.height / 2;
		right.x = left.x + left.width;
		
		var rgbShader = new RGBShiftShader();
		var dotShader = new DotShader();
		
		// The rgbShader will be applied to all the children of this sprite
		this.shader = rgbShader;
		
		// but "right" will have a dotShader, so it won't have applied the rgbShader
		right.shader = dotShader;
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(_) {
			// unless its parent, this sprite, is cached as a bitmap
			this.cacheAsBitmap = !this.cacheAsBitmap;
		});
		
	}
	
}