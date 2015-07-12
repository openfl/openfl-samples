package tests;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.display.StageQuality;
import openfl.display.Tilesheet;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

#if !lime_legacy
import lime.ui.Gamepad;
import lime.ui.GamepadButton;
#end


#if !lime_legacy
class TilesheetTestInput extends lime.app.Module {


	public var addBunnies:Void->Void;

	public override function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton):Void
	{
		switch (button)
		{
			case A:
				addBunnies ();
			case B:
				addBunnies ();
				addBunnies ();
			case X:
				addBunnies ();
				addBunnies ();
				addBunnies ();
			case Y:
				addBunnies ();
				addBunnies ();
				addBunnies ();
				addBunnies ();
			default:
		}
	}


}
#end


class TilesheetTest extends Sprite {
	
	
	private var tf:TextField;	
	private var numBunnies:Int;
	private var incBunnies:Int;
	private var smooth:Bool;
	private var gravity:Float;
	private var bunnies:Array <Bunny>;
	private var maxX:Int;
	private var minX:Int;
	private var maxY:Int;
	private var minY:Int;
	private var bunnyAsset:BitmapData;
	private var pirate:Bitmap;
	private var tilesheet:Tilesheet;
	private var drawList:Array<Float>;
	#if !lime_legacy
	private var inputModule:TilesheetTestInput;
	#end
	
	public function new() 
	{
		super ();
		
		minX = 0;
		maxX = Env.width;
		minY = 0;
		maxY = Env.height;
		gravity = 0.5;
		incBunnies = 100;
		#if flash
		smooth = false;
		numBunnies = 100;
		Lib.current.stage.quality = StageQuality.LOW;
		#else
		smooth = true;
		numBunnies = 500;
		#end

		bunnyAsset = Assets.getBitmapData("assets/wabbit_alpha.png");
		pirate = new Bitmap(Assets.getBitmapData("assets/pirate.png"), PixelSnapping.AUTO, true);
		pirate.scaleX = pirate.scaleY = Env.height / 768;
		addChild(pirate);
		
		bunnies = new Array<Bunny>();
		drawList = new Array<Float>();
		tilesheet = new Tilesheet(bunnyAsset);
		tilesheet.addTileRect(
			new Rectangle (0, 0, bunnyAsset.width, bunnyAsset.height));
		
		var bunny; 
		for (i in 0...numBunnies) 
		{
			bunny = new Bunny();
			bunny.position = new Point();
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scale = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			bunnies.push(bunny);
		}
		
		createCounter();
		
		addEventListener(Event.ENTER_FRAME, enterFrame);
		Lib.current.stage.addEventListener(Event.RESIZE, stage_resize);
		stage_resize(null);

		#if !lime_legacy
		inputModule = new TilesheetTestInput();
		inputModule.addBunnies = function() { counter_click(null); };
		Lib.application.addModule (inputModule);
		#end
	}

	function createCounter()
	{
		var format = new TextFormat("_sans", 20, 0, true);
		format.align = TextFormatAlign.RIGHT;

		tf = new TextField();
		tf.selectable = false;
		tf.defaultTextFormat = format;
		tf.width = 200;
		tf.height = 60;
		tf.x = maxX - tf.width - 10;
		tf.y = 10;
		addChild(tf);

		tf.addEventListener(MouseEvent.CLICK, counter_click);
	}

	function counter_click(e)
	{
		if (numBunnies >= 1500) incBunnies = 250;
		var more = numBunnies + incBunnies;

		var bunny; 
		for (i in numBunnies...more)
		{
			bunny = new Bunny();
			bunny.position = new Point();
			bunny.speedX = Math.random() * 5;
			bunny.speedY = (Math.random() * 5) - 2.5;
			bunny.scale = 0.3 + Math.random();
			bunny.rotation = 15 - Math.random() * 30;
			bunnies.push (bunny);
		}
		numBunnies = more;

		stage_resize(null);
	}

	function stage_resize(e) 
	{
		maxX = Env.width;
		maxY =Env.height;
		tf.text = "Bunnies:\n" + numBunnies;
		tf.x = maxX - tf.width - 10;
	}
	
	function enterFrame(e) 
	{	
		graphics.clear ();

		var TILE_FIELDS = 6; // x+y+index+scale+rotation+alpha
		var bunny;
	 	for (i in 0...numBunnies)
		{
			bunny = bunnies[i];
			bunny.position.x += bunny.speedX;
			bunny.position.y += bunny.speedY;
			bunny.speedY += gravity;
			bunny.alpha = 0.3 + 0.7 * bunny.position.y / maxY;
			
			if (bunny.position.x > maxX)
			{
				bunny.speedX *= -1;
				bunny.position.x = maxX;
			}
			else if (bunny.position.x < minX)
			{
				bunny.speedX *= -1;
				bunny.position.x = minX;
			}
			if (bunny.position.y > maxY)
			{
				bunny.speedY *= -0.8;
				bunny.position.y = maxY;
				if (Math.random() > 0.5) bunny.speedY -= 3 + Math.random() * 4;
			} 
			else if (bunny.position.y < minY)
			{
				bunny.speedY = 0;
				bunny.position.y = minY;
			}
			
			var index = i * TILE_FIELDS;
			drawList[index] = bunny.position.x;
			drawList[index + 1] = bunny.position.y;
			//drawList[index + 2] = 0; // sprite index
			drawList[index + 3] = bunny.scale;
			drawList[index + 4] = bunny.rotation;
			drawList[index + 5] = bunny.alpha;
		}
		
		tilesheet.drawTiles(graphics, drawList, smooth, 
			Tilesheet.TILE_SCALE | Tilesheet.TILE_ROTATION | Tilesheet.TILE_ALPHA);

		var t = Lib.getTimer();
		pirate.x = Std.int((Env.width - pirate.width) * (0.5 + 0.5 * Math.sin(t / 3000)));
		pirate.y = Std.int(Env.height - pirate.height + 70 - 30 * Math.sin(t / 100));
	}
	
	
}
