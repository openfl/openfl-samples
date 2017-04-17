package;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.Lib;
import openfl.ui.Keyboard;
import shaders.BackgroundShader;

class BitmapExample extends Sprite
{

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	function init(_) {
		
		// we create a transparent bitmap
		var bd = new BitmapData(stage.stageWidth, stage.stageHeight);
		var bmp = new Bitmap(bd);
		addChild(bmp);
		
		// and initialize our shader
		var bgShader = new BackgroundShader();
		bgShader.uZoom = 800 * bmp.scaleX;
		// silly bitmap to show how we can use BitmapDatas on our shader
		bgShader.uSampler1 = Assets.getBitmapData("assets/openfl.png");
		
		bmp.shader = bgShader;
		
		var movement = new Point();
		
		// we update its parameters each frame
		addEventListener(Event.ENTER_FRAME, function(_) {
			bgShader.uGlobalTime = Lib.getTimer() / 1000;
			bgShader.uMovement[0] += movement.x;
			bgShader.uMovement[1] += movement.y;
		});
		
		// keep the background always there when resizing the stage
		stage.addEventListener(Event.RESIZE, function(_) {
			bmp.scaleX = stage.stageWidth / bmp.bitmapData.width;
			bmp.scaleY = stage.stageHeight / bmp.bitmapData.height;
			bgShader.uZoom = 800 * bmp.scaleX;
		});
		
		// some movement logic
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.RIGHT:
					movement.x = -1;
				case Keyboard.LEFT:
					movement.x = 1;
				case Keyboard.UP:
					movement.y = -1;
				case Keyboard.DOWN:
					movement.y = 1;
			}
		});
		
		stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			switch(e.keyCode) {
				case Keyboard.RIGHT:
					movement.x = 0;
				case Keyboard.LEFT:
					movement.x = 0;
				case Keyboard.UP:
					movement.y = 0;
				case Keyboard.DOWN:
					movement.y = 0;
			}
		});
	}
	
}