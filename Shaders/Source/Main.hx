package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import openfl.Lib;
import flash.net.SharedObject;

class Main extends Sprite {
	
	public function new() {
		super();
		//addChild(new BitmapExample());
		//addChild(new SpriteExample());
		//addChild(new FilterExample());
		addChild(new TilesheetExample());
		
	}

}