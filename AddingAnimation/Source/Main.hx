package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import motion.easing.Elastic;
import motion.Actuate;

@:bitmap("nme.png") class Image extends BitmapData {}


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var bitmap = new Bitmap (new Image (0, 0));
		bitmap.x = - bitmap.width / 2;
		bitmap.y = - bitmap.height / 2;
		bitmap.smoothing = true;
		
		var container = new Sprite ();
		container.addChild (bitmap);
		container.alpha = 0;
		container.scaleX = 0;
		container.scaleY = 0;
		container.x = stage.stageWidth / 2;
		container.y = stage.stageHeight / 2;
		
		addChild (container);
		
		Actuate.tween (container, 3, { alpha: 1 } );
		Actuate.tween (container, 4, { scaleX: 1, scaleY: 1 } ).delay (0.4).ease (Elastic.easeOut);
		
	}
	
	
}