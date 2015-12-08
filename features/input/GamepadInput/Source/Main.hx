package;


import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.StageDisplayState;
#if lime_legacy
	import openfl.events.JoystickEvent;
#else
	import openfl.events.GameInputEvent;
	import openfl.ui.GameInput;
	import openfl.ui.GameInputDevice;
	import openfl.ui.GameInputControl;
#end
import openfl.events.Event;
import openfl.events.KeyboardEvent;


class Main extends Sprite {
	
	private var visuals:Array<GamepadVisual>;
	private var traceAxis:Bool = true;
	
	#if !lime_legacy
		private static var _gameInput:GameInput = new GameInput();
		private var devices:Array<GameInputDevice>;
	#end
	
	
	public function new () {
		
		super ();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):Void {
			if (event.keyCode == 13) {
				traceAxis = !traceAxis;
				print("traceAxis = " + traceAxis);
			}
		});
		
		#if !lime_legacy
		devices = [];
		_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, onDeviceAdded);
		_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, onDeviceRemoved);
		stage.addEventListener(Event.ENTER_FRAME, onEnter);
		#else
		stage.addEventListener(JoystickEvent.AXIS_MOVE, handleAxisMove);
		stage.addEventListener(JoystickEvent.BALL_MOVE, handleBallMove);
		stage.addEventListener(JoystickEvent.BUTTON_DOWN, handleButtonDown);
		stage.addEventListener(JoystickEvent.BUTTON_UP, handleButtonUp);
		stage.addEventListener(JoystickEvent.HAT_MOVE, handleHatMove);
		stage.addEventListener(JoystickEvent.DEVICE_REMOVED, handleDeviceRemoved);
		stage.addEventListener(JoystickEvent.DEVICE_ADDED, handleDeviceAdded);
		#end
	}
	
	public function addVisual(id:Int):Void
	{
		if (visuals == null)
		{
			visuals = [];
		}
		for (visual in visuals)
		{
			if (visual.id == id) return;
		}
		
		var visual = new GamepadVisual();
		
		#if !lime_legacy
		for (device in devices)
		{
			if (device.id == Std.string(id))
			{
				visual.makeNext(device);
				visuals.push(visual);
			}
		}
		#else
		visual.makeLegacy(id);
		visuals.push(visual);
		#end
		
		addChild(visual);
		refresh();
	}
	
	public function removeVisual(id:Int):Void
	{
		if (visuals == null) return;
		
		for (visual in visuals)
		{
			if (visual.id == id)
			{
				visuals.remove(visual);
				if (contains(visual))
				{
					removeChild(visual);
				}
				visual.destroy();
				break;
			}
		}
		refresh();
	}
	
	public function updateVisual(deviceId:Int, type:String, id:Int, value:Float):Void
	{
		for (visual in visuals)
		{
			if (visual.id == deviceId)
			{
				visual.update(type, id, value);
			}
		}
	}
	
	private function refresh():Void {
		var lasty = 10;
		var lastx = 10;
		var space = 50;
		
		for (i in 0...visuals.length)
		{
			visuals[i].x = lastx;
			visuals[i].y = lasty;
			lasty += space + 10;
		}
	}
	
	private function print(str:String):Void
	{
		#if sys
		Sys.println(str);
		#else
		trace(str);
		#end
	}
	
	#if !lime_legacy
	
	private function onEnter(event:Event):Void
	{
		for (device in devices)
		{
			for (i in 0...device.numControls)
			{
				var control:GameInputControl = device.getControlAt(i);
				var temp = control.id.split("_");
				var type = temp[0].toLowerCase();
				var id   = Std.parseInt(temp[1]);
				var deviceId = Std.parseInt(device.id);
				updateVisual(deviceId, type, id, control.value);
			}
		}
	}
	
	private function onDeviceAdded(event:GameInputEvent):Void
	{
		var device = event.device;
		print("Added    device: " + device.name + " id: " + device.id + " enabled: " + device.enabled);
		addDevice(device);
	}
	
	private function onDeviceRemoved(event:GameInputEvent):Void
	{
		var device = event.device;
		print("Removed  device: " + device.name + " id: " + device.id);
		removeDevice(device);
	}
	
	private function addDevice(device:GameInputDevice)
	{
		for (d in devices)
		{
			if (d.id == device.id)
			{
				return;
			}
		}
		devices.push(device);
		addVisual(Std.parseInt(device.id));
	}
	
	private function removeDevice(device:GameInputDevice)
	{
		for (d in devices)
		{
			if (d.id == device.id)
			{
				devices.remove(d);
				removeVisual(Std.parseInt(device.id));
				return;
			}
		}
	}
	
	#else
	
	private function handleAxisMove(event:JoystickEvent):Void
	{
		if (traceAxis)
		{
			print("MoveAxis device: " + event.device + prettyAxis(event.axis));
		}
		if (event.axis == null) return;
		for (i in 0...event.axis.length)
		{
			updateVisual(event.device, "axis", i, event.axis[i]);
		}
	}
	
	private function handleBallMove(event:JoystickEvent):Void
	{
		print("MoveBall  device: " + event.device + " " + prettyInt(Std.int(event.x)) + "," + prettyInt(Std.int(event.y)));
		updateVisual(event.device, "ball", 0, event.x);
		updateVisual(event.device, "ball", 1, event.y);
	}
	
	private function handleButtonDown(event:JoystickEvent):Void
	{
		print("BtnDown  device: " + event.device + " " + event.id);
		updateVisual(event.device, "button", event.id, 1);
	}
	
	private function handleButtonUp(event:JoystickEvent):Void
	{
		print("BtnUp    device: " + event.device + " " + event.id);
		updateVisual(event.device, "button", event.id, 0);
	}
	
	private function handleHatMove(event:JoystickEvent):Void
	{
		print("HatMove  device: " + event.device + " " + prettyInt(Std.int(event.x)) + "," + prettyInt(Std.int(event.y)));
		updateVisual(event.device, "hat", 0, event.x);
		updateVisual(event.device, "hat", 1, event.y);
	}
	
	private function handleDeviceRemoved(event:JoystickEvent):Void
	{
		print("Removed  device: " + event.device);
		removeVisual(event.device);
	}
	
	private function handleDeviceAdded(event:JoystickEvent):Void
	{
		print("Added    device: " + event.device);
		addVisual(event.device);
	}
	
	private function prettyAxis(axis:Array<Float>):String
	{
		var returnStr = "";
		for (f in axis)
		{
			var str = Std.string(Std.int(f * 100) / 100);
			if (f >= 0)
			{
				str = " " + str;
			}
			if (str.indexOf(".") == -1)
			{
				str = str + ".";
			}
			str = StringTools.rpad(str, "0", 5);
			returnStr = returnStr + " " + str;
		}
		return returnStr;
	}
	
	private function prettyInt(i:Int):String
	{
		var s = Std.string(i);
		if (i >= 0)
		{
			s = " " + s;
		}
		return s;
	}
	#end
	
}