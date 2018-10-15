package;


import openfl.display.Sprite;
import openfl.events.Event;

#if openfl_legacy
import openfl.events.JoystickEvent;
#else
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
#end


class Main extends Sprite {
	
	
	private var joystickVisuals:Array<GamepadVisual>;
	
	#if !openfl_legacy
	private var joysticks:Array<Joystick>;
	#end
	
	
	public function new () {
		
		super ();
		
		joystickVisuals = [];
		
		#if openfl_legacy
		
		stage.addEventListener (JoystickEvent.AXIS_MOVE, legacy_onJoystickAxisMove);
		stage.addEventListener (JoystickEvent.BALL_MOVE, legacy_onJoystickBallMove);
		stage.addEventListener (JoystickEvent.BUTTON_DOWN, legacy_onJoystickButtonDown);
		stage.addEventListener (JoystickEvent.BUTTON_UP, legacy_onJoystickButtonUp);
		stage.addEventListener (JoystickEvent.HAT_MOVE, legacy_onJoystickHatMove);
		stage.addEventListener (JoystickEvent.DEVICE_REMOVED, legacy_onJoystickDeviceRemoved);
		stage.addEventListener (JoystickEvent.DEVICE_ADDED, legacy_onJoystickDeviceAdded);
		
		#else
		
		joysticks = [];
		
		Joystick.onConnect.add (joystick_onConnect);
		
		#end
		
	}
	
	
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
	
	
	public function updateJoystickVisual (deviceId:Int, type:String, id:Int, value:Float):Void {
		
		for (visual in joystickVisuals) {
			
			if (visual.id == deviceId) {
				
				visual.update (type, id, value);
				
			}
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	#if !openfl_legacy
	
	
	public function joystick_onAxisMove (joystick:Joystick, axis:Int, value:Float):Void {
		
		updateJoystickVisual (joystick.id, "axis", axis, value);
		
	}
	
	
	public function joystick_onButtonDown (joystick:Joystick, button:Int):Void {
		
		updateJoystickVisual (joystick.id, "button", button, 1);
		
	}
	
	
	public function joystick_onButtonUp (joystick:Joystick, button:Int):Void {
		
		updateJoystickVisual (joystick.id, "button", button, 0);
		
	}
	
	
	public function joystick_onConnect (joystick:Joystick):Void {
		
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
		
		joysticks.remove (joystick);
		
		removeVisual (joystick.id, joystickVisuals);
		
	}
	
	
	public function joystick_onHatMove (joystick:Joystick, hat:Int, position:JoystickHatPosition):Void {
		
		updateJoystickVisual (joystick.id, "hat", hat, position);
		
	}
	
	
	public function joystick_onTrackballMove (joystick:Joystick, trackball:Int, x:Float, y:Float):Void {
		
		updateJoystickVisual (joystick.id, "ball", 0, x);
		updateJoystickVisual (joystick.id, "ball", 1, y);
		
	}
	
	
	#else
	
	
	private function legacy_onJoystickAxisMove (event:JoystickEvent):Void {
		
		if (event.axis == null) return;
		
		for (i in 0...event.axis.length) {
			
			updateJoystickVisual (event.device, "axis", i, event.axis[i]);
			
		}
		
	}
	
	private function legacy_onJoystickBallMove (event:JoystickEvent):Void {
		
		updateJoystickVisual (event.device, "ball", 0, event.x);
		updateJoystickVisual (event.device, "ball", 1, event.y);
		
	}
	
	
	private function legacy_onJoystickButtonDown (event:JoystickEvent):Void {
		
		updateJoystickVisual (event.device, "button", event.id, 1);
		
	}
	
	
	private function legacy_onJoystickButtonUp (event:JoystickEvent):Void {
		
		updateJoystickVisual (event.device, "button", event.id, 0);
		
	}
	
	
	private function legacy_onJoystickDeviceAdded(event:JoystickEvent):Void {
		
		addJoystickVisual (event.device);
		
	}
	
	
	private function legacy_onJoystickDeviceRemoved(event:JoystickEvent):Void {
		
		removeVisual (event.device, joystickVisuals);
		
	}
	
	
	private function legacy_onJoystickHatMove(event:JoystickEvent):Void {
		
		updateJoystickVisual (event.device, "hat", 0, event.x);
		updateJoystickVisual (event.device, "hat", 1, event.y);
		
	}
	
	
	#end
	
	
}