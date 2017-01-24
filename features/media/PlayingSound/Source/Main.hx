package;


import motion.easing.Quad;
import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
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
		
		resize ();
		stage.addEventListener (Event.RESIZE, stage_onResize);
		
		play ();
		
	}
	
	
	private function pause (fadeOut:Float = 1.2):Void {
		
		if (playing) {
			
			playing = false;
			
			Actuate.transform (channel, fadeOut).sound (0, 0).onComplete (stop);
			Actuate.tween (background, fadeOut, { alpha: 0.1 });
			
		}
		
	}
	
	
	private function play (fadeIn:Float = 3):Void {
		
		stop ();
		
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
	
	
	private function resize ():Void {
		
		background.graphics.clear ();
		background.graphics.beginFill (0x24afc4);
		background.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
		
	}
	
	
	private function stop ():Void {
		
		playing = false;
		
		Actuate.stop (channel);
		
		if (channel != null) {
			
			position = channel.position;
			channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
			channel.stop ();
			channel = null;
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function channel_onSoundComplete (event:Event):Void {
		
		pause ();
		position = 0;
		
	}
	
	
	private function stage_onResize (event:Event):Void {
		
		resize ();
		
	}
	
	
	private function this_onMouseDown (event:MouseEvent):Void {
		
		if (!playing) {
			
			play ();
			
		} else {
			
			pause ();
			
		}
		
	}
	
	
}