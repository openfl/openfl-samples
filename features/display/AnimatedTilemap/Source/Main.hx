package;


import openfl.display.Sprite;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.utils.Assets;


class Main extends Sprite {
	
	
	private var blobAnimation:Array<Int>;
	private var bugAnimation:Array<Int>;
	private var owlAnimation:Array<Int>;
	private var snailAnimation:Array<Int>;
	private var tiles:Array<AnimatedTile>;
	private var tilemap:Tilemap;
	private var tileset:Tileset;
	
	
	public function new () {
		
		super ();
		
		buildTileset ();
		
		tilemap = new Tilemap (176, 32, tileset);
		tilemap.tileColorTransformEnabled = false;
		tilemap.smoothing = false;
		tilemap.scaleX = 4;
		tilemap.scaleY = 4;
		tilemap.y = (stage.stageHeight - tilemap.height) / 2;
		tilemap.x = (stage.stageWidth - tilemap.width) / 2;
		addChild (tilemap);
		
		var snail = new AnimatedTile (snailAnimation);
		var blob = new AnimatedTile (blobAnimation);
		var owl = new AnimatedTile (owlAnimation);
		var bug = new AnimatedTile (bugAnimation);
		
		tiles = [ snail, blob, owl, bug ];
		
		for (i in 0...tiles.length) {
			
			tiles[i].x = 48 * i;
			tilemap.addTile (tiles[i]);
			
		}
		
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	private function buildTileset ():Void {
		
		/**
		 * "Various Creatures" by GrafxKid is licensed under CC BY 3.0
		 * (https://opengameart.org/content/various-creatures)
		 * (https://creativecommons.org/licenses/by/3.0/)
		 */
		var bitmapData = Assets.getBitmapData ("assets/tileset.png");
		
		tileset = new Tileset (bitmapData);
		
		snailAnimation = [];
		blobAnimation = [];
		owlAnimation = [];
		bugAnimation = [];
		
		var rect = new Rectangle (0, 0, 32, 32);
		
		for (i in 0...4) {
			
			rect.x = 32 * i;
			
			rect.y = 32;
			snailAnimation.push (tileset.addRect (rect));
			
			rect.y = 32 * 4;
			blobAnimation.push (tileset.addRect (rect));
			
			rect.y = 32 * 5;
			owlAnimation.push (tileset.addRect (rect));
			
			rect.y = 32 * 6;
			bugAnimation.push (tileset.addRect (rect));
			
		}
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		for (tile in tiles) {
			
			tile.update ();
			
		}
		
	}
	
	
}