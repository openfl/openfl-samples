package;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import motion.Actuate;
import openfl.Assets;

class Main extends Sprite {
	private var logo:Sprite;
	private var destination:Sprite;

	private var cacheOffsetX:Float;
	private var cacheOffsetY:Float;

	public function new () {
		super ();

		logo = new Sprite ();
		logo.addChild (new Bitmap (Assets.getBitmapData ("assets/openfl.png")));
		logo.x = 100;
		logo.y = 100;
		logo.buttonMode = true;

		destination = new Sprite ();
		destination.graphics.beginFill (0xF5F5F5);
		destination.graphics.lineStyle (1, 0xCCCCCC);
		destination.graphics.drawRect (0, 0, logo.width + 10, logo.height + 10);
		destination.x = 300;
		destination.y = 95;

		addChild (destination);
		addChild (logo);

		logo.addEventListener (MouseEvent.MOUSE_DOWN, logo_onMouseDown);
	}

// Event Handlers

	private function logo_onMouseDown (event:MouseEvent):Void {
		cacheOffsetX = logo.x - event.stageX;
		cacheOffsetY = logo.y - event.stageY;

		stage.addEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
	}

	private function stage_onMouseMove (event:MouseEvent):Void {
		logo.x = event.stageX + cacheOffsetX;
		logo.y = event.stageY + cacheOffsetY;
	}

	private function stage_onMouseUp (event:MouseEvent):Void {
		if (destination.hitTestPoint (event.stageX, event.stageY)) {
			Actuate.tween (logo, 1, { x: destination.x + 5, y: destination.y + 5 });
		}

		stage.removeEventListener (MouseEvent.MOUSE_MOVE, stage_onMouseMove);
		stage.removeEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
	}
}
