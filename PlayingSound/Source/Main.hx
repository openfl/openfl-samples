package;


import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;


class Main extends Sprite {
	
	
	private var background:Sprite;
	private var channel:SoundChannel;
	private var playing:Bool;
	private var position:Float;
	private var sound:Sound;
	
	
	public function new () {
		
		super ();
		
		Actuate.defaultEase = Quad.easeOut;
		
		background = new Sprite ();
		background.graphics.beginFill (0x3CB878);
		background.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
		background.alpha = 0.1;
		background.buttonMode = true;
		background.addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		addChild (background);
		
		#if flash
		sound = Assets.getSound ("assets/stars.mp3");
		#else
		sound = Assets.getSound ("assets/stars.ogg");
		#end
		
		position = 0;
		
		play ();
		
	}
	
	
	private function pause (fadeOut:Float = 1.2):Void {
		
		if (playing) {
			
			playing = false;
			
			Actuate.transform (channel, fadeOut).sound (0, 0).onComplete (function () {
				
				position = channel.position;
				channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
				channel.stop ();
				channel = null;
				
			});
			
			Actuate.tween (background, fadeOut, { alpha: 0.1 });
			
		}
		
	}
	
	
	private function play (fadeIn:Float = 3):Void {
		
		playing = true;
		
		if (fadeIn <= 0) {
			
			channel = sound.play (position);
			
		} else {
			
			channel = sound.play (position, 0, new SoundTransform (0, 0));
			Actuate.transform (channel, fadeIn).sound (1, 0);
			
		}
		
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
		Actuate.tween (background, fadeIn, { alpha: 1 });
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function channel_onSoundComplete (event:Event):Void {
		
		pause ();
		position = 0;
		
	}
	
	
	private function this_onMouseDown (event:MouseEvent):Void {
		
		if (channel == null) {
			
			play ();
			
		} else {
			
			pause ();
			
		}
		
	}
	
	
}