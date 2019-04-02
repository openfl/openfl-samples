package;

import lime.ui.Gamepad;
import lime.ui.GamepadButton;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.Assets;
import openfl.Vector;

class Main extends Sprite
{
	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;
	private var fps:FPS;
	private var gravity:Float;
	private var minX:Int;
	private var minY:Int;
	private var maxX:Int;
	private var maxY:Int;
	private var tileset:Tileset;
	#if (flash || use_tilemap)
	private var tilemap:Tilemap;
	#else
	private var indices:Vector<Int>;
	private var transforms:Vector<Float>;
	#end
	public function new()
	{
		super();

		bunnies = new Array();

		minX = 0;
		maxX = stage.stageWidth;
		minY = 0;
		maxY = stage.stageHeight;
		gravity = 0.5;

		var bitmapData = Assets.getBitmapData("assets/wabbit_alpha.png");
		tileset = new Tileset(bitmapData);
		tileset.addRect(bitmapData.rect);

		#if (flash || use_tilemap)
		tilemap = new Tilemap(stage.stageWidth, stage.stageHeight, tileset);
		tilemap.tileAlphaEnabled = false;
		tilemap.tileBlendModeEnabled = false;
		tilemap.tileColorTransformEnabled = false;
		addChild(tilemap);
		#else
		indices = new Vector<Int>();
		transforms = new Vector<Float>();
		#end

		#if !html5
		fps = new FPS();
		#if !hide_fps
		addChild(fps);
		#end
		#end

		stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, stage_onMouseUp);
		stage.addEventListener(Event.ENTER_FRAME, stage_onEnterFrame);
		stage.addEventListener(Event.RESIZE, stage_onResize);

		Gamepad.onConnect.add(gamepad_onConnect);

		for (gamepad in Gamepad.devices)
		{
			gamepad_onConnect(gamepad);
		}

		var count = #if bunnies Std.parseInt(haxe.macro.Compiler.getDefine("bunnies")) #else 100 #end;

		for (i in 0...count)
		{
			addBunny();
		}
	}

	private function addBunny():Void
	{
		var bunny = new Bunny();
		bunny.x = 0;
		bunny.y = 0;
		bunny.speedX = Math.random() * 5;
		bunny.speedY = (Math.random() * 5) - 2.5;
		bunnies.push(bunny);

		#if (!flash && !use_tilemap)
		indices.push(bunny.id);
		transforms.push(0);
		transforms.push(0);
		#else
		tilemap.addTile(bunny);
		#end
	}

	// Event Handlers

	private function gamepad_onButtonDown(button:GamepadButton):Void
	{
		addingBunnies = true;
	}

	private function gamepad_onButtonUp(button:GamepadButton):Void
	{
		addingBunnies = false;
		trace(bunnies.length + " bunnies");
	}

	private function gamepad_onConnect(gamepad:Gamepad):Void
	{
		gamepad.onButtonDown.add(gamepad_onButtonDown);
		gamepad.onButtonUp.add(gamepad_onButtonUp);
	}

	private function stage_onEnterFrame(event:Event):Void
	{
		var bunny;

		for (i in 0...bunnies.length)
		{
			bunny = bunnies[i];

			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;

			if (bunny.x > maxX)
			{
				bunny.speedX *= -1;
				bunny.x = maxX;
			}
			else if (bunny.x < minX)
			{
				bunny.speedX *= -1;
				bunny.x = minX;
			}

			if (bunny.y > maxY)
			{
				bunny.speedY *= -0.8;
				bunny.y = maxY;

				if (Math.random() > 0.5)
				{
					bunny.speedY -= 3 + Math.random() * 4;
				}
			}
			else if (bunny.y < minY)
			{
				bunny.speedY = 0;
				bunny.y = minY;
			}

			#if (!flash && !use_tilemap)
			transforms[i * 2] = bunny.x;
			transforms[i * 2 + 1] = bunny.y;
			#end
		}

		#if (!flash && !use_tilemap)
		graphics.clear();
		graphics.beginFill(0xFFFFFF);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.beginBitmapFill(tileset.bitmapData, null, false);
		graphics.drawQuads(tileset.rectData, indices, transforms);
		#end

		if (addingBunnies)
		{
			#if hide_fps
			trace(fps.currentFPS);
			#end

			for (i in 0...100)
			{
				addBunny();
			}
		}
	}

	private function stage_onMouseDown(event:MouseEvent):Void
	{
		addingBunnies = true;
	}

	private function stage_onMouseUp(event:MouseEvent):Void
	{
		addingBunnies = false;
		trace(bunnies.length + " bunnies");
	}

	private function stage_onResize(event:Event):Void
	{
		maxX = stage.stageWidth;
		maxY = stage.stageHeight;

		#if (flash || use_tilemap)
		tilemap.width = stage.stageWidth;
		tilemap.height = stage.stageHeight;
		#end
	}
}
