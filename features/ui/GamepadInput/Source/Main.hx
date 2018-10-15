package;


import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.GameInputEvent;
import openfl.ui.GameInput;
import openfl.ui.GameInputDevice;
import openfl.ui.GameInputControl;


class Main extends Sprite {
	
	
	private var gamepadVisuals:Array<GamepadVisual>;
	private var gameInput:GameInput = new GameInput();
	private var gamepads:Array<GameInputDevice>;
	
	
	public function new () {
		
		super ();
		
		gamepadVisuals = [];
		
		gamepads = [];
		
		gameInput = new GameInput ();
		gameInput.addEventListener (GameInputEvent.DEVICE_ADDED, gameInput_onDeviceAdded);
		gameInput.addEventListener (GameInputEvent.DEVICE_REMOVED, gameInput_onDeviceRemoved);
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
	}
	
	
	public function addGamepadVisual (id:String):Void {
		
		for (visual in gamepadVisuals) {
			
			if (visual.id == id) {
				
				return;
				
			}
			
		}
		
		var visual = new GamepadVisual ();
		
		for (device in gamepads) {
			
			visual.makeGamepad (device);
			gamepadVisuals.push (visual);
			
		}
		
		addChild (visual);
		refresh ();
		
	}
	
	
	private function refresh ():Void {
		
		var lasty = 10;
		var lastx = 10;
		var space = 50;
		
		for (i in 0...gamepadVisuals.length) {
			
			gamepadVisuals[i].x = lastx;
			gamepadVisuals[i].y = lasty;
			lasty += space + 10;
			
		}
		
	}
	
	
	public function removeVisual (id:String, visuals:Array<GamepadVisual>):Void {
		
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
	
	
	public function updateGamepadVisual (deviceId:String, type:String, id:Int, value:Float):Void {
		
		for (visual in gamepadVisuals) {
			
			if (visual.id == deviceId) {
				
				visual.update (type, id, value);
				
			}
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function gameInput_onDeviceAdded (event:GameInputEvent):Void {
		
		var device = event.device;
		device.enabled = true;
		
		gamepads.push (device);
		addGamepadVisual (device.id);
		
	}
	
	
	private function gameInput_onDeviceRemoved (event:GameInputEvent):Void {
		
		var device = event.device;
		device.enabled = false;
		
		gamepads.remove (device);
		removeVisual (device.id, gamepadVisuals);
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		for (device in gamepads) {
			
			for (i in 0...device.numControls) {
				
				var control:GameInputControl = device.getControlAt (i);
				var temp = control.id.split ("_");
				var type = temp[0].toLowerCase ();
				var id   = Std.parseInt (temp[1]);
				
				updateGamepadVisual (device.id, type, id, control.value);
				
			}
		}
		
	}
	
	
}