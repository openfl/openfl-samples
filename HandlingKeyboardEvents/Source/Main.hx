package;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import openfl.Assets;

class Main extends Sprite {
	private var logo:Sprite;

	private var movingDown:Bool;
	private var movingLeft:Bool;
	private var movingRight:Bool;
	private var movingUp:Bool;

	public function new () {
		super ();

		logo = new Sprite ();
		logo.addChild (new Bitmap (Assets.getBitmapData ("assets/openfl.png")));
		logo.x = 100;
		logo.y = 100;
		logo.buttonMode = true;
		addChild (logo);

		stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
		stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
		stage.addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
	}

// Event Handlers

	private function stage_onKeyDown (event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.DOWN: movingDown = true;
			case Keyboard.LEFT: movingLeft = true;
			case Keyboard.RIGHT: movingRight = true;
			case Keyboard.UP: movingUp = true;
		}
	}

	private function stage_onKeyUp (event:KeyboardEvent):Void {
		switch (event.keyCode) {
			case Keyboard.DOWN: movingDown = false;
			case Keyboard.LEFT: movingLeft = false;
			case Keyboard.RIGHT: movingRight = false;
			case Keyboard.UP: movingUp = false;
		}
	}

	private function this_onEnterFrame (event:Event):Void {
		if (movingDown) {
			logo.y += 5;
		}
		if (movingLeft) {
			logo.x -= 5;
		}
		if (movingRight) {
			logo.x += 5;
		}
		if (movingUp) {
			logo.y -= 5;
		}
	}
}
