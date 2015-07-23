package;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Sprite;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.Assets;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		var image = Assets.getBitmapData ("assets/openfl.png");
		
		var bitmap = new Bitmap (image);
		bitmap.x = 20;
		bitmap.y = 20;
		addChild (bitmap);
		
		var bitmap = new Bitmap (image);
		bitmap.x = 130;
		bitmap.y = 120;
		bitmap.rotation = -90;
		addChild (bitmap);
		
		var bitmapData = image.clone ();
		bitmapData.colorTransform (bitmapData.rect, new ColorTransform (0.5, 0, 1, 0.5, 20, 0, 0, 0));
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 240;
		bitmap.y = 20;
		addChild (bitmap);
		
		var bitmapData = new BitmapData (image.width, image.height);
		bitmapData.copyPixels (image, image.rect, new Point (-image.width / 2, -image.height / 2));
		bitmapData.copyPixels (image, image.rect, new Point (-image.width / 2, image.height / 2));
		bitmapData.copyPixels (image, image.rect, new Point (image.width / 2, -image.height / 2));
		bitmapData.copyPixels (image, image.rect, new Point (image.width / 2, image.height / 2));
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 350;
		bitmap.y = 20;
		addChild (bitmap);
		
		var bitmapData = new BitmapData (image.width, image.height, true, 0xFFEEEEEE);
		bitmapData.copyPixels (image, image.rect, new Point (), null, null, true);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 460;
		bitmap.y = 20;
		addChild (bitmap);
		
		var bitmapData = image.clone ();
		bitmapData.copyChannel (image, image.rect, new Point (20, 0), BitmapDataChannel.BLUE, BitmapDataChannel.GREEN);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 570;
		bitmap.y = 20;
		addChild (bitmap);
		
		var bitmapData = image.clone ();
		bitmapData.floodFill (0, 0, 0xFFEEEEEE);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 20;
		bitmap.y = 140;
		addChild (bitmap);
		
		var sprite = new Sprite ();
		var bitmap = new Bitmap (image);
		bitmap.scaleX = 2;
		bitmap.alpha = 0.4;
		sprite.addChild (bitmap);
		
		var bitmapData = new BitmapData (image.width, image.height);
		bitmapData.draw (sprite);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 130;
		bitmap.y = 140;
		addChild (bitmap);
		
		var bitmapData = image.clone ();
		bitmapData.scroll (Std.int (image.width / 2), 0);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 240;
		bitmap.y = 140;
		addChild (bitmap);
		
		var bitmapData = image.clone ();
		bitmapData.threshold (image, image.rect, new Point (40, 0), ">", 0x33000000, 0x88333333, 0xFF000000);
		var bitmap = new Bitmap (bitmapData);
		bitmap.x = 350;
		bitmap.y = 140;
		addChild (bitmap);
		
	}
	
	
}
