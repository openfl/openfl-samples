package io.nme.samples.piratepig;

import openfl.Assets;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.system.Capabilities;

class PiratePig extends Sprite 
{	
	private var Background:Bitmap;
	private var Footer:Bitmap;
	private var Game:PiratePigGame; 
	
	public function new () 
	{		
		super ();
		
		initialize ();
		construct ();
		
		resize (Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Lib.current.stage.addEventListener (Event.RESIZE, stage_onResize);
		
		#if android
		Lib.current.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
		#end		
	}	
	
	private function construct ()
	{		
		Footer.smoothing = true;
		
		addChild (Background);
		addChild (Footer);
		addChild (Game);		
	}	
	
	private function initialize ()
	{		
		Background = new Bitmap (Assets.getBitmapData ("images/background_tile.png"));
		Footer = new Bitmap (Assets.getBitmapData ("images/center_bottom.png"));
		Game = new PiratePigGame ();		
	}
	
	private function resize (newWidth:Int, newHeight:Int)
	{		
		Background.width = newWidth;
		Background.height = newHeight;
		
		Game.resize (newWidth, newHeight);
		
		Footer.scaleX = Game.currentScale;
		Footer.scaleY = Game.currentScale;
		Footer.x = newWidth / 2 - Footer.width / 2;
		Footer.y = newHeight - Footer.height;		
	}
	
	private function stage_onKeyUp (event:KeyboardEvent)
	{		
		#if android		
		if (event.keyCode == 27)
		{		
			event.stopImmediatePropagation ();
			Lib.exit ();			
		}		
		#end		
	}
	
	private function stage_onResize (event:Event)
	{		
		resize (stage.stageWidth, stage.stageHeight);		
	}	
}