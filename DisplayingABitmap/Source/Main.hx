package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

@:bitmap("nme.png") class Image extends BitmapData {}


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var bitmap = new Bitmap (new Image (0, 0));
		addChild (bitmap);
		
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;
		
	}
	
	
}