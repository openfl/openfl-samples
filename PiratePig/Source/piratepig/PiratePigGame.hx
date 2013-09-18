package piratepig;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.media.Sound;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.Lib;
import motion.Actuate;
import motion.easing.Quad;
import openfl.Assets;

class PiratePigGame extends Sprite {
	private static var NUM_COLUMNS = 8;
	private static var NUM_ROWS = 8;

	private static var tileImages = [ "images/game_bear.png", "images/game_bunny_02.png", "images/game_carrot.png", "images/game_lemon.png", "images/game_panda.png", "images/game_piratePig.png" ];

	private var background:Sprite;
	private var introSound:Sound;
	private var logo:Bitmap;
	private var score:TextField;
	private var sound3:Sound;
	private var sound4:Sound;
	private var sound5:Sound;
	private var tileContainer:Sprite;

	public var currentScale:Float;
	public var currentScore:Int;

	private var cacheMouse:Point;
	private var needToCheckMatches:Bool;
	private var selectedTile:Tile;
	private var tiles:Array <Array <Tile>>;
	private var usedTiles:Array <Tile>;

	public function new () {
		super ();

		initialize ();
		construct ();

		newGame ();
	}

	private function addTile (row:Int, column:Int, animate:Bool = true):Void {
		var tile = null;
		var type = Math.round (Math.random () * (tileImages.length - 1));

		for (usedTile in usedTiles) {
			if (usedTile.removed && usedTile.parent == null && usedTile.type == type) {
				tile = usedTile;
			}
		}

		if (tile == null) {
			tile = new Tile (tileImages[type]);
		}

		tile.initialize ();

		tile.type = type;
		tile.row = row;
		tile.column = column;
		tiles[row][column] = tile;

		var position = getPosition (row, column);

		if (animate) {
			var firstPosition = getPosition (-1, column);

#if !js
			tile.alpha = 0;
#end
			tile.x = firstPosition.x;
			tile.y = firstPosition.y;

			tile.moveTo (0.15 * (row + 1), position.x, position.y);
#if !js
			Actuate.tween (tile, 0.3, { alpha: 1 }).delay (0.15 * (row - 2)).ease (Quad.easeOut);
#end
		} else {
			tile.x = position.x;
			tile.y = position.y;
		}

		tileContainer.addChild (tile);
		needToCheckMatches = true;
	}

	private function construct ():Void {
		logo.smoothing = true;
		addChild (logo);

		var font = Assets.getFont ("fonts/FreebooterUpdated.ttf");
		var defaultFormat = new TextFormat (font.fontName, 60, 0x000000);
		defaultFormat.align = TextFormatAlign.RIGHT;

#if js
		defaultFormat.align = TextFormatAlign.LEFT;
#end

		var contentWidth = 75 * NUM_COLUMNS;

		score.x = contentWidth - 200;
		score.width = 200;
		score.y = 12;
		score.selectable = false;
		score.defaultTextFormat = defaultFormat;

#if !js
		score.filters = [ new BlurFilter (1.5, 1.5), new DropShadowFilter (1, 45, 0, 0.2, 5, 5) ];
#else
		Score.y = 0;
		Score.x += 90;
#end

		score.embedFonts = true;
		addChild (score);

		background.y = 85;
		background.graphics.beginFill (0xFFFFFF, 0.4);
		background.graphics.drawRect (0, 0, contentWidth, 75 * NUM_ROWS);

#if !js
		background.filters = [ new BlurFilter (10, 10) ];
		addChild (background);
#end

		tileContainer.x = 14;
		tileContainer.y = background.y + 14;
		tileContainer.addEventListener (MouseEvent.MOUSE_DOWN, TileContainer_onMouseDown);
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_UP, stage_onMouseUp);
		addChild (tileContainer);

		introSound = Assets.getSound ("soundTheme");
		sound3 = Assets.getSound ("sound3");
		sound4 = Assets.getSound ("sound4");
		sound5 = Assets.getSound ("sound5");
	}

	private function dropTiles ():Void {
		for (column in 0...NUM_COLUMNS) {
			var spaces = 0;

			for (row in 0...NUM_ROWS) {
				var index = (NUM_ROWS - 1) - row;
				var tile = tiles[index][column];

				if (tile == null) {
					spaces++;
				} else {
					if (spaces > 0) {
						var position = getPosition (index + spaces, column);
						tile.moveTo (0.15 * spaces, position.x, position.y);

						tile.row = index + spaces;
						tiles[index + spaces][column] = tile;
						tiles[index][column] = null;

						needToCheckMatches = true;
					}
				}
			}

			for (i in 0...spaces) {
				var row = (spaces - 1) - i;
				addTile (row, column);
			}
		}
	}

	private function findMatches (byRow:Bool, accumulateScore:Bool = true):Array <Tile> {
		var matchedTiles = new Array<Tile> ();

		var max:Int;
		var secondMax:Int;

		if (byRow) {
			max = NUM_ROWS;
			secondMax = NUM_COLUMNS;
		} else {
			max = NUM_COLUMNS;
			secondMax = NUM_ROWS;
		}

		for (index in 0...max) {
			var matches = 0;
			var foundTiles = new Array<Tile> ();
			var previousType = -1;

			for (secondIndex in 0...secondMax) {
				var tile:Tile;
				if (byRow) {
					tile = tiles[index][secondIndex];
				} else {
					tile = tiles[secondIndex][index];
				}

				if (tile != null && !tile.moving) {
					if (previousType == -1) {
						previousType = tile.type;
						foundTiles.push (tile);
						continue;
					} else if (tile.type == previousType) {
						foundTiles.push (tile);
						matches++;
					}
				}

				if (tile == null || tile.moving || tile.type != previousType || secondIndex == secondMax - 1) {
					if (matches >= 2 && previousType != -1) {
						if (accumulateScore) {
							if (matches > 3) {
								sound5.play ();
							} else if (matches > 2) {
								sound4.play ();
							} else {
								sound3.play ();
							}

							currentScore += Std.int (Math.pow (matches, 2) * 50);
						}

						matchedTiles = matchedTiles.concat (foundTiles);
					}

					matches = 0;
					foundTiles = new Array<Tile> ();

					if (tile == null || tile.moving) {
						needToCheckMatches = true;
						previousType = -1;
					} else {
						previousType = tile.type;
						foundTiles.push (tile);
					}
				}
			}
		}

		return matchedTiles;
	}

	private function getPosition (row:Int, column:Int):Point {
		return new Point (column * (57 + 16), row * (57 + 16));
	}

	private function initialize ():Void {
		currentScale = 1;
		currentScore = 0;

		tiles = new Array<Array<Tile>> ();
		usedTiles = new Array<Tile> ();

		for (row in 0...NUM_ROWS) {
			tiles[row] = new Array<Tile> ();
			for (column in 0...NUM_COLUMNS) {
				tiles[row][column] = null;
			}
		}

		background = new Sprite ();
		logo = new Bitmap (Assets.getBitmapData ("images/logo.png"));
		score = new TextField ();
		tileContainer = new Sprite ();
	}

	public function newGame ():Void {
		currentScore = 0;
		score.text = "0";

		for (row in 0...NUM_ROWS) {
			for (column in 0...NUM_COLUMNS) {
				removeTile (row, column, false);
			}
		}

		for (row in 0...NUM_ROWS) {
			for (column in 0...NUM_COLUMNS) {
				addTile (row, column, false);
			}
		}

		introSound.play ();

		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
	}

	public function removeTile (row:Int, column:Int, animate:Bool = true):Void {
		var tile = tiles[row][column];
		if (tile != null) {
			tile.remove (animate);
			usedTiles.push (tile);
		}
		tiles[row][column] = null;
	}

	public function resize (newWidth:Int, newHeight:Int):Void {
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;

		currentScale = 1;
		scaleX = 1;
		scaleY = 1;

#if js
		var currentWidth = 75 * NUM_COLUMNS;
		var currentHeight = 75 * NUM_ROWS + 85;
#else
		var currentWidth = width;
		var currentHeight = height;
#end

		if (currentWidth > maxWidth || currentHeight > maxHeight) {
			var maxScaleX = maxWidth / currentWidth;
			var maxScaleY = maxHeight / currentHeight;

			if (maxScaleX < maxScaleY) {
				currentScale = maxScaleX;
			} else {
				currentScale = maxScaleY;
			}

			scaleX = currentScale;
			scaleY = currentScale;
		}

		x = newWidth / 2 - (currentWidth * currentScale) / 2;
	}

	private function swapTile (tile:Tile, targetRow:Int, targetColumn:Int):Void {
		if (targetColumn >= 0 && targetColumn < NUM_COLUMNS && targetRow >= 0 && targetRow < NUM_ROWS) {
			var targetTile = tiles[targetRow][targetColumn];

			if (targetTile != null && !targetTile.moving) {
				tiles[targetRow][targetColumn] = tile;
				tiles[tile.row][tile.column] = targetTile;

				if (findMatches (true, false).length > 0 || findMatches (false, false).length > 0) {
					targetTile.row = tile.row;
					targetTile.column = tile.column;
					tile.row = targetRow;
					tile.column = targetColumn;
					var targetTilePosition = getPosition (targetTile.row, targetTile.column);
					var tilePosition = getPosition (tile.row, tile.column);

					targetTile.moveTo (0.3, targetTilePosition.x, targetTilePosition.y);
					tile.moveTo (0.3, tilePosition.x, tilePosition.y);

					needToCheckMatches = true;
				} else {
					tiles[targetRow][targetColumn] = targetTile;
					tiles[tile.row][tile.column] = tile;
				}
			}
		}
	}

// Event Handlers

	private function stage_onMouseUp (event:MouseEvent):Void {
		if (cacheMouse != null && selectedTile != null && !selectedTile.moving) {
			var differenceX = event.stageX - cacheMouse.x;
			var differenceY = event.stageY - cacheMouse.y;

			if (Math.abs (differenceX) > 10 || Math.abs (differenceY) > 10) {
				var swapToRow = selectedTile.row;
				var swapToColumn = selectedTile.column;

				if (Math.abs (differenceX) > Math.abs (differenceY)) {
					if (differenceX < 0) {
						swapToColumn --;
					} else {
						swapToColumn ++;
					}
				} else {
					if (differenceY < 0) {
						swapToRow --;
					} else {
						swapToRow ++;
					}
				}

				swapTile (selectedTile, swapToRow, swapToColumn);
			}
		}

		selectedTile = null;
		cacheMouse = null;
	}

	private function this_onEnterFrame (event:Event):Void {
		if (needToCheckMatches) {
			var matchedTiles = new Array<Tile> ();

			matchedTiles = matchedTiles.concat (findMatches (true));
			matchedTiles = matchedTiles.concat (findMatches (false));

			for (tile in matchedTiles) {
				removeTile (tile.row, tile.column);
			}

			if (matchedTiles.length > 0) {
				score.text = Std.string (currentScore);
				dropTiles ();
			}
		}
	}

	private function TileContainer_onMouseDown (event:MouseEvent):Void {
		if (Std.is (event.target, Tile)) {
			selectedTile = cast event.target;
			cacheMouse = new Point (event.stageX, event.stageY);
		} else {
			cacheMouse = null;
			selectedTile = null;
		}
	}
}
