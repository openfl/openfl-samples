package;


import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.Assets;
import openfl.Vector;


class Main extends Sprite {
	
	
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
	private var matrices:Vector<Float>;
	#end
	
	
	public function new () {
		
		super ();
		
		bunnies = new Array ();
		
		minX = 0;
		maxX = stage.stageWidth;
		minY = 0;
		maxY = stage.stageHeight;
		gravity = 0.5;
		
		var bitmapData = Assets.getBitmapData ("assets/wabbit_alpha.png");
		tileset = new Tileset (bitmapData);
		tileset.addRect (bitmapData.rect);
		
		#if (flash || use_tilemap)
		tilemap = new Tilemap (stage.stageWidth, stage.stageHeight, tileset);
		addChild (tilemap);
		#else
		matrices = new Vector<Float> ();
		#end
		
		#if !html5
		fps = new FPS ();
		addChild (fps);
		#end
		
		stage.addEventListener (MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
		var count = #if bunnies Std.parseInt (haxe.macro.Compiler.getDefine ("bunnies")) #else 100 #end;
		
		for (i in 0...count) {
			
			addBunny ();
			
		}
		
	}
	
	
	private function addBunny ():Void {
		
		var bunny = new Bunny ();
		bunny.x = 0;
		bunny.y = 0;
		bunny.speedX = Math.random () * 5;
		bunny.speedY = (Math.random () * 5) - 2.5;
		bunnies.push (bunny);
		
		#if (!flash && !use_tilemap)
		matrices.push (1);
		matrices.push (0);
		matrices.push (0);
		matrices.push (1);
		matrices.push (0);
		matrices.push (0);
		#elseif !use_tilearray
		tilemap.addTile (bunny);
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onEnterFrame (event:Event):Void {
		
		var bunny;
		
		#if use_tilearray
		var tiles = tilemap.getTiles ();
		tiles.length = bunnies.length;
		tiles.position = 0;
		var matrix = tiles.matrix;
		#end
		
		for (i in 0...bunnies.length) {
			
			bunny = bunnies[i];
			
			#if use_tilearray
			tiles.position = i;
			#end
			
			bunny.x += bunny.speedX;
			bunny.y += bunny.speedY;
			bunny.speedY += gravity;
			
			if (bunny.x > maxX) {
				
				bunny.speedX *= -1;
				bunny.x = maxX;
				
			} else if (bunny.x < minX) {
				
				bunny.speedX *= -1;
				bunny.x = minX;
				
			}
			
			if (bunny.y > maxY) {
				
				bunny.speedY *= -0.8;
				bunny.y = maxY;
				
				if (Math.random () > 0.5) {
					
					bunny.speedY -= 3 + Math.random () * 4;
					
				}
				
			} else if (bunny.y < minY) {
				
				bunny.speedY = 0;
				bunny.y = minY;
				
			}
			
			#if (!flash && !use_tilemap)
			matrices[i * 6 + 4] = bunny.x;
			matrices[i * 6 + 5] = bunny.y;
			#elseif use_tilearray
			matrix.tx = bunny.x;
			matrix.ty = bunny.y;
			tiles.matrix = matrix;
			#end
			
		}
		
		#if (!flash && !use_tilemap)
		graphics.clear ();
		graphics.beginFill (0xFFFFFF);
		graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
		graphics.beginBitmapFill (tileset.bitmapData);
		graphics.drawQuads (matrices);
		#elseif use_tilearray
		tilemap.setTiles (tiles);
		#end
		
		if (addingBunnies) {
			
			for (i in 0...100) {
				
				addBunny ();
				
			}
			
		}
		
	}
	
	
	private function stage_onMouseDown (event:MouseEvent):Void {
		
		addingBunnies = true;
		
	}
	
	
	private function stage_onMouseUp (event:MouseEvent):Void {
		
		addingBunnies = false;
		trace (bunnies.length + " bunnies");
		
	}
	
	
}