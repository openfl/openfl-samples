import openfl.display.Shape;
import openfl.display.Sprite;

class Tile extends Sprite
{
	public function new()
	{
		super();

		// draw a transparent background so that it can be clicked
		graphics.beginFill(0xff00ff, 0.0);
		graphics.drawRect(0.0, 0.0, 50.0, 50.0);
		graphics.endFill();

		shape = new Shape();
		addChild(shape);
	};

	private var shape:Shape;

	public var winner(default, set):Bool = false;

	private function set_winner(value:Bool):Bool
	{
		if (winner == value)
		{
			return winner;
		}
		winner = value;
		redrawShape();
		return winner;
	}

	public var player(default, set):Null<Player>;

	private function set_player(value:Null<Player>):Null<Player>
	{
		if (player == value)
		{
			return player;
		}
		player = value;
		redrawShape();
		return player;
	}

	private function redrawShape():Void
	{
		shape.graphics.clear();
		if (player == null)
		{
			return;
		}
		var color = if (winner)
		{
			0xff9900;
		}
		else if (player == X)
		{
			0x990000;
		}
		else
		{
			0x000099;
		}
		shape.graphics.lineStyle(12.0, color);
		if (player == X)
		{
			shape.graphics.moveTo(11.0, 11.0);
			shape.graphics.lineTo(39.0, 39.0);
			shape.graphics.moveTo(11.0, 39.0);
			shape.graphics.lineTo(39.0, 11.0);
		}
		else
		{
			shape.graphics.drawCircle(25.0, 25.0, 14.0);
		}
	}
}
