package;


import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.utils.Assets;


class Main extends Sprite {
	
	
	public function new () {
		
		super ();
		
		/**
		 * "Various Creatures" by GrafxKid is licensed under CC BY 3.0
		 * (https://opengameart.org/content/various-creatures)
		 * (https://creativecommons.org/licenses/by/3.0/)
		 */
		var bitmapData = Assets.getBitmapData ("assets/tileset.png");
		var tileset = new Tileset (bitmapData);
		
		var gumdropID = tileset.addRect (new Rectangle (0, 0, 32, 32));
		var balloonID = tileset.addRect (new Rectangle (0, 64, 32, 32));
		var robotID = tileset.addRect (new Rectangle (0, 96, 32, 32));
		var compyID = tileset.addRect (new Rectangle (0, 224, 32, 32));
		
		var tilemap = new Tilemap (stage.stageWidth, stage.stageHeight, tileset);
		tilemap.smoothing = false;
		tilemap.scaleX = 4;
		tilemap.scaleY = 4;
		addChild (tilemap);
		
		var gumdrop = new Tile (gumdropID);
		gumdrop.x = 12;
		gumdrop.y = 48;
		tilemap.addTile (gumdrop);
		
		var balloon = new Tile (balloonID);
		balloon.x = 60;
		balloon.y = 48;
		tilemap.addTile (balloon);
		
		var robot = new Tile (robotID);
		robot.x = 108;
		robot.y = 48;
		tilemap.addTile (robot);
		
		var compy = new Tile (compyID);
		compy.x = 156;
		compy.y = 48;
		tilemap.addTile (compy);
		
	}
	
	
}