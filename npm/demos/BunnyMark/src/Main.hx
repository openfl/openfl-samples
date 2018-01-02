import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.net.URLRequest;


class Main extends Sprite {
	
	
	private var addingBunnies:Bool;
	private var bunnies:Array<Bunny>;
	//private var fps:FPS;
	private var gravity:Float;
	private var minX:Float;
	private var minY:Float;
	private var maxX:Float;
	private var maxY:Float;
	private var tilemap:Tilemap;
	private var tileset:Tileset;
	
	
	public function new () {
		
		super ();
		
		bunnies = [];
		
		var loader = new Loader ();
		loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
			start (cast (loader.content, Bitmap).bitmapData);
		});
		loader.load (new URLRequest ("wabbit_alpha.png"));
		
	}
	
	
	private function start (bitmapData:BitmapData):Void {
		
		minX = 0;
		maxX = stage.stageWidth;
		minY = 0;
		maxY = stage.stageHeight;
		gravity = 0.5;
		
		tileset = new Tileset (bitmapData);
		tileset.addRect (bitmapData.rect);
		
		tilemap = new Tilemap (stage.stageWidth, stage.stageHeight, tileset);
		//tilemap = new Tilemap (100, 100, tileset);
		addChild (tilemap);
		
		// fps = new FPS ();
		// addChild (fps);
		
		stage.addEventListener (MouseEvent.MOUSE_DOWN, stage_onMouseDown);
		stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		stage.addEventListener (Event.ENTER_FRAME, stage_onEnterFrame);
		
		for (i in 0...10) {
			
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
		tilemap.addTile (bunny);
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function stage_onEnterFrame (event:Event):Void {
		
		for (bunny in bunnies) {
			
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
			
		}
		
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
	
	
	
	
	// Entry point
	
	
	
	
	static function main () {
		
		var stage = new Stage (550, 400, 0xFFFFFF, Main);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}