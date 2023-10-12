import openfl.display.Sprite;
import openfl.events.TimerEvent;
import openfl.utils.Timer;

class Main extends Sprite
{
	private var newYorkClock:Clock;
	private var londonClock:Clock;
	private var tokyoClock:Clock;

	public function new()
	{
		super();

		newYorkClock = new Clock("New York", 0xcc0000);
		newYorkClock.x = 10.0;
		newYorkClock.y = 10.0;
		addChild(newYorkClock);

		londonClock = new Clock("London", 0x009900);
		londonClock.x = 130.0;
		londonClock.y = 10.0;
		addChild(londonClock);

		tokyoClock = new Clock("Tokyo", 0x0000cc);
		tokyoClock.x = 250.0;
		tokyoClock.y = 10.0;
		addChild(tokyoClock);

		updateClocks();

		var timer = new Timer(1000.0, 0);
		timer.addEventListener(TimerEvent.TIMER, event ->
		{
			updateClocks();
		});
		timer.start();
	}

	private function updateClocks():Void
	{
		var currentLocalTime = Date.now();
		var newYorkTime = dateToTimeZoneOffset(currentLocalTime, -4);
		var londonTime = dateToTimeZoneOffset(currentLocalTime, 1);
		var tokyoTime = dateToTimeZoneOffset(currentLocalTime, 9);

		newYorkClock.updateTime(newYorkTime);
		londonClock.updateTime(londonTime);
		tokyoClock.updateTime(tokyoTime);
	}

	private function dateToTimeZoneOffset(date:Date, targetOffset:Int):Date
	{
		var utcHours = date.getUTCHours();
		var adjustedHours = utcHours + targetOffset;
		return new Date(date.getFullYear(), date.getMonth(), date.getDate(), adjustedHours, date.getMinutes(), date.getSeconds());
	}
}
