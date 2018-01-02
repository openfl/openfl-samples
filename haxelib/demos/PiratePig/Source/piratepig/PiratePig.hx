package piratepig;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.system.Capabilities;
import openfl.Assets;
import openfl.Lib;


class PiratePig extends Sprite {
	
	
	private var Background:Bitmap;
	private var Footer:Bitmap;
	private var Game:PiratePigGame; 
	
	
	public function new () {
		
		super ();
		
		initialize ();
		construct ();
		
		resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
	}
	
	
	private function construct ():Void {
		
		Footer.smoothing = true;
		
		addChild (Background);
		addChild (Footer);
		addChild (Game);
		
	}
	
	
	private function initialize ():Void {
		
		Background = new Bitmap (Assets.getBitmapData ("images/background_tile.png"));
		Footer = new Bitmap (Assets.getBitmapData ("images/center_bottom.png"));
		Game = new PiratePigGame ();
		
	}
	
	
	private function resize (newWidth:Int, newHeight:Int):Void {
		
		Background.width = newWidth;
		Background.height = newHeight;
		
		Game.resize (newWidth, newHeight);
		
		Footer.scaleX = Game.currentScale;
		Footer.scaleY = Game.currentScale;
		Footer.x = newWidth / 2 - Footer.width / 2;
		Footer.y = newHeight - Footer.height;
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		resize (stage.stageWidth, stage.stageHeight);
		
	}
	
	
}
