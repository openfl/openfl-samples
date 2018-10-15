package;
import openfl.display.Sprite;
#if !lime_legacy
	import openfl.ui.GameInputControl;
	import openfl.ui.GameInputDevice;
#end
import openfl.text.TextField;

/**
 * ...
 * @author larsiusprime
 */
class GamepadVisual extends Sprite
{
	public var id:Int;
	private var controls:Array<GamepadControlVisual>;
	private var label:TextField;
	
	public function new() 
	{
		super();
	}
	
	public function destroy():Void
	{
		controls = [];
		for (i in 0...numChildren)
		{
			removeChildAt(0);
		}
	}
	
	public function update(type:String, id:Int, value:Float):Void
	{
		for (control in controls)
		{
			if (control.type == type && control.id == id)
			{
				control.value = value;
			}
		}
	}
	
	public function makeJoystick(deviceId:Int)
	{
		id = deviceId;
		var arr = [];
		for (i in 0...6)
		{
			arr.push( { type:"axis", id:i, label:"axis" + i } );
		}
		arr = arr.concat(
		[
			#if lime_legacy
			{type:"hat",  id:0, label:"hat.x" },
			{type:"hat",  id:1, label:"hat.y" },
			#else
			{type:"hat",  id:0, label:"hat" },
			#end
			{type:"ball", id:0, label:"ball.x" },
			{type:"ball", id:1, label:"ball.y" }
		]);
		for (i in 0...15) {
			arr.push(
				{type:"button", id:i, label:"bn"+Std.string(i) }
			);
		}
		fromArray(30, 0, 0, 1, arr, "Joystick #" + deviceId);
	}
	
	#if (flash || html5 || !lime_legacy)
	public function makeGamepad(device:GameInputDevice)
	{
		id = Std.parseInt(device.id);
		var arr = [];
		for (i in 0...device.numControls)
		{
			var control:GameInputControl = device.getControlAt(i);
			var temp = control.id.split("_");
			var type = temp[0].toLowerCase();
			var id   = Std.parseInt(temp[1]);
			var str = switch(type) {
				case "axis"  : "axis";
				case "button": "bn";
				default      : type;
			}
			arr.push( { type:type, id:id, label:str + Std.string(id) } );
		}
		fromArray(30, 5, 5, 2, arr, "Device #" + device.id + " = " + device.name);
	}
	#end
	
	private function fromArray(size:Int, offx:Int, offy:Int, spacex:Int, arr:Array<{type:String,id:Int,label:String}>, name:String):Void
	{
		
		label = new TextField();
		label.text = name;
		addChild(label);
		
		controls = [];
		var lastx = offx;
		var lasty = 18;
		
		for (thing in arr)
		{
			var control = new GamepadControlVisual(size, thing.type, thing.id, thing.label);
			control.x = lastx;
			control.y = lasty + offy;
			lastx += Std.int(control.width) + spacex;
			addChild(control);
			controls.push(control);
		}
		
		label.width = width;
		label.height = 18;
	}
	
}