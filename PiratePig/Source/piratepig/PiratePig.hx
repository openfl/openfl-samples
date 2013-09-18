package piratepig;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import openfl.Assets;

class PiratePig extends Sprite {
	private var background:Bitmap;
	private var footer:Bitmap;
	private var game:PiratePigGame;

	public function new () {
		super ();

		initialize ();
		construct ();

		resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, stage_onResize);
	}

	private function construct ():Void {
		footer.smoothing = true;

		addChild (background);
		addChild (footer);
		addChild (game);
	}

	private function initialize ():Void {
		background = new Bitmap (Assets.getBitmapData ("images/background_tile.png"));
		footer = new Bitmap (Assets.getBitmapData ("images/center_bottom.png"));
		game = new PiratePigGame ();
	}

	private function resize (newWidth:Int, newHeight:Int):Void {
		background.width = newWidth;
		background.height = newHeight;

		game.resize (newWidth, newHeight);

		footer.scaleX = game.currentScale;
		footer.scaleY = game.currentScale;
		footer.x = newWidth / 2 - footer.width / 2;
		footer.y = newHeight - footer.height;
	}

	private function stage_onResize (event:Event):Void {
		resize (stage.stageWidth, stage.stageHeight);
	}
}
