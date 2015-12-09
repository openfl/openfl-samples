package;


import openfl.display.Sprite;
import openfl.events.Event;

#if openfl_legacy
import openfl.events.JoystickEvent;
#else
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import openfl.events.GameInputEvent;
import openfl.ui.GameInput;
import openfl.ui.GameInputDevice;
import openfl.ui.GameInputControl;
#end


class Main extends Sprite {
	
	
	private var gamepadVisuals:Array<GamepadVisual>;
	private var joystickVisuals:Array<GamepadVisual>;
	
	#if !openfl_legacy
	private var gameInput:GameInput = new GameInput();
	private var gamepads:Array<GameInputDevice>;
	private var joysticks:Array<Joystick>;
	#end
	
	
	public function new () {
		
		super ();
		
		joystickVisuals = [];
		gamepadVisuals = [];
		
		#if openfl_legacy
		
		stage.addEventListener (JoystickEvent.AXIS_MOVE, legacy_onJoystickAxisMove);
		stage.addEventListener (JoystickEvent.BALL_MOVE, legacy_onJoystickBallMove);
		stage.addEventListener (JoystickEvent.BUTTON_DOWN, legacy_onJoystickButtonDown);
		stage.addEventListener (JoystickEvent.BUTTON_UP, legacy_onJoystickButtonUp);
		stage.addEventListener (JoystickEvent.HAT_MOVE, legacy_onJoystickHatMove);
		stage.addEventListener (JoystickEvent.DEVICE_REMOVED, legacy_onJoystickDeviceRemoved);
		stage.addEventListener (JoystickEvent.DEVICE_ADDED, legacy_onJoystickDeviceAdded);
		
		#else
		
		gamepads = [];
		joysticks = [];
		
		Joystick.onConnect.add (joystick_onConnect);
		
		gameInput = new GameInput ();
		gameInput.addEventListener (GameInputEvent.DEVICE_ADDED, gameInput_onDeviceAdded);
		gameInput.addEventListener (GameInputEvent.DEVICE_REMOVED, gameInput_onDeviceRemoved);
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		#end
		
	}
	
	
	#if !openfl_legacy
	
	public function addGamepadVisual (id:Int):Void {
		
		for (visual in gamepadVisuals) {
			
			if (visual.id == id) {
				
				return;
				
			}
			
		}
		
		var visual = new GamepadVisual ();
		
		for (device in gamepads) {
			
			var did = (device.id);
			
			#if flash
			
			var temp = device.id.split ("_");
			
			if (temp != null && temp.length > 0) {
				
				did = (temp[temp.length - 1]);
				
			}
			
			#end
			
			if (Std.string (id) == did) {
				
				visual.makeGamepad (device);
				gamepadVisuals.push (visual);
				
			}
			
		}
		
		addChild (visual);
		refresh ();
		
	}
	
	#end
	
	
	private function addJoystickVisual (id:Int):Void {
		
		for (visual in joystickVisuals) {
			
			if (visual.id == id) {
				
				return;
				
			}
			
		}
		
		var visual = new GamepadVisual ();
		
		visual.makeJoystick (id);
		joystickVisuals.push (visual);
		
		addChild (visual);
		refresh ();
		
	}
	
	
	private function refresh ():Void {
		
		var lasty = 10;
		var lastx = 10;
		var space = 50;
		
		for (i in 0...joystickVisuals.length) {
			
			joystickVisuals[i].x = lastx;
			joystickVisuals[i].y = lasty;
			lasty += space + 10;
			
		}
		
		lasty += 10;
		
		for (i in 0...gamepadVisuals.length) {
			
			gamepadVisuals[i].x = lastx;
			gamepadVisuals[i].y = lasty;
			lasty += space + 10;
			
		}
		
	}
	
	
	public function removeVisual (id:Int, visuals:Array<GamepadVisual>):Void {
		
		for (visual in visuals) {
			
			if (visual.id == id) {
				
				visuals.remove (visual);
				
				if (contains (visual)) {
					
					removeChild (visual);
					
				}
				
				visual.destroy ();
				break;
				
			}
			
		}
		
		refresh ();
		
	}
	
	
	public function updateVisual (deviceId:Int, type:String, id:Int, value:Float):Void {
		
		for (visual in joystickVisuals) {
			
			if (visual.id == deviceId) {
				
				visual.update (type, id, value);
				
			}
			
		}
		
		for (visual in gamepadVisuals) {
			
			if (visual.id == deviceId) {
				
				visual.update (type, id, value);
				
			}
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function gameInput_onDeviceAdded (event:GameInputEvent):Void {
		
		trace ("DEVICE ADDED");
		
		var device = event.device;
		device.enabled = true;
		
		gamepads.push (device);
		addGamepadVisual (Std.parseInt (device.id));
		
	}
	
	
	private function gameInput_onDeviceRemoved (event:GameInputEvent):Void {
		
		trace ("DEVICE REMOVED");
		
		var device = event.device;
		device.enabled = false;
		
		gamepads.remove (device);
		removeVisual (Std.parseInt (device.id), gamepadVisuals);
		
	}
	
	
	public function joystick_onAxisMove (joystick:Joystick, axis:Int, value:Float):Void {
		
		updateVisual (joystick.id, "axis", axis, value);
		
	}
	
	
	public function joystick_onButtonDown (joystick:Joystick, button:Int):Void {
		
		trace (joystick.id, button);
		updateVisual (joystick.id, "button", button, 1);
		
	}
	
	
	public function joystick_onButtonUp (joystick:Joystick, button:Int):Void {
		
		updateVisual (joystick.id, "button", button, 0);
		
	}
	
	
	public function joystick_onConnect (joystick:Joystick):Void {
		
		trace ("CONNECT JOYSTICK");
		
		trace (joystick);
		joystick.onButtonDown.add (function (id) { trace ("DOWN: " + id); } );
		
		joystick.onAxisMove.add (joystick_onAxisMove.bind (joystick));
		joystick.onButtonDown.add (joystick_onButtonDown.bind (joystick));
		joystick.onButtonUp.add (joystick_onButtonUp.bind (joystick));
		joystick.onDisconnect.add (joystick_onDisconnect.bind (joystick));
		joystick.onHatMove.add (joystick_onHatMove.bind (joystick));
		joystick.onTrackballMove.add (joystick_onTrackballMove.bind (joystick));
		
		joysticks.push (joystick);
		
		addJoystickVisual (joystick.id);
		
	}
	
	
	public function joystick_onDisconnect (joystick:Joystick):Void {
		
		trace ("DISCONNECT JOYSTICK");
		
		joysticks.remove (joystick);
		
		removeVisual (joystick.id, joystickVisuals);
		
	}
	
	
	public function joystick_onHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void {
		
		updateVisual (joystick.id, "hat", hat, position);
		
	}
	
	
	public function joystick_onTrackballMove (joystick:Joystick, trackball:Int, value:Float):Void {
		
		updateVisual (joystick.id, "ball", trackball, value);
		
	}
	
	
	#if openfl_legacy
	
	private function legacy_onJoystickAxisMove (event:JoystickEvent):Void {
		
		if (event.axis == null) return;
		
		for (i in 0...event.axis.length) {
			
			updateVisual (event.device, "axis", i, event.axis[i]);
			
		}
		
	}
	
	private function legacy_onJoystickBallMove (event:JoystickEvent):Void {
		
		updateVisual (event.device, "ball", 0, event.x);
		updateVisual (event.device, "ball", 1, event.y);
		
	}
	
	
	private function legacy_onJoystickButtonDown (event:JoystickEvent):Void {
		
		updateVisual (event.device, "button", event.id, 1);
		
	}
	
	
	private function legacy_onJoystickButtonUp (event:JoystickEvent):Void {
		
		updateVisual (event.device, "button", event.id, 0);
		
	}
	
	
	private function legacy_onJoystickDeviceAdded(event:JoystickEvent):Void {
		
		addJoystickVisual (event.device);
		
	}
	
	
	private function legacy_onJoystickDeviceRemoved(event:JoystickEvent):Void {
		
		removeVisual (event.device, joystickVisuals);
		
	}
	
	
	private function legacy_onJoystickHatMove(event:JoystickEvent):Void {
		
		updateVisual (event.device, "hat", 0, event.x);
		updateVisual (event.device, "hat", 1, event.y);
		
	}
	
	#end
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		for (device in gamepads) {
			
			for (i in 0...device.numControls) {
				
				var control:GameInputControl = device.getControlAt (i);
				var temp = control.id.split ("_");
				var type = temp[0].toLowerCase ();
				var id   = Std.parseInt (temp[1]);
				var deviceId = Std.parseInt (device.id);
				
				updateVisual (deviceId, type, id, control.value);
				
			}
		}
		
	}
	
	
}