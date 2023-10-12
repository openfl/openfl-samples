import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Main extends Sprite
{
	private static final WINNING_LINES = [
		[0, 1, 2],
		[3, 4, 5],
		[6, 7, 8],
		[0, 3, 6],
		[1, 4, 7],
		[2, 5, 8],
		[0, 4, 8],
		[2, 4, 6],
	];

	private var tiles:Array<Tile> = [];
	private var turn:Int = 0;
	private var winner:Bool = false;

	public function new()
	{
		super();

		var board = new Sprite();
		board.graphics.lineStyle(4.0, 0x000000);
		board.graphics.moveTo(50.0, 0.0);
		board.graphics.lineTo(50.0, 150.0);
		board.graphics.moveTo(100.0, 0.0);
		board.graphics.lineTo(100.0, 150.0);
		board.graphics.moveTo(0.0, 50.0);
		board.graphics.lineTo(150.0, 50.0);
		board.graphics.moveTo(0.0, 100.0);
		board.graphics.lineTo(150.0, 100.0);
		board.x = 10.0;
		board.y = 10.0;
		addChild(board);

		var currentX = 0.0;
		var currentY = 0.0;
		for (i in 0...9)
		{
			var tile = new Tile();
			tile.x = currentX * 50.0;
			tile.y = currentY * 50.0;
			tile.addEventListener(MouseEvent.MOUSE_DOWN, tile_onClick);
			board.addChild(tile);
			tiles.push(tile);
			currentX++;
			if (currentX > 2)
			{
				currentX = 0;
				currentY++;
			}
		}
	}

	private function checkWinner():Void
	{
		for (line in WINNING_LINES)
		{
			var a = line[0];
			var b = line[1];
			var c = line[2];
			var tileA = tiles[a];
			var tileB = tiles[b];
			var tileC = tiles[c];
			if (tileA.player != null && tileA.player == tileB.player && tileA.player == tileC.player)
			{
				winner = tileA.winner = tileB.winner = tileC.winner = true;
				break;
			}
		}
	}

	private function resetBoard():Void
	{
		for (tile in tiles)
		{
			tile.player = null;
			tile.winner = false;
		}
		turn = 0;
		winner = false;
	}

	private function tile_onClick(event:MouseEvent):Void
	{
		if (winner)
		{
			resetBoard();
			return;
		}
		var tile:Tile = cast event.currentTarget;
		if (tile.player != null)
		{
			// already played this tile
			return;
		}
		tile.player = turn % 2 == 0 ? X : O;
		turn++;
		checkWinner();
	}
}
