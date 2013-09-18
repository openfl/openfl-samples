package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.SoundChannel;
import motion.Actuate;
import openfl.Assets;

class Main extends Sprite {
	private var fill:Sprite;

	private var channel:SoundChannel;
	private var position:Float;

	public function new () {
		super ();

		fill = new Sprite ();
		fill.graphics.beginFill (0x3CB878);
		fill.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
		fill.alpha = 0.1;
		fill.buttonMode = true;
		fill.addEventListener (MouseEvent.MOUSE_DOWN, this_onMouseDown);
		addChild (fill);

		play ();
	}

	private function pause ():Void {
		if (channel != null) {
			position = channel.position;
			channel.removeEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);
			channel.stop ();
			channel = null;
		}

		Actuate.tween (fill, 3, { alpha: 0.1 });
	}

	private function play ():Void {
		var sound = Assets.getSound ("assets/stars.mp3");

		channel = sound.play (position);
		channel.addEventListener (Event.SOUND_COMPLETE, channel_onSoundComplete);

		Actuate.tween (fill, 3, { alpha: 1 });
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
