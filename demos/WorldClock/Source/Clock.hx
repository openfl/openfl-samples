import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Clock extends Sprite
{
	public function new(location:String, color:UInt)
	{
		super();

		this.color = color;

		radius = 50.0;

		graphics.lineStyle(radius / 5.0, color);
		graphics.beginFill(color, 0.25);
		graphics.drawCircle(radius, radius, radius);
		graphics.endFill();

		label = new TextField();
		label.autoSize = LEFT;
		label.defaultTextFormat = new TextFormat("_sans", 18, 0x000000);
		label.text = location;
		addChild(label);

		var rect = getBounds(this);
		label.x = rect.x + (rect.width - label.width) / 2.0;
		label.y = rect.bottom + 4.0;

		hands = new Shape();
		addChild(hands);
	}

	private var radius:Float;
	private var color:UInt;
	private var label:TextField;
	private var hands:Shape;

	public function updateTime(time:Date):Void
	{
		var shortHandLength = radius / 2.0;
		var longHandsLength = 3.0 * radius / 4.0;

		hands.graphics.clear();

		var hours12 = time.getHours();
		if (hours12 >= 12)
		{
			hours12 -= 12;
		}
		var hoursDegrees = 360.0 * (hours12 / 12.0) - 90.0;
		var hoursRadians = hoursDegrees * Math.PI / 180.0;
		var hoursPos = Point.polar(shortHandLength, hoursRadians);
		hands.graphics.lineStyle(5.0, 0x000000);
		hands.graphics.moveTo(radius, radius);
		hands.graphics.lineTo(radius + hoursPos.x, radius + hoursPos.y);

		var minutesDegrees = 360.0 * (time.getMinutes() / 60.0) - 90.0;
		var minutesRadians = minutesDegrees * Math.PI / 180.0;
		var minutesPos = Point.polar(longHandsLength, minutesRadians);
		hands.graphics.lineStyle(4.0, 0x000000);
		hands.graphics.moveTo(radius, radius);
		hands.graphics.lineTo(radius + minutesPos.x, radius + minutesPos.y);

		var secondsDegrees = 360.0 * (time.getSeconds() / 60.0) - 90.0;
		var secondsRadians = secondsDegrees * Math.PI / 180.0;
		var secondsPos = Point.polar(longHandsLength, secondsRadians);
		hands.graphics.lineStyle(2.0, 0xff0000);

		hands.graphics.moveTo(radius, radius);
		hands.graphics.lineTo(radius + secondsPos.x, radius + secondsPos.y);
		hands.graphics.lineStyle();
		hands.graphics.beginFill(0xff0000);
		hands.graphics.drawCircle(radius, radius, 4.0);
	}
}
