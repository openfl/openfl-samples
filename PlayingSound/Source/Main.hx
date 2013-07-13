import motion.Actuate;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.SoundChannel;
import flash.Lib;
import openfl.Assets;

class Main extends Sprite 
{	
	private var Fill:Sprite;
	
	private var channel:SoundChannel;
	private var position:Float;	
	
	public function new () 
	{		
		super ();
		
		Fill = new Sprite ();
		Fill.graphics.beginFill (0x3CB878);
		Fill.graphics.drawRect (0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Fill.alpha = 0.1;
		Fill.buttonMode = true;
		Fill.addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		addChild (Fill);
		
		play ();		
	}	
	
	private function pause ()
	{		
		if (channel != null) 
		{			
			position = channel.position;
			channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
			channel.stop ();
			channel = null;			
		}
		
		Actuate.tween (Fill, 3, { alpha: 0.1 } );		
	}	

	private function play ()
	{		
		var sound = Assets.getSound ("assets/stars.mp3");
		
		channel = sound.play (position);
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
		
		Actuate.tween (Fill, 3, { alpha: 1 } );		
	}	
	
	private function channel_onSoundComplete (event:Event)
	{		
		pause ();		
		position = 0;		
	}
	
	
	private function this_onMouseDown (event:MouseEvent)
	{		
		if (channel == null) 
			play ();
		else 
			pause ();
	}	
}