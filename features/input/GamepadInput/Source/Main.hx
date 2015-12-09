package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.StageDisplayState;

#if (html5 || flash || !lime_legacy)
	import openfl.events.GameInputEvent;
	import openfl.ui.GameInput;
	import openfl.ui.GameInputDevice;
	import openfl.ui.GameInputControl;
	import lime.ui.Joystick;
	import lime.ui.JoystickHatPosition;
#else
	import openfl.events.JoystickEvent;
#end
import openfl.events.Event;
import openfl.events.KeyboardEvent;


class Main extends Sprite {
	
	private var gamepadVisuals:Array<GamepadVisual>;
	private var joystickVisuals:Array<GamepadVisual>;
	private var traceAxis:Bool = true;
	
	#if (html5 || flash || !lime_legacy)
		private static var _gameInput:GameInput = new GameInput();
		private var gamepads:Array<GameInputDevice>;
		private var joysticks:Array<Joystick>;
	#end
	
	public function new () {
		
		joystickVisuals = [];
		gamepadVisuals = [];
		
		super ();
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, function(event:KeyboardEvent):Void {
			if (event.keyCode == 13) {
				traceAxis = !traceAxis;
				print("traceAxis = " + traceAxis);
			}
		});
		
		#if (html5 || flash || !lime_legacy)
		
		gamepads = [];
		_gameInput.addEventListener(GameInputEvent.DEVICE_ADDED, onDeviceAdded);
		_gameInput.addEventListener(GameInputEvent.DEVICE_REMOVED, onDeviceRemoved);
		
		stage.addEventListener(Event.ENTER_FRAME, onEnter);
		
		joysticks = [];
		Joystick.onConnect.add(onJoystickConnect);
		
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
	
	#if (html5 || flash || !lime_legacy)
	public function addGamepadVisual(id:Int):Void
	{
		if (gamepadVisuals == null)
		{
			gamepadVisuals = [];
		}
		for (visual in gamepadVisuals)
		{
			if (visual.id == id) {
				return;
			}
		}
		
		var visual = new GamepadVisual();
		
		for (device in gamepads)
		{
			var did = (device.id);
			#if flash
			var temp = device.id.split("_");
			if (temp != null && temp.length > 0)
			{
				did = (temp[temp.length - 1]);
			}
			#end
			if (Std.string(id) == did)
			{
				visual.makeGamepad(device);
				gamepadVisuals.push(visual);
			}
		}
		
		addChild(visual);
		refresh();
	}
	#end
	
	private function addJoystickVisual(id:Int):Void
	{
		if (joystickVisuals == null)
		{
			joystickVisuals = [];
		}
		for (visual in joystickVisuals)
		{
			if (visual.id == id) {
				return;
			}
		}
		
		var visual = new GamepadVisual();
		
		visual.makeJoystick(id);
		joystickVisuals.push(visual);
		
		addChild(visual);
		refresh();
	}
	
	public function removeVisual(id:Int, visuals:Array<GamepadVisual>):Void
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
		for (visual in joystickVisuals)
		{
			if (visual.id == deviceId)
			{
				visual.update(type, id, value);
			}
		}
		for (visual in gamepadVisuals)
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
		
		for (i in 0...joystickVisuals.length)
		{
			joystickVisuals[i].x = lastx;
			joystickVisuals[i].y = lasty;
			lasty += space + 10;
		}
		
		lasty += 10;
		
		for (i in 0...gamepadVisuals.length)
		{
			gamepadVisuals[i].x = lastx;
			gamepadVisuals[i].y = lasty;
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
	
	#if (html5 || flash || !lime_legacy)
	
	private function onEnter(event:Event):Void
	{
		for (device in gamepads)
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
		device.enabled = true;
		print("Added    device: " + device.name + " id: " + device.id + " enabled: " + device.enabled);
		addDevice(device);
	}
	
	private function onDeviceRemoved(event:GameInputEvent):Void
	{
		var device = event.device;
		device.enabled = false;
		print("Removed  device: " + device.name + " id: " + device.id);
		removeDevice(device);
	}
	
	public function onJoystickConnect (joystick:Joystick):Void { 
		addJoystick(joystick);
	};
	public function onJoystickAxisMove (joystick:Joystick, axis:Int, value:Float):Void { 
		updateVisual(joystick.id, "axis", axis, value);
	};
	public function onJoystickButtonDown (joystick:Joystick, button:Int):Void {
		updateVisual(joystick.id, "button", button, 1);
	};
	public function onJoystickButtonUp (joystick:Joystick, button:Int):Void {
		updateVisual(joystick.id, "button", button, 0);
	};
	public function onJoystickDisconnect (joystick:Joystick):Void { 
		removeJoystick(joystick);
	};
	public function onJoystickHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void { 
		updateVisual(joystick.id, "hat", hat, position);
	};
	public function onJoystickTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void { 
		updateVisual(joystick.id, "ball", trackball, value);
	};
	
	private function addJoystick(joystick:Joystick)
	{
		for (j in joysticks)
		{
			if (j.id == joystick.id)
			{
				return;
			}
		}
		
		joystick.onAxisMove.add     (function(axis:Int, value:Float)                { onJoystickAxisMove     (joystick, axis, value);       } );
		joystick.onButtonDown.add   (function(button:Int)                           { onJoystickButtonDown   (joystick, button);            } );
		joystick.onButtonUp.add     (function(button:Int)                           { onJoystickButtonUp     (joystick, button);            } );
		joystick.onHatMove.add      (function(hat:Int,position:JoystickHatPosition) { onJoystickHatMove      (joystick, hat, position);     } );
		joystick.onTrackballMove.add(function(trackball:Int, value:Float)           { onJoystickTrackballMove(joystick, trackball, value);  } );
		joystick.onDisconnect.add   (function()                                     { onJoystickDisconnect   (joystick);                    } );
		
		joysticks.push(joystick);
		addJoystickVisual(joystick.id);
	}
	
	private function removeJoystick(joystick:Joystick)
	{
		for (j in joysticks)
		{
			if (j.id == joystick.id)
			{
				joysticks.remove(j);
				
				for (l in j.onAxisMove.listeners)      { j.onAxisMove.remove(l);      }
				for (l in j.onButtonDown.listeners)    { j.onButtonDown.remove(l);    }
				for (l in j.onButtonUp.listeners)      { j.onButtonUp.remove(l);      }
				for (l in j.onHatMove.listeners)       { j.onHatMove.remove(l);       }
				for (l in j.onTrackballMove.listeners) { j.onTrackballMove.remove(l); }
				for (l in j.onDisconnect.listeners)    { j.onDisconnect.remove(l);    }
				
				removeVisual(joystick.id, joystickVisuals);
				return;
			}
		}
	}
	
	private function addDevice(device:GameInputDevice)
	{
		for (d in gamepads)
		{
			if (d.id == device.id)
			{
				return;
			}
		}
		gamepads.push(device);
		addGamepadVisual(Std.parseInt(device.id));
	}
	
	private function removeDevice(device:GameInputDevice)
	{
		for (d in gamepads)
		{
			if (d.id == device.id)
			{
				gamepads.remove(d);
				removeVisual(Std.parseInt(device.id), gamepadVisuals);
				return;
			}
		}
	}
	
	#else
	
	private function handleAxisMove(event:JoystickEvent):Void
	{
		if (traceAxis)
		{
			print("MoveAxis joystick: " + event.device + prettyAxis(event.axis));
		}
		if (event.axis == null) return;
		for (i in 0...event.axis.length)
		{
			updateVisual(event.device, "axis", i, event.axis[i]);
		}
	}
	
	private function handleBallMove(event:JoystickEvent):Void
	{
		print("MoveBall  joystick: " + event.device + " " + prettyInt(Std.int(event.x)) + "," + prettyInt(Std.int(event.y)));
		updateVisual(event.device, "ball", 0, event.x);
		updateVisual(event.device, "ball", 1, event.y);
	}
	
	private function handleButtonDown(event:JoystickEvent):Void
	{
		print("BtnDown  joystick: " + event.device + " " + event.id);
		updateVisual(event.device, "button", event.id, 1);
	}
	
	private function handleButtonUp(event:JoystickEvent):Void
	{
		print("BtnUp    joystick: " + event.device + " " + event.id);
		updateVisual(event.device, "button", event.id, 0);
	}
	
	private function handleHatMove(event:JoystickEvent):Void
	{
		print("HatMove  joystick: " + event.device + " " + prettyInt(Std.int(event.x)) + "," + prettyInt(Std.int(event.y)));
		updateVisual(event.device, "hat", 0, event.x);
		updateVisual(event.device, "hat", 1, event.y);
	}
	
	private function handleDeviceRemoved(event:JoystickEvent):Void
	{
		print("Removed  joystick: " + event.device);
		removeVisual(event.device, joystickVisuals);
	}
	
	private function handleDeviceAdded(event:JoystickEvent):Void
	{
		print("Added    joystick: " + event.device);
		addJoystickVisual(event.device);
	}
	
	#end
	
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
}