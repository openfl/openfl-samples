package;

import haxe.Timer;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.ProgressEvent;

//optional
#if flash
@:bitmap("assets/preload.jpg") class Back extends BitmapData {}
#elseif html5
@:bitmap("assets/preload.jpg") class Back extends BitmapData {}
#elseif android
@:bitmap("assets/preload.jpg") class Back extends BitmapData {}
#elseif ios
@:bitmap("assets/preload.jpg") class Back extends BitmapData {}
#else
@:bitmap("assets/preload.jpg") class Back extends BitmapData {}
#end

class Preloader extends Sprite
{
	private var _back:Bitmap = null;
	private var _progress:Sprite = new Sprite();
	
	public function new()
	{
		super();
		
		var w:Int = Lib.current.stage.stageWidth;
		var h:Int = Lib.current.stage.stageHeight;
		
		var bmpd:BitmapData = new Back(w, h);
		_back = new Bitmap(bmpd, PixelSnapping.AUTO, true);
#if !html5 //not working in HTML5 since OpenFL 7, because image is not loaded yet, fix it in this_onProgress
		_back.width = w;
		_back.height = h;
#end
		addChild(_back);
		
		addChild(_progress); //on top of background

		addEventListener(Event.COMPLETE, this_onComplete);
		addEventListener(ProgressEvent.PROGRESS, this_onProgress);
	}

	private function update(percent:Float):Void
	{
		_progress.graphics.clear();
		_progress.graphics.beginFill(0x1F9DB2, 0.3);
		_progress.graphics.drawRect(0, 0, stage.stageWidth * percent, stage.stageHeight);
	}

	private function this_onComplete(event:Event):Void
	{
		update(1);

		// optional

		event.preventDefault();

		Timer.delay(function()
		{
			dispatchEvent(new Event(Event.UNLOAD));
		}, 2000);
	}

	private function this_onProgress(event:ProgressEvent):Void
	{
		if (event.bytesTotal <= 0)
		{
			update(0);
		}
		else
		{
			update(event.bytesLoaded / event.bytesTotal);
			
#if html5 //image has been loadede, set correct size of in HTML5
			if(_back.width != 0)
			{
				_back.width = stage.stageWidth;
				_back.height = stage.stageHeight;
			}
#end
		}
	}
}
