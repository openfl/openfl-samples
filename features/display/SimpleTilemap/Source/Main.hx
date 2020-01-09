package;

import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class Main extends Sprite
{
	public function new()
	{
		//Calls the constructor of the extended class, which is Sprite.
		super();

		/**
		 * "Various Creatures" by GrafxKid is licensed under CC BY 3.0
		 * (https://opengameart.org/content/various-creatures)
		 * (https://creativecommons.org/licenses/by/3.0/)
		 */
		//Gets the tileset.png picture from the file system, and loads it into a BitmapData object.
		var bitmapData = Assets.getBitmapData("assets/tileset.png");
		//Creates a Tileset object from the bitmapData object.
		var tileset = new Tileset(bitmapData);
		
		//Uses a rectangle to define a space of the loaded image as a single tile.
		//The addRect() call creates a tile internally from this rectangle and returns the generated ID
		//of the tile in this tileset. This is done four times. 
		var gumdropID = tileset.addRect(new Rectangle(0, 0, 32, 32));
		var balloonID = tileset.addRect(new Rectangle(0, 64, 32, 32));
		var robotID = tileset.addRect(new Rectangle(0, 96, 32, 32));
		var compyID = tileset.addRect(new Rectangle(0, 224, 32, 32));
		
		//Creates a new Tilemap object which will present the tiles on screen.
		//The width, and height of the Tilemap are the first two arguments, 
		//and the third is the Tileset object previously created.
		var tilemap = new Tilemap(stage.stageWidth, stage.stageHeight, tileset);
		//Sets some display options for the Tilemap.
		tilemap.smoothing = false;
		tilemap.scaleX = 4;
		tilemap.scaleY = 4;
		//Adds the created Tilemap object to the display list to make it visible on screen.
		addChild(tilemap);
		
		//Creates a new Tile object using the ID previously generated for it in the Tileset object
		var gumdrop = new Tile(gumdropID);
		//Sets its desired position in the Tilemap object
		gumdrop.x = 12;
		gumdrop.y = 48;
		//Adds the tile to the Tilemap object. The Tilemap object will use the ID inside of the Tile object
		//to find the tile graphic in the Tileset object so that it can display this Tile on screen with its
		//corresponding graphic.
		tilemap.addTile(gumdrop);
		
		//The following three code segments are a repeat of the previous segment for the three remaining tiles.
		var balloon = new Tile(balloonID);
		balloon.x = 60;
		balloon.y = 48;
		tilemap.addTile(balloon);

		var robot = new Tile(robotID);
		robot.x = 108;
		robot.y = 48;
		tilemap.addTile(robot);

		var compy = new Tile(compyID);
		compy.x = 156;
		compy.y = 48;
		tilemap.addTile(compy);
	}
}
