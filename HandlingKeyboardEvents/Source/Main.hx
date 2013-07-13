import flash.Lib;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.ui.Keyboard;
import flash.events.KeyboardEvent;

import openfl.Assets;

class Main extends Sprite 
{		
	private var Logo:Sprite;
	
	private var movingDown:Bool;
	private var movingLeft:Bool;
	private var movingRight:Bool;
	private var movingUp:Bool;	
	
	public function new () 
	{		
		super ();
		
		Logo = new Sprite ();
		Logo.addChild (new Bitmap (Assets.getBitmapData ("assets/nme.png")));
		Logo.x = 100;
		Logo.y = 100;
		Logo.buttonMode = true;
		addChild (Logo);
		
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_DOWN, stage_onKeyDown);
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
		
		Lib.current.stage.addEventListener (Event.ENTER_FRAME, this_onEnterFrame);		
	}
	
	
	private function stage_onKeyDown (event:KeyboardEvent) 
	{		
		switch (event.keyCode) 
		{			
			case Keyboard.DOWN: 
				movingDown = true;
			case Keyboard.LEFT: 
				movingLeft = true;
			case Keyboard.RIGHT: 
				movingRight = true;
			case Keyboard.UP: 
				movingUp = true;			
		}		
	}
	
	
	private function stage_onKeyUp (event:KeyboardEvent) 
	{		
		switch (event.keyCode) 
		{			
			case Keyboard.DOWN: 
				movingDown = false;
			case Keyboard.LEFT: 
				movingLeft = false;
			case Keyboard.RIGHT: 
				movingRight = false;
			case Keyboard.UP: 
				movingUp = false;			
		}		
	}
		
	private function this_onEnterFrame (event:Event)
	{		
		if (movingDown) 
			Logo.y += 5;			
		
		if (movingLeft) 
			Logo.x -= 5;
		
		if (movingRight) 
			Logo.x += 5;
		
		if (movingUp) 
			Logo.y -= 5;
	}		
}