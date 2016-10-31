package piratepig;


import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;


class GamepadWrapper {
	
	
	public var a:ButtonState;
	public var b:ButtonState;
	public var down:ButtonState;
	public var device:GameInputDevice;
	public var left:ButtonState;
	public var right:ButtonState;
	public var up:ButtonState;
	public var x:ButtonState;
	public var y:ButtonState;
	
	
	public function new (device:GameInputDevice) {
		
		this.device = device;
		
		up = new ButtonState ();
		down = new ButtonState ();
		left = new ButtonState ();
		right = new ButtonState ();
		
		a = new ButtonState ();
		b = new ButtonState ();
		x = new ButtonState ();
		y = new ButtonState ();
		
	}
	
	
	public function destroy ():Void {
		
		device = null;
		
	}
	
	
	public function update ():Void {
		
		for (i in 0...device.numControls) {
			
			var control:GameInputControl = device.getControlAt (i);
			
			var state:ButtonState = switch (control.id) {
				
				case "BUTTON_11": up;
				case "BUTTON_12": down;
				case "BUTTON_13": left;
				case "BUTTON_14": right;
				case "BUTTON_0": a;
				case "BUTTON_1": b;
				case "BUTTON_2": x;
				case "BUTTON_3": y;
				default: null;
				
			}
			
			if (state != null) {
				
				if (control.value <= 0) {
					
					state.release ();
					
				} else {
					
					state.press ();
				}
				
			}
			
		}
		
	}
	
}


class ButtonState {
	
	
	public var pressed (default, null):Bool;
	public var justPressed (default, null):Bool;
	public var justReleased (default, null):Bool;
	
	
	public function new ():Void {
		
		pressed = false;
		justPressed = false;
		justReleased = false;
		
	}
	
	
	public function press ():Void {
		
		if (!pressed) {
			
			justPressed = true;
			
		} else {
			
			justPressed = false;
			
		}
		
		pressed = true;
		justReleased = false;
		
	}
	
	
	public function release ():Void {
		
		if (pressed) {
			
			justReleased = true;
			
		} else {
			
			justReleased = false;
			
		}
		
		pressed = false;
		justPressed = false;
		
	}
	
	
	public function update ():Void {
		
		justPressed = false;
		justReleased = false;
		
	}
	
	
}