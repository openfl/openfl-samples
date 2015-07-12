package;


import openfl.events.Event;


class CustomEvent extends Event {
	
	
	public static var TYPED_CUSTOM_EVENT = "typedCustomEvent";
	
	public var customData:Int;
	
	
	public function new (type:String, customData:Int, bubbles:Bool = false, cancelable:Bool = false) {
		
		this.customData = customData;
		
		super (type, bubbles, cancelable);
		
	}
	
	
	public override function clone ():CustomEvent {
		
		return new CustomEvent (type, customData, bubbles, cancelable);
		
	}
	
	
	public override function toString ():String {
		
		return "[CustomEvent type=\"" + type + "\" bubbles=" + bubbles + " cancelable=" + cancelable + " eventPhase=" + eventPhase + " customData=" + customData + "]";
		
	}
	
	
}